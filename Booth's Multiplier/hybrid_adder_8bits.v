`include "adder_4bits.v";
`include "inverter.v";
module hybrid_adder_8bits
(
  input [7:0] a , b,
  input m,
  output [7:0] s
);

wire c4, c3;
wire [7:0] i;
inverter invert(m, b [7:0],i);
adder_4bits adder1(a[3:0], i [3:0], m, s[3:0], c3, c4);
adder_4bits adder2(a[7:4], i [7:4], c4, s[7:4], c7, cout);
assign overflow = c7^cout;
endmodule

