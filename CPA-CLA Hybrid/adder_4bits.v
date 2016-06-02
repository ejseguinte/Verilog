`include "pgu_4bits.v";
`include "cgu_4bits.v";
`include "su_4bits.v";

module adder_4bits
(
  input [3:0] a, b,
  input c0,
  output [3:0] s,
  output c3,
  output c4
);

wire [3:0] c, p, g;
pgu_4bits pgu1(a, b, p, g);
cgu_4bits cgu1(p, g, c0, c, c3,c4);
su_4bits su1(p, c, s);
endmodule
