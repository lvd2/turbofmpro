// TurboFMpro project
// (C) 2018 NedoPC

// bus control: 
// data buffering, async signals filtering, access cycles forming

// ym2203 info:
//  address setup: 10ns (min 1Tc)
//  cs/rd/wr pulse width: 250ns (min 14Tc)
//  read time: 250ns -- read will only work at Z80@7MHz or slower!
//
// saa1099 info:
//  address setup: 0ns
//  wr pulse width: 100ns (min 6Tc)
//  cs to wr min: 50ns (min 3Tc)
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
	assign async_wrdata = aybdir && aybc2 && !aybc1 && aya8 && !aya9_n;
	assign async_rddata = !aybdir && aybc2 && aybc1 && aya8 && !aya9_n;



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





endmodule

