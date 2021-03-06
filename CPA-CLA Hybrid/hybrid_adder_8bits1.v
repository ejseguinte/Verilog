`include "adder_4bits.v";
`include "inverter.v";
module hybrid_adder_8bits
(
  input [7:0] a , b,
  input m,
  output [7:0] s,
  output c7,cout,
  output overflow
);

wire c4, c3;
wire [7:0] i;
inverter invert(m, b [7:0],i);
adder_4bits adder1(a[3:0], i [3:0], m, s[3:0], c3, c4);
adder_4bits adder2(a[7:4], i [7:4], c4, s[7:4], c7, cout);
assign overflow = c7^cout;
endmodule

module Project1_test;
reg [7:0] a, b;
reg m;
wire [7:0] s;
wire c7,cout;
wire overflow;
hybrid_adder_8bits tester(a, b, m, s,c7,cout,overflow);

initial
begin
	$display("Time  a   b   m   c7 cout of sum");
  $monitor("%4d: %2h, %2h, %3b = %2b, %2b,   %2b, %2h", $time, a, b, m, c7, cout, overflow, s);
  a = 8'h00; b = 8'h00; m = 1'b0;
  //test 1
  #10
  a = 8'h02; b = 8'h03; m = 1'b0;
  //test 2
  #10
  a = 8'h00; b = 8'hFF; m = 1'b1;
  //test 3
  #10
  a = 8'h55; b = 8'hAA; m = 1'b0;
  //test 4
  #10
  a = 8'h55; b = 8'hAA; m = 1'b1;
  //test 5
  #10
  a = 8'hFF; b = 8'hFF; m = 1'b1;
end
endmodule

