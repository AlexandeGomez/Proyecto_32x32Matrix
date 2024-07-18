module stateMachOperateSignals #(parameter DIM=3)(
    input clk,
    input rst,
    input signal,

    output reg signalGenAddr,
    output reg signalAcum
);

reg [1:0] cnt; 
reg	[1:0] state;
localparam IDLE = 0, GENADDR = 1, WAIT = 2, ACUMULATE = 3;


always @(posedge clk, negedge rst) begin
	if (!rst) begin
        cnt <= 0;     
		state <= IDLE;
	end
	else
		case (state)
			IDLE:
				//idle body
                begin
                    if(signal==1'b1) begin
                        state <= GENADDR;
                    end
                    else begin
                        state <= IDLE;
                    end
                    signalAcum <= 0;
                    signalGenAddr <= 0;
                end
			GENADDR: //GENERADOR DE ADDRESS
                begin
                    signalGenAddr <= 1'b1;
                    state <= WAIT;
                end
			WAIT:
				//condaux body
				begin
                    signalAcum <= 0;
                    signalGenAddr <= 0;
                    if(cnt==3) begin
                        cnt <= 0;
                        state <= ACUMULATE;
                    end
                    else begin
                        state <= WAIT;
                        cnt <= cnt + 1'b1;
                    end
                end
			ACUMULATE:
				//out body
				begin
                    signalAcum <= 1'b1;
                    state <= IDLE;
                end
		endcase
end

endmodule
