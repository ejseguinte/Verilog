module nrzi
(
  input clock,reset, x,
  output reg z
);
reg current_state, next_state;

always@(x or current_state)
begin

assign next_state = ~current_state* ~x + current_state* x;

end

always@(x or current_state)
begin

assign z = current_state^x;
end

always@(posedge clock, posedge reset)
begin

if (reset == 1)
  current_state <= 0;
else
  current_state <= next_state;

end
endmodule 
module testbench;

reg clock,reset,x;
wire z;

nrzi tester(clock,reset,x,z);

initial 
begin
$monitor("%4d:          z = %b", $time, z);
clock = 0;
reset = 1;
x = 0;
#10 reset = 0;
$display("0000000000000000 = 16'h0000");
end

always
begin
#5clock = ~clock;
end

initial 
begin
//$display("0000000000000000 = 16'h0000");
#15 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);

clock = 0;
reset = 1;
x = 0;
#10 reset = 0;
$display("1111000101100011 = 16'hF163");
#15 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);

clock = 0;
reset = 1;
x = 0;
#10 reset = 0;
$display("1100111100001100 = 16'hCF0C");
#15 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);

clock = 0;
reset = 1;
x = 1;
#10 reset = 0;
$display("1000110000000000 = 16'h8C00");
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 0; $display("%4d:  x = %b", $time,x);
#10 x = 1; $display("%4d:  x = %b", $time,x);
#10 $finish;
end
endmodule
