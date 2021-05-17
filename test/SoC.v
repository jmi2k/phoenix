`include "SoC.v"
`timescale 1ns/100ps

module Test;

	localparam
		T      = 1e9 / `FCLK,
		Tframe = 1e9 / 60;

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

		#(Tframe+10) $finish;
	end

	always
		#(T/2) CLK <= !CLK;

endmodule
