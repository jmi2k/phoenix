`include "Uart.v"
`include "Vga.v"

module SoC(
	input
		CLK,

	output
		TX
);

	reg [7:0] text [0:1_023];
	reg [9:0] addr = 0;
	reg [7:0] char = "\0";

	wire
		ready;

	Uart uart(
		.CLK,
		.IN(char),
		.OE(ready),
		.RDY(ready),
		.TX
	);

	Vga vga(
		.CLK
	);

	initial
		$readmemh("hello.hex", text);

	/*
	 * Step addr after sending a char until reaching \0
	 */
	always @(posedge CLK)
		if (|char)
			addr <= addr + ready;

	/*
	 * Retrieve char from memory
	 */
	always @(posedge CLK)
		char <= text[addr];

endmodule
