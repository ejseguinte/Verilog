module pgu_4bits (a, b, p, g);
input [3:0] a, b;
output [3:0] p, g;
assign p = a ^ b;
assign g = a & b;
endmodule
