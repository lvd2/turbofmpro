// testbench for TurboFMpro rtl
// (c) NedoPC 2018

`timescale 1ns/1ps


`define CLK14_HALFPERIOD (35.000) /* to make it more async */
`define CLK56_HALFPERIOD (8.929)

module tb;


	// board config
	reg [3:0] portcfg = 4'hF;
	// conf[0] - YM curchip select ( 0 - select D0, 1 - select D1, !!!1 after reset!!! )
	// conf[1] - YM stat reg select ( 1 - read register, 0 - read status )
	// conf[2] - YM fm part disable ( 0 - enable, 1 - disable )
	// conf[3] - SAA enable ( 0 - enable, 1 - disable )
	//
	reg mode_enable_saa  = 1'b1, //0 - saa disabled (board equals to TurboFM)
	    mode_enable_ymfm = 1'b1; //0 - single AY mode (no two AY, no FM, no SAA)



	reg zclk, fclk;

	reg rst_n;

	wire aybc1,
	     aybc2,
	     aybdir,
	     aya8,
	     aya9_n;


	wire ymclk,
	     ymcs1_n,
	     ymcs2_n,
	     ymrd_n,
	     ymwr_n,
	     yma0,
	     ymop1,
	     ymop2,
	     ymop1d,
	     ymop2d;

	wire saaclk,
	     saacs_n,
	     saawr_n,
	     saaa0;


	wire [7:0] d; // internal YM/SAA bus


	// cpu simulation
	reg mreq_n,iorq_n,rd_n,wr_n;
	reg  [15:0] zaddr;
	wire [ 7:0] zdata;
	reg  [ 7:0] zdout;
	reg         zdena;


	// ym test data
	wire [7:0] ym_adr    [0:1];
	wire [7:0] ym_wrdat  [0:1];
	reg  [7:0] ym_rddat  [0:1];
	reg  [7:0] ym_rdstat [0:1];




	reg [7:0] ym_reg [0:1] = '{8'hFF,8'hFF}; 
	reg [7:0] saa_reg = 8'hFF;




	// 14MHz clock
	initial
	begin
		zclk = 1'b0;

		forever #(`CLK14_HALFPERIOD) zclk = ~zclk;
	end

	// 28MHz clock
	initial
	begin
		fclk = 1'b0;

		forever #(`CLK56_HALFPERIOD) fclk = ~fclk;
	end



	// reset
	initial
	begin
		rst_n = 1'b0;
		iorq_n = 1'b1;
		wr_n   = 1'b1;
		rd_n   = 1'b1;
		zaddr  = 16'd0;
		repeat(5) @(posedge fclk);
		rst_n <= 1'b1;
	end





	// zdata control
	assign zdata = zdena ? zdout : 8'hZZ;

	// ay access control
	ay_access ay_access
	(
		.a     (zaddr),
		.iorq_n(iorq_n),
		.wr_n  (wr_n),
		.rd_n  (rd_n),

		.bdir(aybdir),
		.bc1 (aybc1),
		.bc2 (aybc2),
		.a8  (aya8),
		.a9_n(aya9_n)
	);

	// saa accesses check
	saa_checker saa_checker
	(
		.cs_n(saacs_n),
		.wr_n(saawr_n),
		.a0(saaa0),
		.d(d)
	);

	// ym access checkers
	ym_checker ym1
	(
		.cs_n(ymcs1_n),
		.rd_n(ymrd_n),
		.wr_n(ymwr_n),
		.a0  (yma0),
		.d   (d),

		.rddat (ym_rddat [0]),
		.rdstat(ym_rdstat[0]),
		.adr   (ym_adr   [0]),
		.wrdat (ym_wrdat [0])
	);
	//	
	ym_checker ym2
	(
		.cs_n(ymcs2_n),
		.rd_n(ymrd_n),
		.wr_n(ymwr_n),
		.a0  (yma0),
		.d   (d),

		.rddat (ym_rddat [1]),
		.rdstat(ym_rdstat[1]),
		.adr   (ym_adr   [1]),
		.wrdat (ym_wrdat [1])
	);





	// DUT connection
	top DUT
	(
		.fclk(fclk),
		
		.ayd(zdata),
		.d  (d),
        
		.ayres_n(rst_n),
		.aybc1  (aybc1  ),
		.aybc2  (aybc2  ),
		.aybdir (aybdir ),
		.aya8   (aya8   ),
		.aya9_n (aya9_n ),
        
		.mode_enable_saa (mode_enable_saa ),
		.mode_enable_ymfm(mode_enable_ymfm),
		
		.ymclk  (ymclk  ),
		.ymcs1_n(ymcs1_n),
		.ymcs2_n(ymcs2_n),
		.ymrd_n (ymrd_n ),
		.ymwr_n (ymwr_n ),
		.yma0   (yma0   ),
		.ymop1  (ymop1  ),
		.ymop2  (ymop2  ),
		.ymop1d (ymop1d ),
		.ymop2d (ymop2d ),
        
		.saaclk (saaclk ),
		.saacs_n(saacs_n),
		.saawr_n(saawr_n),
		.saaa0  (saaa0  )
	);











	// test script
	initial
	begin
		wait(rst_n===1'b1);
		repeat(5) @(posedge zclk);


		wr_num(8'hFF); // initialization of regnum


		forever
		begin
			do_rnd_test(1000);

			repeat(5) @(posedge zclk);
			mode_enable_ymfm = $random()>>31;
			mode_enable_saa  = $random()>>31;
			repeat(5) @(posedge zclk);
		end


	



/*
		wr_num(8'hF7);
		test_saa_write();

		wr_num(8'hfe);
		test_ym_write(0);
		test_ym_read(0,1);

		wr_num(8'hfc);
		test_ym_write(0);
		test_ym_read(0,0);

		wr_num(8'hff);
		test_ym_write(1);
		test_ym_read(1,1);

		wr_num(8'hfd);
		test_ym_write(1);
		test_ym_read(1,0);

		$display("finished!");
		$stop();
*/
	end







	task do_rnd_test;
		input int iterations;

		reg [7:0] rdt;

		repeat(iterations)
		begin

			if( $random()>32'hF000_0000 )
				wr_num( $random()>>24 );
			else if( $random()>>31 )
			begin
				wr_dat( $random()>>24 );
			end
			else
			begin
				rd_dat();
			end
		end

	endtask



















////////////////////////////////////////////////////////////////////////////////


	// tasks for bffd/fffd port control
	task wr_num;
		input [7:0] num;
		iowr(16'hFFFD,num);

		if( num>=8'hF0 )
			portcfg = num[3:0];
		else if( !portcfg[3] && mode_enable_saa && mode_enable_ymfm )
			saa_reg = num;
		else if( mode_enable_ymfm && !portcfg[0] )
			ym_reg[0] = num;
		else
			ym_reg[1] = num;
	endtask




	task wr_dat;
		input [7:0] dat;

		int chipn;


		iowr(16'hBFFD,dat);

		// see whoch chip has been written
		if( !portcfg[3] && mode_enable_saa && mode_enable_ymfm )
		begin // check SAA write
			if( saa_checker.adr!==saa_reg ||
			    saa_checker.dat!==dat     )
			begin
				$display("%m: SAA write reg failed!");
				$stop;
			end
		end
		else
		begin
			chipn=1;
			if( mode_enable_ymfm && !portcfg[0] ) chipn=0;

			if( ym_adr  [chipn]!==ym_reg[chipn] ||
			    ym_wrdat[chipn]!==dat           )
			begin
				$display("%m: YM %d write reg failed!",chipn);
				$stop;
			end
		end

	endtask




	task rd_dat;

		reg [7:0] dat;

		int chipn;
		int statr;

		ym_rddat[0] = $random()>>24;
		ym_rddat[1] = $random()>>24;
		ym_rdstat[0] = $random()>>24;
		ym_rdstat[1] = $random()>>24;

		iord(16'hFFFD,dat);


		if( !portcfg[3] && mode_enable_saa && mode_enable_ymfm )
		begin
			// nothing to do, can't read from SAA1099
		end
		else 
		begin
			chipn = 1;
			statr = 0;
		
			if( !mode_enable_ymfm )
			begin // single ay only
				chipn=1;
				statr=0;
			end
			else // mode_enable_ymfm==1
			begin
				chipn = portcfg[0];
				statr = !portcfg[1] && !portcfg[2];
			end

			if( ym_adr[chipn]!==ym_reg[chipn] || dat!==(statr ? ym_rdstat[chipn] : ym_rddat[chipn]) )
			begin
				$display("%m: YM %d read reg failed!",chipn);
				$stop;
			end


		end

	endtask











	// tasks for z80 bus model (simplified)
	task iord;

		input [15:0] addr;

		output [7:0] data;

		begin

			@(posedge zclk);

			mreq_n <= 1'b1;
			iorq_n <= 1'b1;
			rd_n   <= 1'b1;
			wr_n   <= 1'b1;

			zdena  <= 1'b0;

			zaddr <= addr;

			@(posedge zclk);

			iorq_n <= 1'b0;
			rd_n   <= 1'b0;

			@(posedge zclk);
			@(posedge zclk);
			@(negedge zclk);

			data = zdata;

			iorq_n <= 1'b1;
			rd_n   <= 1'b1;
		end

	endtask


	task iowr;

		input [15:0] addr;
		input [ 7:0] data;

		begin

			@(posedge zclk);

			mreq_n <= 1'b1;
			iorq_n <= 1'b1;
			rd_n   <= 1'b1;
			wr_n   <= 1'b1;

			zaddr <= addr;
			
			@(negedge zclk);
			zdena  <= 1'b1;
			zdout <= data;

			@(posedge zclk);

			iorq_n <= 1'b0;
			wr_n   <= 1'b0;

			@(posedge zclk);
			@(posedge zclk);
			@(negedge zclk);

			iorq_n <= 1'b1;
			wr_n   <= 1'b1;

			wait(wr_n==1'b1); // delta-cycle delay!!!
			zdena  <= 1'b0;
		end

	endtask
















	// tasks for saa testing
	task test_saa_write;
		reg [7:0] adr;
		reg [7:0] dat;
	begin

		adr = $random();
		dat = $random();

		wr_num(adr);
		wr_dat(dat);

		#(1);

		if( adr!==saa_checker.adr )
		begin
			$display("test_saa_write: address write failed!");
			$stop;
		end

		if( dat!==saa_checker.dat )
		begin
			$display("test_saa_write: data write failed!");
			$stop;
		end
	end
	endtask

	// tasks for ym testing
	task test_ym_write;
		input integer ymnum;
	begin : test_ym_write
		reg [7:0] adr, dat;
		adr = $random();
		dat = $random();

		wr_num(adr);
		wr_dat(dat);

		#(1.0);

		if( adr!==ym_adr[ymnum] )
		begin
			$display("test_ym_write: chip %d, address write failed!",ymnum);
			$stop;
		end

		if( dat!==ym_wrdat[ymnum] )
		begin
			$display("test_ym_write: chip %d, data write failed!",ymnum);
			$stop;
		end
	end
	endtask

	task test_ym_read;
		input integer ymnum;
		input integer addr;
	begin
	end
	endtask

endmodule




// bdir/bc1/bc2/a8/a9 decoder
module ay_access
(
	input  wire [15:0] a,
	input  wire        iorq_n,
	input  wire        wr_n,
	input  wire        rd_n,

	output wire        bdir,
	output wire        bc1,
	output wire        bc2,
	output wire        a8,
	output wire        a9_n
);
	reg bdir_r;
	reg bc1_r;

	// no testing bc2/a8/a9_n accesses, to the default values
	assign bc2  = 1'b1;
	assign a8   = 1'b1;
	assign a9_n = 1'b0;

	// TODO: add different bc2 AND a8/a9_n combinations!

	always @*
	begin
		if     ( !iorq_n && !wr_n && !a[1] &&  a[14] ) // wr FFFD
			{bdir_r,bc1_r} = 2'b11;
		else if( !iorq_n && !wr_n && !a[1] && !a[14] ) // wr BFFD
			{bdir_r,bc1_r} = 2'b10;
		else if( !iorq_n && !rd_n && !a[1] &&  a[14] ) // rd FFFD
			{bdir_r,bc1_r} = 2'b01;
		else // idle
			{bdir_r,bc1_r} = 2'b00;
	end

	assign bdir = bdir_r;
	assign bc1  = bc1_r;

endmodule



module saa_checker
(
	input  wire cs_n,
	input  wire wr_n,
	input  wire a0,
	input  wire [7:0] d
);
	reg [7:0] adr = 8'hFF;
	reg [7:0] dat;

	reg int_a0;

	always @(a0) int_a0 = #(0.1) a0;

	wire stb_n = cs_n | wr_n;

	always @(negedge stb_n)
	begin
		#0.2;
		if( int_a0==0 ) dat <= d;
		if( int_a0==1 ) adr <= d;
	end

endmodule

module ym_checker
(
	input  wire cs_n,
	input  wire rd_n,
	input  wire wr_n,
	input  wire a0,
	inout  wire [7:0] d,

	input  wire [7:0] rddat,
	input  wire [7:0] rdstat,
	output wire [7:0] adr,
	output reg  [7:0] wrdat
);

	reg [7:0] int_adr = 8'hFF;
	assign adr=int_adr;


	reg int_a0;

	wire wr_stb_n = cs_n | wr_n;

	initial int_a0 = a0;
	always @(a0) int_a0 = #(0.1) a0;

	always @(negedge wr_stb_n)
	begin
		#0.2;
		if( int_a0==1'b0 ) int_adr <= d;
		if( int_a0==1'b1 ) wrdat <= d;
	end

	assign d = (cs_n|rd_n) ? 8'hZZ : (int_a0 ? rddat : rdstat);

endmodule

