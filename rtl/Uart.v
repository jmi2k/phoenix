`include "Uart/Tx.v"

module Uart #(
	parameter
		Bauds = 9_600,
		W     = 8,
		Wstop = 1
) (
	input [W-1:0] IN,

	input
		CLK,
		OE,

	output
		RDY,
		TX
);

	Tx #(
		.Bauds(Bauds),
		.W(W),
		.Wstop(Wstop)
	) tx(
		.CLK,
		.IN,
		.OE,
		.RDY,
		.TX
	);

endmodule
