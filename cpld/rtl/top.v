// TurboFMpro project
// (C) 2018 NedoPC

// top level: 
//  pins, connections

module top
(
	//global clock 56Mhz
	input fclk,
	
	// speccy databus from AY slot
	inout  wire  [7:0] ayd,
	
	// local databus to YM/SAA
	inout  wire  [7:0] d,
	
	// controls (from speccy AY slot)
	input  wire        ayres_n,
	input  wire        aybc1,
	input  wire        aybc2,
	input  wire        aybdir,
	input  wire        aya8,
	input  wire        aya9_n,

	// modes (from jumpers)
	input  wire        mode_enable_saa,   //0 - saa disabled (board equals to TurboFM)
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
	
	wire wr_port; // write Fx config port strobe


	// reset resync
	reg [1:0] rst_n_r;
	wire rst_n = rst_n_r[1];
	//
	always @(posedge fclk, negedge ayres_n)
	if( !ayres_n )
		rst_n_r[1:0] <= 2'b00;
	else
		rst_n_r[1:0] <= {rst_n_r[0], 1'b1};




	// clocks generator
	clocks clocks
	(
		.fclk(fclk),

		.saa_enabled(saa_enabled),

		.ymclk (ymclk ),
		.saaclk(saaclk)
	);




	// bus controller
	bus bus
	(
		.clk(fclk),

		.rst_n(rst_n),

		.aybc1 (aybc1 ),
		.aybc2 (aybc2 ),
		.aybdir(aybdir),
		.aya8  (aya8  ),
		.aya9_n(aya9_n),

		.ayd(ayd),
		.d  (d  ),

		.wr_port(wr_port),
		
		.yma0   (yma0   ),
		.ymcs0_n(ymcs1_n),
		.ymcs1_n(ymcs2_n),
		.ymrd_n (ymrd_n ),
		.ymwr_n (ymwr_n ),

		.saaa0  (saaa0  ),
		.saacs_n(saacs_n),
		.saawr_n(saawr_n)
	);





endmodule

