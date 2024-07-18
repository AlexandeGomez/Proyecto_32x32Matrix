module StateMachineGenDir2 #(parameter DIM=3)(
	input clk, 
	input ena, 
	input rst,

	output reg flag,
	output reg [$clog2(DIM*DIM-1) :0] q
);

reg [$clog2(DIM) :0] cntJump;
reg [$clog2(DIM) :0] cntAddr;
reg [$clog2(DIM**3) :0] exec;

reg	[2:0] state;

localparam IDLE = 0, CONDADDR = 1, CONDJUMP = 2, OUT = 3, CNTRF = 4;


// Determine the next state
always @(posedge clk, negedge rst) begin
	if (!rst) begin     
		flag <= 1'b1;
        cntJump <= 0;
        cntAddr <= 0;
        exec <= 0;
		q <= 0;
		state <= IDLE;
	end
	else
		case (state)
			IDLE:
				//idle body
				if(ena==1'b1 && flag==1'b1) begin
					state <= CONDADDR;
				end
				else begin
					state <= IDLE;
				end
			CONDADDR:
				//condaddr body
				if(exec==DIM**3) begin
					flag <= 1'b0;
					state <= IDLE;
				end
				else begin
					if(cntAddr==DIM) begin
						cntAddr <= 0;
						cntJump <= cntJump + 1'b1;
						state <= CONDJUMP;
					end
					else begin
						state <= CONDJUMP;
					end
				end
			CONDJUMP:
				//condaux body
				if(cntJump==DIM) begin
					cntJump <= 0;
					state <= OUT;
				end
				else begin
					state <= OUT;
				end
			OUT:
				//out body
				begin
				q <= (DIM*cntAddr) + cntJump;
				exec <= exec + 1'b1;
				state <= CNTRF;
				end
			CNTRF:
				begin
				cntAddr <= cntAddr + 1'b1;
				state <= IDLE;
				end
		endcase
end

endmodule
