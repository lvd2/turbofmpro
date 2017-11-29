// TurboFMpro project
// (C) 2018 NedoPC

// bus control: 
// data buffering, async signals filtering, access cycles forming

// ym2203 info:
//  address setup: 10ns (min 1Tc)
//  cs/rd/wr pulse width: 250ns (min 14Tc)
// total: 15Tc
//  read time: 250ns -- read will only work at Z80@7MHz or slower!
// ymA0=0 -- wr addr/read status
// ymA0=1 -- wr data/read data
//
// saa1099 info:
//  address setup: 0ns
//  wr pulse width: 100ns (min 6Tc)
//  cs to wr min: 50ns (min 3Tc)
// total: 9Tc
// saaA0=0 -- data, saaA0=1 -- address
//
// Z80 @ 14MHz:
//  access width: 178ns
//  min repetition time: 785ns
//
// 56MHz period: 17.8ns
//
//
// time plan:
// fclk:          __/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\__/``\
// async access:  ___/````````
// resync1:       _________/```````
// resync2:       _______________/``````
// filt:          _____________________/`````````````
// output cs/wr:  ___________________________/````````````
//
// deltaT:           |<--------------------->| = 4Tc = 71ns -> less than Z80@14MHz /IORQ length
//






module bus
(
	input  wire clk,
	input  wire rst_n,

	input  wire        aybc1,
	input  wire        aybc2,
	input  wire        aybdir,
	input  wire        aya8,
	input  wire        aya9_n,

	// data busses
	inout  wire [7:0]  ayd, // INPUT DATA BUS!!! (from host)
	inout  wire [7:0]  d,   // internal data bus (to ym2203/sa1099)

	// write strobe for Fx config port
	output reg  wr_port,
	
	// strobes/addr for ym2203
	output reg  yma0,
	output reg  ymcs0_n,
	output reg  ymcs1_n,
	output reg  ymrd_n,
	output reg  ymwr_n,

	// strobes/addr for saa1099
	output reg  saaa0,
	output reg  saacs_n,
	output reg  saawr_n,



	// config inputs
	input  wire ym_sel,  // 0 -- YM #0 selected, 1 -- YM #1
	input  wire ym_stat, // 1 -- read YM status reg
	input  wire saa_sel  // 1 -- saa selected, 0 -- YM selected
);

	wire [2:0] decode_wraddr;

	wire async_wraddr,
	     async_wrdata,
	     async_rddata;

	wire [2:0] wraddr;
	wire [2:0] wrdata;
	wire [2:0] rddata;

	reg wraddr_on,
	    wrdata_on,
	    rddata_on;

	wire wraddr_beg, wraddr_end,
	     wrdata_beg, wrdata_end,
	     rddata_beg, rddata_end;

	reg [7:0] write_latch;
	reg [7:0] read_latch;



	wire cfg_port;




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
	//
	assign decode_wraddr[3'b000] = 1'b0;
	assign decode_wraddr[3'b001] = 1'b1;
	assign decode_wraddr[3'b010] = 1'b0;
	assign decode_wraddr[3'b011] = 1'b0;
	assign decode_wraddr[3'b100] = 1'b1;
	assign decode_wraddr[3'b101] = 1'b0;
	assign decode_wraddr[3'b110] = 1'b0;
	assign decode_wraddr[3'b111] = 1'b1;
	//
	assign async_wraddr = decode_wraddr[{aybdir,aybc2,aybc1}] && aya8 && !aya9_n;
	assign async_wrdata =  aybdir &&  aybc2 && !aybc1          && aya8 && !aya9_n;
	assign async_rddata = !aybdir &&  aybc2 &&  aybc1          && aya8 && !aya9_n;



	// resync
	always @(posedge clk)
	begin
		wraddr[2:0] <= { wraddr[1:0], async_wraddr };
		wrdata[2:0] <= { wrdata[1:0], async_wrdata };
		rddata[2:0] <= { rddata[1:0], async_rddata };
	end

	// filtering
	always @(posedge clk, negedgre rst_n)
	if( !rst_n )
		wraddr_on <= 1'b0;
	else if( !wraddr_on && wraddr[2:1]==2'b11 )
		wraddr_on <= 1'b1;
	else if(  wraddr_on && wraddr[2:1]==2'b00 )
		wraddr_on <= 1'b0;
	//
	always @(posedge clk, negedgre rst_n)
	if( !rst_n )
		wrdata_on <= 1'b0;
	else if( !wrdata_on && wrdata[2:1]==2'b11 )
		wrdata_on <= 1'b1;
	else if(  wrdata_on && wrdata[2:1]==2'b00 )
		wrdata_on <= 1'b0;
	//
	always @(posedge clk, negedgre rst_n)
	if( !rst_n )
		rddata_on <= 1'b0;
	else if( !rddata_on && rddata[2:1]==2'b11 )
		rddata_on <= 1'b1;
	else if(  rddata_on && rddata[2:1]==2'b00 )
		rddata_on <= 1'b0;

	// start/stop strobes
	assign wraddr_beg = !wraddr_on && wraddr[2:1]==2'b11;
	assign wraddr_end =  wraddr_on && wraddr[2:1]==2'b00;
	assign wrdata_beg = !wrdata_on && wrdata[2:1]==2'b11;
	assign wrdata_end =  wrdata_on && wrdata[2:1]==2'b00;
	assign rddata_beg = !rddata_on && rddata[2:1]==2'b11;
	assign rddata_end =  rddata_on && rddata[2:1]==2'b00;



	// config port access (address Fx)
	assign cfg_port = ayd[7:4]==4'hF;




	always @(posedge clk)
	if( cfg_port && wraddr_beg )
		wr_port <= 1'b1;
	else
		wr_port <= 1'b0;





	// write latch
	always @(posedge fclk)
	if( wraddr_beg || wrdata_beg )
		write_latch <= ayd;
	
	// read latch
	always @*
	if( ??? )
		read_latch = d;









endmodule

