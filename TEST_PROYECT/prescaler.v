module prescaler #(parameter NBITS=13)(
    input clk_fast,
    input rst,
    
    output reg clk_slow
);

localparam MAX = (2**NBITS)-1;

reg [(NBITS-1) : 0] count;

always@(posedge clk_fast, negedge rst) begin
    if(!rst) begin
        clk_slow <= 1'b0;
        count <= 0;
    end
    else begin
        if(count == MAX) begin
            count <= 0;
            clk_slow <= 1'b1;
        end
        else begin
            count <= count + {{(NBITS-1){1'b0}}, {1'b1}};
            clk_slow <= 1'b0;
        end
    end
end


endmodule