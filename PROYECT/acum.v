module accum #(parameter DIM=3)(
    input clk, rst, ena,
    input [10:-21] data,

    output reg flag,
	output signed [15:-16] acc
);

localparam NBIT_ADDR = $clog2(DIM)+1;

reg [(NBIT_ADDR-1):0] cnt;
reg condicion;

reg signed [15:-16] accaux;  

reg [$clog2(DIM*DIM) :0] exec;

assign acc = accaux;


always@(posedge clk, negedge rst) begin
   if(!rst) begin
        accaux <= 0;
        flag <= 1'b0;
        cnt <= 2'b0;
		exec <= 0;
		condicion <= 1'b1;
   end 
   else begin
        if(cnt == DIM) begin
            accaux <= 0;
            flag <= 1'b0;
			cnt <= 2'b00;
				if(exec==DIM*DIM) begin
					condicion <= 1'b0;
				end
        end
        else begin
            if(ena == 1'b1 && condicion==1'b1) begin
                if(cnt == (DIM-1)) begin
                    cnt <= cnt + 2'b1;
                    flag <= 1'b1; 
					exec <= exec + 1'b1;
					accaux <= accaux + {{5{data[10]}}, data[10:0],data[-1:-16]};
                end
                else begin
					accaux <= accaux + {{5{data[10]}}, data[10:0],data[-1:-16]};
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
