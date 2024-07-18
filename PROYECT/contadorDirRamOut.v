module contadorDirRamOut #(parameter DIM=3)(
	input clk, rst,
	input signalUp,
	input signalup_recover,
	
	output reg [$clog2(DIM*DIM-1) :0] cnt 
);

always@(posedge clk, negedge rst) begin
	if(!rst) begin
		cnt <= 0;
	end
	else begin
		if(signalUp == 1'b1 || signalup_recover==1'b1) begin
			if(cnt==(DIM*DIM-1))
				cnt <= 0;
			else
				cnt <= cnt + 1'b1;
		end
		else
		cnt <= cnt;
	end
end 

endmodule
