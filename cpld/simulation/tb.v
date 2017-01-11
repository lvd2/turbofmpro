// testbench for TurboFMpro.v
// (c) NedoPC 2017

`timescale 1ns/1ps


`define CLK14_HALFPERIOD (35.000) /* to make it more async */
`define CLK28_HALFPERIOD (17.857)

module tb;

	integer seed;

	reg zclk, fclk;

	reg rst_n;

	wire aybc1,
	     aybc2,
	     aybdir,
	     aya8,
	     aya9_n;

	reg mode_enable_saa  = 1'b1,
	    mode_enable_ymfm = 1'b1;

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

		forever #(`CLK28_HALFPERIOD) fclk = ~fclk;
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









	// DUT connection
	TurboFMpro DUT
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

		wr_num(8'hF7);
	end
























	// tasks for bffd/fffd port control
	task wr_num;
		input [7:0] num;
		iowr(16'hFFFD,num);
	endtask

	task wr_dat;
		input [7:0] dat;
		iowr(16'hBFFD,dat);
	endtask

	task rd_dat;
		output [7:0] dat;
		iord(16'hFFFD,dat);
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

