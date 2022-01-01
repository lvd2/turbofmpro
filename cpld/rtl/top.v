// TurboFMpro project
// (C) 2018-2022 NedoPC

// top level: 
//  pins, connections

module top
(
	//global clock 56Mhz
	input fclk,
	
	// speccy databus from AY slot
	inout  wire [7:0] ayd,
	
	// local databus to YM/SAA
	inout  wire [7:0] d,
	
	// controls (from speccy AY slot)
	input  wire       ayres_n,
	input  wire       aybc1,
	input  wire       aybc2,
	input  wire       aybdir,
	input  wire       aya8,
	input  wire       aya9_n,

	// modes (from jumpers)
	input  wire       mode_enable_saa,   //0 - saa disabled (board equals to TurboFM)
	input  wire       mode_enable_ymfm,  //0 - single AY mode (no two AY, no FM, no SAA)
	
	// control YM2203
	output wire       ymclk,   //3.5Mhz
	output wire       ymcs1_n, //select first chip
	output wire       ymcs2_n, //select second chip
	output wire       ymrd_n,  //write
	output wire       ymwr_n,  //read
	output wire       yma0,
	input  wire       ymop1, //dac data from first chip
	input  wire       ymop2, //dac data from second chip
	output wire       ymop1d, //to first dac
	output wire       ymop2d, //to second dac

	// control SAA
	output wire       saaclk, //8Mhz
	output wire       saacs_n, //chip select
	output wire       saawr_n, //chip write
	output wire       saaa0, //register/adress select

	// PLL control
	output wire [1:0] pll
);
	
	wire wr_port; // write Fx config port strobe

	// config signals
	wire ym_sel;  // 0 -- YM #0 selected, 1 -- YM #1
	wire ym_stat; // 1 -- read YM status reg
	wire saa_sel; // 1 -- saa selected, 0 -- YM selected

	wire fm_dac_ena;
	
	reg saa_clk_ena;



	// set up PLL rate to x4
	assign pll[1:0] = 2'b00;




	// saa clock control (stop clock on reset)
	always @(posedge fclk, negedge ayres_n)
	if( !ayres_n )
		saa_clk_ena <= 1'b0;
	else if( saa_sel )
		saa_clk_ena <= 1'b1;



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

		.saa_enabled(saa_clk_ena),

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
		.saawr_n(saawr_n),
	
		.ym_sel (ym_sel ),
		.ym_stat(ym_stat),
		.saa_sel(saa_sel)
	);




	// configurator
	cfg cfg
	(
		.clk  (fclk ),
		.rst_n(rst_n),

		.d(ayd),

		.wrstb(wr_port),

		.mode_enable_saa (mode_enable_saa ),
		.mode_enable_ymfm(mode_enable_ymfm),

		.ym_sel (ym_sel ),
		.ym_stat(ym_stat),
		.saa_sel(saa_sel),

		.fm_dac_ena(fm_dac_ena)
	);




	// FM dac enable
	assign ymop1d = ymop1 & fm_dac_ena;
	assign ymop2d = ymop2 & fm_dac_ena;






endmodule

