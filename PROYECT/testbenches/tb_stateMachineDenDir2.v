`timescale 1ps/1ps
module tb_stateMachineDenDir2 #(parameter DIM=3)();

reg clk_tb; 
reg rst_tb; 
reg ena_tb;

wire flag_tb;
wire [$clog2(DIM*DIM-1) : 0] q_tb; 

StateMachineGenDir2 #(  .DIM(DIM)) GENDIRM2(
    .clk      (clk_tb), 
    .rst      (rst_tb), 
    .ena      (ena_tb),

    .flag      (flag_tb),
    .q         (q_tb) 
);

initial begin
    clk_tb = 1'b0;
    rst_tb = 1'b1;
    ena_tb = 1'b0;
    #1 rst_tb = 1'b0;
    #5 rst_tb = 1'b1;
    ena_tb = 1'b1;

    #600 $stop;
end

always#1 clk_tb = ~clk_tb;

endmodule