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
	output wire wr_port,
	
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

	wire [7:0] decode_wraddr;

	wire async_wrport,
	     async_wraddr,
	     async_wrdata,
	     async_rddata;

	reg  [2:0] wrport;
	reg  [2:0] wraddr;
	reg  [2:0] wrdata;
	reg  [2:0] rddata;

	reg wrport_on,
	    wraddr_on,
	    wrdata_on,
	    rddata_on;

	wire wraddr_beg,
	     wrdata_beg,
	     rddata_beg;

	wire wrport_beg;


	reg [7:0] write_latch;
	reg [7:0] read_latch;



	reg [3:0] saa_ctr = 4'hF; // for simulation

	reg [3:0] ym_ctr  = 4'hF; // for simulation




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
	assign async_wrport = decode_wraddr[{aybdir,aybc2,aybc1}] && aya8 && !aya9_n && ayd[7:4]==4'hF;
	assign async_wraddr = decode_wraddr[{aybdir,aybc2,aybc1}] && aya8 && !aya9_n && ayd[7:4]!=4'hF;
	assign async_wrdata =  aybdir &&  aybc2 && !aybc1         && aya8 && !aya9_n;
	assign async_rddata = !aybdir &&  aybc2 &&  aybc1         && aya8 && !aya9_n;



	// resync
	always @(posedge clk)
	begin
		wrport[2:0] <= { wrport[1:0], async_wrport };
		wraddr[2:0] <= { wraddr[1:0], async_wraddr };
		wrdata[2:0] <= { wrdata[1:0], async_wrdata };
		rddata[2:0] <= { rddata[1:0], async_rddata };
	end

	// filtering
	always @(posedge clk, negedge rst_n)
	if( !rst_n )
		wrport_on <= 1'b0;
	else if( !wrport_on && wrport[2:1]==2'b11 )
		wrport_on <= 1'b1;
	else if(  wrport_on && wrport[2:1]==2'b00 )
		wrport_on <= 1'b0;
	//
	always @(posedge clk, negedge rst_n)
	if( !rst_n )
		wraddr_on <= 1'b0;
	else if( !wraddr_on && wraddr[2:1]==2'b11 )
		wraddr_on <= 1'b1;
	else if(  wraddr_on && wraddr[2:1]==2'b00 )
		wraddr_on <= 1'b0;
	//
	always @(posedge clk, negedge rst_n)
	if( !rst_n )
		wrdata_on <= 1'b0;
	else if( !wrdata_on && wrdata[2:1]==2'b11 )
		wrdata_on <= 1'b1;
	else if(  wrdata_on && wrdata[2:1]==2'b00 )
		wrdata_on <= 1'b0;
	//
	always @(posedge clk, negedge rst_n)
	if( !rst_n )
		rddata_on <= 1'b0;
	else if( !rddata_on && rddata[2:1]==2'b11 )
		rddata_on <= 1'b1;
	else if(  rddata_on && rddata[2:1]==2'b00 )
		rddata_on <= 1'b0;

	// start strobes
	assign wrport_beg = !wrport_on && wrport[2:1]==2'b11;
	assign wraddr_beg = !wraddr_on && wraddr[2:1]==2'b11;
	assign wrdata_beg = !wrdata_on && wrdata[2:1]==2'b11;
	assign rddata_beg = !rddata_on && rddata[2:1]==2'b11;




	// saa control
	always @(posedge clk)
	if( saa_sel && (wraddr_beg || wrdata_beg) )
		saa_ctr <= 4'd0;
	else if( !saa_ctr[3] )
		saa_ctr <= saa_ctr + 4'd1;
	//
	always @(posedge clk)
	if( wraddr_beg || wrdata_beg )
		saaa0 <= wraddr_beg;
	//
	always @(posedge clk)
	if( saa_sel && (wraddr_beg || wrdata_beg) )
		saacs_n <= 1'b0;
	else if( saa_ctr[3] )
		saacs_n <= 1'b1;
	//
	always @(posedge clk)
	if( saa_ctr[3] )
		saawr_n <= 1'b1;
	else if( saa_ctr[1] )
		saawr_n <= 1'b0;





	// ym control
	always @(posedge clk)
	if( !saa_sel && (wraddr_beg || wrdata_beg || rddata_beg) )
		ym_ctr[3:0] <= 4'd0;
	else if( !(&ym_ctr[3:1]) /*ym_ctr[3:0]<4'd14*/ )
		ym_ctr[3:0] <= ym_ctr[3:0] + 4'd1;
	//
	always @(posedge clk)
	if( wraddr_beg || wrdata_beg || rddata_beg )
		yma0 <= wrdata_beg || (rddata_beg && !ym_stat);
	//
	always @(posedge clk)
	if( &ym_ctr[3:1] /*ym_ctr[3:0]==4'd14*/ )
	begin
		ymcs0_n <= 1'b1;
		ymcs1_n <= 1'b1;
		ymrd_n  <= 1'b1;
		ymwr_n  <= 1'b1;
	end
	else if( !ym_ctr[3:0] ) // 1 clock after counter start
	begin
		ymcs0_n <=  ym_sel;
		ymcs1_n <= !ym_sel;
		//
		ymrd_n  <= !rddata_on;
		ymwr_n  <= !(wraddr_on || wrdata_on);
	end


	// config port write strobe
	assign wr_port = wrport_beg;





	// write latch
	always @(posedge clk)
	if( wraddr_beg || wrdata_beg )
		write_latch <= ayd;
	
	// read latch
	always @*
	if( !ymrd_n )
		read_latch = d;



	// busses intercommutation
	assign ayd = async_rddata ? read_latch : 8'hZZ;
	//
	assign d = (!saawr_n || !ymwr_n) ? write_latch : 8'hZZ;






endmodule

