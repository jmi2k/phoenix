module VideoTerm #(
	parameter
		W       = 80,
		H       = 30,
		Bitmap  = 'bx,
		Charmap = 'bx,
		Nchrs   = 128,
		Wchr    = 8,
		Hchr    = 16,

		Woutx   = $clog2(W*Wchr),
		Wouty   = $clog2(H*Hchr)
) (
	input [Woutx-1:0] X,
	input [Wouty-1:0] Y,

	input
		CLK,

	output reg
		DOT = 'bx
);

	localparam
		Wcell = $clog2(Nchrs);

	reg [Wcell-1:0] grid [0:H-1][0:W-1];
	reg [Wcell-1:0] char;

	reg bitmap [0:Hchr-1][0:Nchrs-1][0:Wchr-1];

	wire [Woutx-1:0] x;
	wire [Wouty-1:0] y;

	Delay #(
		.W(Woutx+Wouty)
	) delay(
		CLK,
		{X, Y},
		{x, y}
	);

	initial begin
		if (Bitmap !== 'bx)  $readmemh(Bitmap, bitmap);
		if (Charmap !== 'bx) $readmemh(Charmap, grid);
	end

	/*
	 * Retrieve char from the grid which contains the point (X, Y)
	 */
	always @(posedge CLK)
		char <= grid[Y/Hchr][X/Wchr];

	/*
	 * Retrieve DOT from the bitmap for the current char
	 */
	always @(posedge CLK)
		DOT <= bitmap[y%Hchr][char][x%Wchr];

endmodule
