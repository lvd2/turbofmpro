// TurboFMpro project
// (C) 2018 NedoPC

// clock generation for YM2203 and SAA1099 

module clocks
(
	input  wire fclk, // 56 MHz master clock

	input  wire saa_enabled, // whether SAA clock is enabled

	output wire ymclk, // 3.5 MHz
	output wire saaclk // 8 MHz
);

	reg [3:0] ym_cnt;
	reg [2:0] saa_cnt;

	reg main_clk;

	reg add_clk;
	reg add_clk_neg;

	// make ym clock (div by 16)
	initial ym_cnt = 4'd0; // for simulation
	//
	always @(posedge fclk)
		ym_cnt <= ym_cnt + 4'd1;
	//
	assign ymclk = ym_cnt[3];


	// make saa clock (div by 7)
	//
	// saacnt:    1     2     3     4     5     6     0     1     2     3     4     5 
	//         |     |     |     |     |     |     |     |     |     |     |     |     | 
	// fclk:  _/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\
	//         |     |     |     |     |     |     |     |     |     |     |     |     | 
	// saaclk:_/````````````````````\____________________/````````````````````\____________
	//
	//
	//
	initial saa_cnt <= 3'd0;
	//
	always @(posedge fclk, negedge saa_enabled)
	if( !saa_enabled )
		saa_cnt <= 3'd0;
	else if( saa_cnt[2:1]==2'b11 )
		saa_cnt <= 3'd0;
	else
		saa_cnt <= saa_cnt + 3'd1;



	always @(posedge fclk)
		main_clk <= ~saa_cnt[2];
 
	always @(posedge fclk)
		add_clk <= !(saa_cnt==3'd3 || saa_cnt==3'd4);
	always @*
	if( !fclk )
		add_clk_neg <= add_clk;


	assign saaclk = main_clk & add_clk_neg;

endmodule

