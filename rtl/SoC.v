`include "Delay.v"
`include "FemtoRv32.v"
`include "Uart.v"
`include "Vga.v"
`include "VideoTerm.v"

module SoC(
	input
		CLK,

	output [3:0]
		R,
		G,
		B,

	output
		HS_,
		VS_,
		TX
);

	reg [7:0] text [0:1_023];
	reg [9:0] addr = 0;
	reg [7:0] char = "\0";

	reg [3:0] pixel = 'bx;

	reg bitmap [0:479][0:639];
	reg bitmap_dot = 'bx;

	wire [9:0] x;
	wire [8:0] y;
	wire [3:0] ven4;

	wire
		hb, vb,
		hb0, vb0,
		hs0_, vs0_,
		ready,
		term_dot,
		ven;

	assign
		ven  = !hb & !vb,
		ven4 = {4{ven}},
		R    = ven4 & pixel,
		G    = ven4 & pixel,
		B    = ven4 & pixel;

	Uart uart(
		.CLK,
		.IN(char),
		.OE(ready),
		.RDY(ready),
		.TX
	);

	Vga vga(
		.CLK,
		.HB(hb0),
		.VB(vb0),
		.HS_(hs0_),
		.VS_(vs0_),
		.X(x),
		.Y(y)
	);

	VideoTerm #(
		.Bitmap("vga.0000-007F.hex"),
		.Charmap("term.hex")
	) term(
		.CLK,
		.DOT(term_dot),
		.X(x),
		.Y(y)
	);

	Delay #(
		.Delay(2),
		.W(4)
	) delay(
		CLK,
		{hb0, vb0, hs0_, vs0_},
		{hb,  vb,  HS_,  VS_}
	);

	FemtoRv32 cpu (
		.CLK,
		.RST(0),
		.IRQ(0)
	);

	initial begin
		$readmemh("hello.hex", text);
		$readmemh("EVA.hex", bitmap);
	end

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

	/*
	 * Retrieve dot from bitmap
	 */
	always @(posedge CLK)
		bitmap_dot <= bitmap[y][x];

	/*
	 * Mix the bitmap dot and the term dot
	 */
	always @(posedge CLK)
		pixel <= {4{term_dot}} | {2{bitmap_dot}};

endmodule
