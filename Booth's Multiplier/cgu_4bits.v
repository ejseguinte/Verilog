module cgu_4bits (ps, gs, c0, c, c3, c4);
input [3:0] ps, gs;
input c0;
output[3:0] c;
output c3, c4;

assign c[0] = c0;
assign c[1] = gs[0] | ps[0] & c0;
assign c[2] = gs[1] | ps[1] & gs[0] | ps[1] & ps[0] & c0;
assign c[3] = gs[2] | ps[2] & gs[1] | ps[2] & ps[1] & gs[0] | ps[2] & ps[1] & ps[0] & c0;
assign c3 = c[3];
assign c4 = gs[3] | ps[3] & gs[2] | ps[3] & ps[2] & gs[1] | ps[3] & ps[2] & ps[1] & gs[0] | ps[3] & ps[2] & ps[1] & ps[0] & c0;
endmodule
