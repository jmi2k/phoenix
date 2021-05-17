module Delay #(
	parameter
		Delay = 1,
		W     = 1
) (
	input
		CLK,

	input  [W-1:0] IN,
	output [W-1:0] OUT
);

	/*
	 * Shift IN through the delay line (the tail is assigned to OUT)
	 */
	genvar bit;
	generate
		for (bit = 0; bit < W; bit = bit+1) begin
			reg [Delay-1:0] delay;

			assign
				OUT[bit] = delay[Delay-1];

			always @(posedge CLK)
				delay <= delay<<1 | IN[bit];
		end
	endgenerate

endmodule