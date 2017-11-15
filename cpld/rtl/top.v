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

	wire saa_enabled = mode_enable_saa & mode_enable_ymfm;





	// clocks generator
	clocks clocks
	(
		.fclk(fclk),

		.saa_enabled(saa_enabled),

		.ymclk (ymclk ),
		.saaclk(saaclk)
	);




endmodule

