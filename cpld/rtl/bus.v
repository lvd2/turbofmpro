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


endmodule

