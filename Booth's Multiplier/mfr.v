`include "dff.v";
module mfr
(
    input s1, s0,shift_in,clock,_reset,
    input [7:0]d,
    output [7:0]x,
    output shift_out
);
reg [7:0] q;
reg y;
always @(posedge clock,negedge _reset) 
begin
if(s1 == 1'b0 && s0 == 1'b1)
   q <= d;
else if(s1 == 1'b1 && s0 == 1'b0)
  begin
    y <= q[0];
    q[7] <= shift_in;
    q[6] <= q[7];
    q[5] <= q[6];
    q[4] <= q[5];
    q[3] <= q[4];
    q[2] <= q[3];
    q[1] <= q[2];
    q[0] <= q[1];
  end
else if(s1 == 1'b1 && s0 == 1'b1)
  begin
    y <= q[0];
    q <= q>>>2;
  end
else if(!_reset)
  begin
    q <= 9'h0;
    y <= 1'b0;
  end
end
assign x =q;
assign shift_out = y;
endmodule



