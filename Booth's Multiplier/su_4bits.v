module su_4bits(p, c, s);
input [3:0] p, c;
output[3:0] s;
assign s = p ^ c;
endmodule
