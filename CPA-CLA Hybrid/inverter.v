module inverter
(
    input m,
    input [7:0]a,
    output [7:0]x
);

    assign x[7] = m ^ a[7];
    assign x[6] = m ^ a[6];
    assign x[5] = m ^ a[5];
    assign x[4] = m ^ a[4];
    assign x[3] = m ^ a[3];
    assign x[2] = m ^ a[2];
    assign x[1] = m ^ a[1];
    assign x[0] = m ^ a[0];
endmodule