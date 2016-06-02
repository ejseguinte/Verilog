`include "hybrid_adder_8bits.v";
`include "mfr.v";

module interface_unit
(
  input clock, _reset,start_asyn,done,
  output reg start,done_moore
);
always@(posedge clock or negedge _reset or posedge done)
begin
  if(_reset == 0 || done == 1)
    start <= 1'b0;
  else
    start <= start_asyn;
end

always@(posedge clock or negedge _reset or posedge start_asyn)
begin
  if(_reset == 0 || done == 1)
    done_moore = 1'b0;
  else
    done_moore <= done;
end
endmodule
module data_path
(
    input clock, _reset, start,
    input [7:0] a_value , b_value,
    output [15:0] result,
    output reg done
);
wire [7:0] s,a_v,b_v,p_v,d_v;
reg [7:0] x, y, z,c,d;
reg [2:0] cntr;
wire shift_out,shift_out_b;
reg out;
reg e,m,s1_b,s0_b,s1,s0,shift_in;
reg [1:0] current_state, next_state;

mfr a(1'b0,1'b1,shift_in,clock,_reset,x,a_v);
mfr b(s1_b,s0_b,shift_in,clock,_reset,y,b_v,shift_out_b);
mfr p(s1,s0,shift_in,clock,_reset,z,p_v,shift_out);

hybrid_adder_8bits adder(c, d, m, d_v);


assign result = {p_v, b_v};
always@(posedge clock, negedge _reset)
begin
    if(_reset == 0)
      cntr <= 3'b0000;
    else
      if(e)
        cntr <= cntr + 1;
end

//---------------The States
parameter   Idle  = 2'b00,
            Check = 2'b01,
            Add   = 2'b10;
//---------------Output Generator 
always@(posedge clock or negedge _reset)
begin
  if (!_reset)
  begin
    cntr <=0;
  end
  else
  case(current_state)
    Idle: if(start ==1)
    begin
      shift_in = 1'b0;
      out = 1'b0;
      x <= a_value;
      y <= b_value;
      z  = 8'b0;
      s1_b <= 0;
      s0_b <= 1;
      cntr <= 0;
      c<=8'h0;
      d<=8'h0;
      m<=1'b0;
      s1 <= 0;
      s0 <= 1;
    end
    Check:
    begin
    if(cntr<8)
      if(b_v[0] == 0 && out == 1'b1)
      begin
        c<=p_v;
        d<=a_v;
        m<=1'b1;
#10 $display("d_v = %8b", d_v);
        #10 assign z = d_v;
        #10 s1 <= 0;
        s0 <= 1;
        #10 s1 <= 0;
        s0 <= 0;     
      end
      else if(b_v[0] == 1 && out == 1'b0)
      begin
        c<=p_v;
        d<=a_v;
        m<=1'b1;
#10 $display("d_v = %8b", d_v);
        #10 assign z = d_v;
        #10 s1 <= 0;
        s0 <= 1;
        #10 s1 <= 0;
        s0 <= 0;
      end
    else
    begin
      #10 s0 <= 1;
      s1 <= 1;
$display("shift_outa = %1b",shift_out);
      assign shift_in=shift_out;
      #10 assign s1_b = 1; assign s0_b = 0;
      #10 s1_b <= 0;
      s0_b <= 0;
$display("shift_out_b = %1b",shift_out_b);
      assign out = shift_out_b;
$display("out = %1b",out);
$display("shift_out = %1b",shift_out);
$display("shift_in = %1b",shift_in);
      #10 e <=1;
    end
    end
    Add:
    begin
      #10 s0 <= 1;
      s1 <= 1;
      #10 s1 <= 0;
      #10 s0 <= 0;
$display("shift_out = %1b",shift_out);
      assign shift_in=shift_out;
$display("ishift_out = %1b",shift_out);
$display("shift_in = %1b",shift_in);
      #10 assign s1_b = 1; assign s0_b = 0;
      #10 s1_b <= 0;
      s0_b <= 0;
      #10 assign out = shift_out_b;
      e <=1;
    end
  endcase
end
//---------------Next State Generator
always@(current_state or cntr or start or b_v[0])
begin
  case(current_state)
   Idle:
    begin
      
      if(start ==1)
      begin
        done = 0;
        next_state = Check;
      end
      else 
         next_state = Idle;
    end
   Check: if(cntr<8)
    begin
      done = 0;
      if(b_v[0] == b_v[1])
        next_state = Check;
      else
        next_state = Add;
    end 
    else
    begin
      done = 1;
      next_state = Idle;
    end
   Add:
    begin
      done = 0;
      next_state = Check;
    end
   default:
    begin
      done = 0;
      next_state = Idle;
    end
   endcase
end
//---------------The Flip-Flop
always@(posedge clock or negedge _reset)
begin
  if(!_reset)
    current_state <= Idle;
  else
    current_state <= next_state;
  end   
endmodule

module tester();
reg clock, _reset,start_asyn;
reg [7:0] a_value, b_value;
wire [15:0] result;
wire done,done_moore,start;

interface_unit u1(clock,_reset,start_asyn,done,start,done_moore);
data_path u2(clock,_reset,start,a_value,b_value,result,done);

initial begin
clock =1;
#5 forever #5 clock = ~clock;
end

initial begin
$display("Time     a  b  Result");
$monitor("%5d:  %2h %2h %16b", $time, a_value,b_value,result);
_reset = 0;
start_asyn =0;
#15 _reset =1;
#100 start_asyn =1; a_value = 8'h1; b_value = 8'hF8;


#1000 $finish;
end

endmodule
