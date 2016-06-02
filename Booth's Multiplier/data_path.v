`include "hybrid_adder_8bits.v";

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
reg [7:0] a, b, p,c,d;
reg [3:0] cntr;
reg out;
reg e,m,s1_b,s0_b,s1,s0,shift_in;
reg [1:0] current_state, next_state,shift_out,shift_out_b;


hybrid_adder_8bits adder(c, d, m, d_v);


assign result = {p, b};
always@(posedge clock, negedge _reset, e)
begin
    if(_reset == 0)
      cntr <= 3'b0000;
    else
      if(e)
        cntr = cntr + 1;
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
    $display("resetting");
    cntr <=0;
    c<=8'h0;
    d<=8'h0;
    m<=1'b0;
  end
  else
  case(current_state)
    Idle: if(start ==1)
    begin
      shift_in = 1'b0;
      out = 1'b0;
      a <= a_value;
      b <= b_value;
      p  = 8'b0;
      cntr = 0;
      c<=8'h0;
      d<=8'h0;
      m<=1'b0;          
    end
    else
    begin
    
    end 
    Check:
    begin
    if(cntr<7)
    begin
      if(b[0] == 1'b0 && out == 1'b1)
      begin
        c<=p;
        d<=a;
        m<=1'b0;
        #30 p = d_v;      
      end
      else if(b[0] == 1'b1 && out == 1'b0)
      begin
        c<=p;
        d<=a;
        m<=1'b1;
        #30 p = d_v;
      end
      else
      begin
        out <= b[0];
        b <= {p[0],b[7:1]};
        p <= {p[7],p[7:1]};
        e <= 1;
        #5 e <= 0;
      end
    end
    else
    begin
      out <= b[0];
      b <= {p[0],b[7:1]};
      p <= {p[7],p[7:1]};
        e <= 1;
        #5 e <= 0;
    end
    end
    Add:
    begin
      out <= b[0];
      b <= {p[0],b[7:1]};
      p <= {p[7],p[7:1]};
        e <= 1;
        #5 e <= 0;
    end
  endcase
end
//---------------Next State Generator
always@(current_state or cntr or start or b[0])
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
      begin
         next_state = Idle;
      end
    end
   Check: if(cntr<7)
    begin
      done = 0;
      if(b[0] == out)
        next_state = Check;
      else
        next_state = Add;
    end 
    else
    begin
      done = 1;
      wait(done == 1) #20;
      done = 0;
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
#20 _reset =1;
#100 start_asyn =1; a_value = 8'hf8; b_value = 8'hfb;

wait(done ==1)
wait(done ==0)#20
_reset = 0;
 start_asyn =0;
#20 _reset =1;
#100 start_asyn =1; a_value = 8'hfb; b_value = 8'hf8;
wait(done ==1)
wait(done ==0)#20
_reset = 0;
 start_asyn =0;
#20 _reset =1;
#100 start_asyn =1; a_value = 8'h05; b_value = 8'hfe;
wait(done ==1)
wait(done ==0)#20
_reset = 0;
 start_asyn =0;
#20 _reset =1;
#100 start_asyn =1; a_value = 8'hff; b_value = 8'hff;
wait(done ==1)
wait(done ==0)#20
_reset = 0;
 start_asyn =0;
#20 _reset =1;
#100 start_asyn =1; a_value = 8'h01; b_value = 8'h01;
wait(done ==1)
wait(done ==0)#20
_reset = 0;
 start_asyn =0;
#20 _reset =1;
#100 start_asyn =1; a_value = 8'h05; b_value = 8'hf5;
wait(done ==1)
wait(done ==0)#20
_reset = 0;
 start_asyn =0;
#20 _reset =1;

$finish;
end

endmodule
