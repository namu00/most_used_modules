/*
	Writer: namu_00
	GitHub: https://github.com/namu00/most_used_modules

	*Notion*
	common-cathode: light up when HIGH, light off when LOW
	common-anode: light up when LOW, light off when HIGH 

	+-- A --+
	|		|
	F		B
	|		|
	+-- G --+
	|		|
	E	 	C
	|		|
	+-- D --+	.DP
*/

module hex_7_segment(
	input anode_type,
	input dot_enable,
	input [3:0] binary,
	output [7:0] segment
);

wire [7:0] seg;
assign seg = {dot_enable, digit};
assign segment = (anode_type) ? ~seg : seg;
//bit sequence: DP G F E D C B A

reg [6:0] digit;
always @(*)begin
	case(binary)
		//common-cethode encoding
		4'h0: digit = 7'h3F;
		4'h1: digit = 7'h06;
		4'h2: digit = 7'h5B;
		4'h3: digit = 7'h4F;
		4'h4: digit = 7'h66;
		4'h5: digit = 7'h6D;
		4'h6: digit = 7'h7D;
		4'h7: digit = 7'h07;
		4'h8: digit = 7'h7F;
		4'h9: digit = 7'h67;
		4'hA: digit = 7'h77;
		4'hB: digit = 7'h7C;
		4'hC: digit = 7'h39;
		4'hD: digit = 7'h5E;
		4'hE: digit = 7'h79;
		4'hF: digit = 7'h71;
		default: digit = 7'h7F;
	endcase
end
endmodule
