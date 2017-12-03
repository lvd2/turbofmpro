// TurboFMpro project
// (C) 2018 NedoPC

// configuration control:
//  "port" Fx writes, jumpers -- inputs
// config signals -- outputs

module cfg
(
	input  wire clk,
	input  wire rst_n,

	input  wire [7:0] d, // data bus to latch config "port" writes from
	input  wire       wrstb, // write strobe

	input  wire        mode_enable_saa,   //0 - saa disabled (board equals to TurboFM)
	input  wire        mode_enable_ymfm,  //0 - single AY mode (no two AY, no FM, no SAA)


	// for bus
	output wire ym_sel,
	output wire ym_stat,
	output wire saa_sel,

	// for DAC gate
	output wire fm_dac_ena
);

	reg [3:0] cfg_port;


	// conf[0] - YM curchip select ( 0 - select D0, 1 - select D1, !!!1 after reset!!! )
	// conf[1] - YM stat reg select ( 1 - read register, 0 - read status )
	// conf[2] - YM fm part disable ( 0 - enable, 1 - disable )
	// conf[3] - SAA enable ( 0 - enable, 1 - disable )
	always @(posedge clk, negedge rst_n)
	if( !rst_n )
		cfg_port <= 4'b1111;
	else if( wrstb )
		cfg_port <= d[3:0];


	// make outputs
	assign ym_sel = cfg_port[0] || !mode_enable_ymfm; // select #1 when 2ay/fm disabled
	
	assign ym_stat = !cfg_port[1] && mode_enable_ymfm && !cfg_port[2]; // no status reads are possible when fm disabled

	assign saa_sel = !cfg_port[3] && mode_enable_saa && mode_enable_ymfm;


	assign fm_dac_ena = mode_enable_ymfm && !cfg_port[2];

endmodule

