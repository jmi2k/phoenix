module Vga #(
	parameter
		W     = 640,
		H     = 480,
		Hfp   = 16,
		Hsync = 96,
		Hbp   = 48,
		Vfp   = 10,
		Vsync = 2,
		Vbp   = 33,

		Wfull = W + Hbp + Hsync + Hfp,
		Hfull = H + Vbp + Vsync + Vfp,
		Woutx = $clog2(Wfull),
		Wouty = $clog2(Hfull)
) (
	input
		CLK,

	output
		HB, VB,
		HS_, VS_,

	output reg [Woutx-1:0] X = 0,
	output reg [Wouty-1:0] Y = 0
);

	wire
		x_maxed = X == Wfull-1,
		y_maxed = Y == Hfull-1;

	assign
		HB  = X >= W,
		VB  = Y >= H,
		HS_ = !(X >= W+Hfp && X < Wfull-Hbp),
		VS_ = !(Y >= H+Vfp && Y < Hfull-Vbp);

	/*
	 * Step through the full screen grid, setting X and Y accordingly
	 */
	always @(posedge CLK)
		if (x_maxed) begin
			X <= 0;
			Y <= y_maxed ? 0 : Y+1;
		end else
			X <= X+1;

endmodule
