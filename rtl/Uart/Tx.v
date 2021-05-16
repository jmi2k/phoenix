module Tx #(
	parameter
		Bauds = 'bx,
		W     = 'bx,
		Wstop = 'bx
) (
	input [W-1:0] IN,

	input
		CLK,
		OE,

	output
		RDY,

	output reg
		TX = 1
);

	localparam
		Wframe = 1 + W + Wstop,
		Nticks = `FCLK/Bauds,
		Wticks = $bits(Nticks),
		Windex = $bits(Wframe);

	reg [Wticks-1:0] ticks = Nticks;
	reg [Windex-1:0] index = Wframe;
	reg      [W-1:0] data  = 'bx;

	assign
		RDY = index == Wframe;

	/*
	 * Generate timing
	 */
	always @(posedge CLK)
		if (index < Wframe)
			ticks <= !ticks ? Nticks : ticks-1;

	/*
	 * Update bit position
	 */
	always @(posedge CLK)
		case (1)
			OE:     index <= 0;
			!ticks: index <= index+1;
		endcase

	/*
	 * Fetch data from IN, send frames to TX
	 */
	always @(posedge CLK)
		case (1)
			OE:             data <= IN;
			index == 0:     TX   <= 0;
			index < 1+W:    TX   <= data[index-1];
			index < Wframe: TX   <= 1;
			default:        TX   <= 1;
		endcase

endmodule
