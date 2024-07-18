module accum #(parameter DIM=3)(
    input clk, rst, ena,
    input [10:-21] data,

    output reg flag,
	 

	 output signed [20:-11] acc
);

localparam NBIT_ADDR = $clog2(DIM)+1;

reg [(NBIT_ADDR-1):0] cnt;

reg signed [20:-11] accaux;  



assign acc = accaux;


always@(posedge clk, negedge rst) begin
   if(!rst) begin
        accaux <= 0;
        flag <= 1'b0;
        cnt <= 2'b0;
   end 
   else begin
        if(cnt == DIM) begin
            accaux <= 0;
            flag <= 1'b0;
			cnt <= 2'b00;
        end
        else begin
            if(ena == 1'b1) begin
                if(cnt == (DIM-1)) begin
                    cnt <= cnt + 2'b1;
                    flag <= 1'b1;       
					accaux <= accaux + {{10{data[10]}}, data[10:0],data[-1:-11]};
                end
                else begin
					accaux <= accaux + {{10{data[10]}}, data[10:0],data[-1:-11]};
					cnt <= cnt + 2'b1;
                    flag <= 1'b0;
                end
            end
            else begin
                flag <= 1'b0;
            end
        end
   end
end

endmodule
