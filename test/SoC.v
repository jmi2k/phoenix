`include "SoC.v"
`timescale 1ns/100ps

module Test;

	localparam
		T     = 1e9 / `FCLK,
		Tbaud = 1e9 / 9_600;

	reg
		CLK = 0;

	wire
		TX;

	SoC soc(
		.CLK,
		.TX
	);

	initial begin
		$dumpfile(`DUMP);
		$dumpvars;

		#(50*Tbaud) $finish;
	end

	always
		#(T/2) CLK <= !CLK;

endmodule
