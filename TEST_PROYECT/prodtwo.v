module prodtwo(
    input clk, rst,

    input signed [4:-27] a1,
    input signed [4:-27] a2,
    input signed [4:-27] b1,
    input signed [4:-27] b2,

    output signed [9:-22] a1b1,
    output signed [9:-22] a2b2,
    output signed [9:-22] a1b2,
    output signed [9:-22] a2b1
);

reg signed [9:-54] aux_a1b1;
reg signed [9:-54] aux_a2b2;
reg signed [9:-54] aux_a1b2;
reg signed [9:-54] aux_a2b1;

always@(posedge clk, negedge rst)
begin
    if(!rst) 
        begin
            aux_a1b1 <= 0;
            aux_a2b2 <= 0;
            aux_a1b2 <= 0;
            aux_a2b1 <= 0;
        end
    else
        begin
            aux_a1b1 <= a1*b1;
            aux_a2b2 <= a2*b2;
            aux_a1b2 <= a1*b2;
            aux_a2b1 <= a2*b1;
        end
end

assign a1b1 = aux_a1b1[9:-22];
assign a2b2 = aux_a2b2[9:-22];
assign a1b2 = aux_a1b2[9:-22];
assign a2b1 = aux_a2b1[9:-22];

endmodule