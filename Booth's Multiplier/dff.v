module dff 
(
    input clock, _reset, e, 
    input [7:0]d,
    output reg[7:0]x
);

always@(posedge clock, negedge _reset)
begin
    if(!_reset)
        x<=0;
    else if(e)
        x<=d;
end 
endmodule
