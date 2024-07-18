module sumtwo(
    input clk, rst,
    input signed [9:-22] a1b1,
    input signed [9:-22] a2b2,
    input signed [9:-22] a1b2,
    input signed [9:-22] a2b1,

    output signed [10:-21] ab_real,
    output signed [10:-21] ab_imag
);

reg signed [10:-22] aux_ab_real;
reg signed [10:-22] aux_ab_imag;

always@(posedge clk, negedge rst)
begin
    if(!rst)
        begin
            aux_ab_real <= 0;
            aux_ab_imag <= 0;
        end
    else
        begin
            aux_ab_real <= a1b1 - a2b2;
            aux_ab_imag <= a1b2 + a2b1;
        end
end

assign ab_real = aux_ab_real[10:-21];
assign ab_imag = aux_ab_imag[10:-21];

endmodule