// TurboFMpro project
// (C) NedoPC
	
module TurboFMpro
(
	//global clock 28Mhz
	input fclk,
	
	// databus (from AY)
	inout  wire  [7:0] ayd,
	
	// databus (to YM, SAA)
	inout  wire  [7:0] d,
	
	// controls (from AY)
	input  wire        ayres_n,
	input  wire        aybc1,
	input  wire        aybc2,
	input  wire        aybdir,
	input  wire        aya8,
	input  wire        aya9_n,

	// modes
	input  wire        mode_enable_saa,   //0 - saa disabled (board equal TurboFM)
	input  wire        mode_enable_ymfm,  //0 - single AY mode (no two AY, no FM, no SAA)
	
	// control YM2203
	output  wire       ymclk,   //3.5Mhz
	output  wire       ymcs1_n, //select first chip
	output  wire       ymcs2_n, //select second chip
	output  wire       ymrd_n,  //write
	output  wire       ymwr_n,  //read
	output  wire       yma0,
	input   wire       ymop1, //dac data from first chip
	input   wire       ymop2, //dac data from second chip
	output  wire       ymop1d, //to fisrt dac
	output  wire       ymop2d, //to second dac

	// control SAA
	output  wire       saaclk, //8Mhz
	output  wire       saacs_n, //chip select
	output  wire       saawr_n, //chip write
	output  wire       saaa0 //register/adress select

); 
	reg  [3:0] conf;
	reg  [2:0] ymcounter=3'd0;
	reg  [2:0] possaacounter=3'd0;
	reg  [2:0] negsaacounter=3'd0;
	
	wire confwr_n;
	wire enable;
	
	//assign confwr_n = ~(aybc2 & aybc1 & aybdir & ayd[7] & ayd[6] & ayd[5] & ayd[4] & (ayd[3]|(~mode_enable_saa)) & mode_enable_ymfm); 
	assign confwr_n = ~(aybc2 & aybc1 & aybdir & ayd[7] & ayd[6] & ayd[5] & ayd[4]);  // lvd

	// configuration register set
	// conf[0] - YM curchip select ( 0 - select D0, 1 - select D1 )
	// conf[1] - YM stat reg select ( 1 - read register, 0 - read status )
	// conf[2] - YM fm part disable ( 0 - enable, 1 - disable )
	// conf[3] - SAA enable ( 0 - enable, 1 - disable )
	
	//always @ ( negedge ayres_n, negedge confwr_n )
	always @ ( negedge ayres_n, posedge confwr_n ) // lvd
	begin
		if( !ayres_n ) 
			//reset to default
			conf <= 4'b1110;
		else 
		begin
			//set register
			//conf <= ayd[3:0];
			if( !mode_enable_ymfm )
				conf <= 4'b1110;
			else if( !mode_enable_saa )
				conf <= {1'b1,ayd[2:0]};
			else
				conf <= ayd[3:0];
		end
	end

	//  YM control functional
	//==========================
	
	// ymclk = 28Mhz/8 = 3.5Mhz
	always @ ( posedge fclk )
	begin
		ymcounter <= ymcounter+3'b001;
	end
	assign ymclk = ymcounter[2];
	
	// FM disable/enable
	assign ymop1d = ((~mode_enable_ymfm)|conf[2])?1'b0:ymop1;
	assign ymop2d = ((~mode_enable_ymfm)|conf[2])?1'b0:ymop2;
	
	// control signals decoding 
	//     YM/AY                         YM2203                     
	//  BDIR  BC2  BC1  A8  _A9      _WR  _RD  A0                   
	//   0     0    0   1    0         inactive                     
	//   0     0    1   1    0        0    1   0   (write address)  
	//   0     1    0   1    0         inactive                     
	//   0     1    1   1    0        1    0   1   (read register)  
	//   1     0    0   1    0        0    1   0   (write address)  
	//   1     0    1   1    0         inactive                     
	//   1     1    0   1    0        0    1   1   (write register) 
	//   1     1    1   1    0        0    1   0   (write address)  
	//          other                  inactive                     
    // used only BC2=1 modes, BC2=0 ignored  
	assign enable = aybc2 & (aybc1 | aybdir);
	
	// for CS used only static signals
	assign ymcs1_n = mode_enable_ymfm & ( ~( confwr_n & (~conf[0]) & aya8 & (~aya9_n) & (conf[3]|~mode_enable_saa) ) );
	assign ymcs2_n = ~( confwr_n & conf[0] & aya8 & (~aya9_n) & (conf[3]|~mode_enable_saa) & mode_enable_ymfm);
	
	assign ymwr_n = ~( aybdir & enable );
	assign ymrd_n = ~( (~aybdir) & enable );
	
 	assign yma0 = ( (~aybdir) & (conf[1]|(~mode_enable_ymfm)) ) | ( aybdir & (~aybc1) ) ;

	// SAA control functional
	//==========================
	
	// saaclk = 28Mhz/3.5 = 8Mhz
	always @ ( posedge fclk )
	begin
		if( negsaacounter == 3 )
		begin
			possaacounter <= 3'b000;
		end
		else if( possaacounter[2] & negsaacounter[2] )
		begin
			//protection from stopping (if both counters >3 on init)
			possaacounter <= 3'b000;
		end
		else if( possaacounter < 4 )
		begin
			possaacounter <= possaacounter+3'b001;
		end
	end
	always @ ( negedge fclk )
	begin
		if( possaacounter == 3 )
		begin
			negsaacounter <= 3'b000;
		end
		else
		if( negsaacounter < 4 )
		begin
			negsaacounter <= negsaacounter+3'b001;
		end
	end
	assign saaclk = (possaacounter[1]|negsaacounter[1]) & (~conf[3]) & mode_enable_saa & mode_enable_ymfm;	//disable clock if saa disabled
	
	// for CS used only static signals
	assign saacs_n = ~( confwr_n & aya8 & (~aya9_n) & (~conf[3]) & mode_enable_saa & mode_enable_ymfm );
	
	assign saawr_n = ymwr_n;
	
	assign saaa0 = ~( aybdir & (~aybc1) );
	
	// Internal bus logic
	//==========================
	assign d = ( aybdir == 1 ) ? ayd : 8'bZZZZZZZZ;
	assign ayd = ( ((~aybdir)&enable) == 1 ) ? d : 8'bZZZZZZZZ;
	
endmodule
