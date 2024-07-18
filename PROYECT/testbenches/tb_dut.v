`timescale 1ns/1ns
module tb_dut();

parameter ANCHO_PALABRA=32;
parameter DIM = 32;
parameter NBITS_PRESC = 1;

integer  i;
integer fileR1, fileI1;
integer fileR2, fileI2;
integer fileR, fileI;

reg clk_fast_tb;
reg rst_tb;
reg we_tb;
reg signal_tb;
reg [(ANCHO_PALABRA-1) :0] dataRAM_R1_tb;
reg [(ANCHO_PALABRA-1) :0] dataRAM_I1_tb;
reg [(ANCHO_PALABRA-1) :0] dataRAM_R2_tb;
reg [(ANCHO_PALABRA-1) :0] dataRAM_I2_tb;
reg [$clog2(DIM*DIM-1) :0] write_addr_R1_tb;
reg [$clog2(DIM*DIM-1) :0] write_addr_I1_tb;
reg [$clog2(DIM*DIM-1) :0] write_addr_R2_tb;
reg [$clog2(DIM*DIM-1) :0] write_addr_I2_tb;
reg signalup_recover_tb;

wire signalGenAddr_tb;
wire signalAcum_tb;
wire signed [4:-27] a1_tb;
wire signed [4:-27] a2_tb;
wire signed [4:-27] b1_tb;
wire signed [4:-27] b2_tb;
wire clk_slow_tb;
wire flagR_tb;
wire flagI_tb;
wire [$clog2(DIM*DIM-1) :0] read_addr_M1_tb;
wire [$clog2(DIM*DIM-1) :0] read_addr_M2_tb;
wire signed [9:-22] a1b1_tb;
wire signed [9:-22] a2b2_tb;
wire signed [9:-22] a1b2_tb;
wire signed [9:-22] a2b1_tb;
wire signed [10:-21] ab_real_tb;
wire signed [10:-21] ab_imag_tb;
wire signed [15:-16] accR_tb;
wire signed [15:-16] accI_tb;
wire [$clog2(DIM*DIM-1) :0] cnt_tb;
wire signed [15:-16] qR_tb;
wire signed [15:-16] qI_tb;


top_dut #(.ANCHO_PALABRA(ANCHO_PALABRA),	.DIM(DIM),	.NBITS_PRESC(NBITS_PRESC)) DUT(
    .clk_fast_top           (clk_fast_tb),
    .rst_top                (rst_tb),
    .we_top                 (we_tb),
    .signal_top             (signal_tb),
    .dataRAM_R1_top         (dataRAM_R1_tb),
    .dataRAM_I1_top         (dataRAM_I1_tb),
    .dataRAM_R2_top         (dataRAM_R2_tb),
    .dataRAM_I2_top         (dataRAM_I2_tb),
    .write_addr_R1_top      (write_addr_R1_tb),
    .write_addr_I1_top      (write_addr_I1_tb),
    .write_addr_R2_top      (write_addr_R2_tb),
    .write_addr_I2_top      (write_addr_I2_tb),
	 .signalup_recover_top	(signalup_recover_tb),

    .signalGenAddr_top      (signalGenAddr_tb),
    .signalAcum_top         (signalAcum_tb),
    .a1_top                 (a1_tb),
    .a2_top                 (a2_tb),
    .b1_top                 (b1_tb),
    .b2_top                 (b2_tb),
    .clk_slow_top           (clk_slow_tb),
    .flagR_top              (flagR_tb),
    .flagI_top              (flagI_tb),
    .read_addr_M1_top       (read_addr_M1_tb),
    .read_addr_M2_top       (read_addr_M2_tb),
    .a1b1_top               (a1b1_tb),
    .a2b2_top               (a2b2_tb),
    .a1b2_top               (a1b2_tb),
    .a2b1_top               (a2b1_tb),
    .ab_real_top            (ab_real_tb),
    .ab_imag_top            (ab_imag_tb),
	.accR_top               (accR_tb),
    .accI_top               (accI_tb),
	 .cnt_top					 (cnt_tb),
	 .qR_top						(qR_tb),
	.qI_top						(qI_tb)
);


initial begin
    //$dumpfile("test.vcd");
    //$dumpvars(0, clk_fast_tb);
    //$dumpvars(1, clk_slow_tb);
	 //$dumpvars(2, signalGenAddr_tb);
	 //$dumpvars(3, signalAcum_tb);
	 //$dumpvars(4, a1_tb);
	 //$dumpvars(5, a2_tb);
	 //$dumpvars(6, b1_tb);
	 //$dumpvars(7, b2_tb);
	 //$dumpvars(8, ab_real_tb);
	 //$dumpvars(9, ab_imag_tb);
	 //$dumpvars(10,flagR_tb);
    //$dumpvars(11, accR_tb);
    //$dumpvars(12, accI_tb);

    fileR1 = $fopen("Reales_M1.txt", "r");
    fileI1 = $fopen("Imagin_M1.txt", "r");
    fileR2 = $fopen("Reales_M2.txt", "r");
    fileI2 = $fopen("Imagin_M2.txt", "r");
	     
	 fileR = $fopen("outputR.txt", "w");
	 fileI = $fopen("outputI.txt", "w");
	 
	 #2000000;
	 signalup_recover_tb = 1'b1;
	 #500
	 
    $fclose(fileR);
	 $fclose(fileR1);
    $fclose(fileI1);
    $fclose(fileR2);
    $fclose(fileI2);
    $stop;
end

always@(posedge flagR_tb) begin
		$fwrite(fileR, "%b\n", accR_tb);
end

always@(posedge flagR_tb) begin
		$fwrite(fileI, "%b\n", accI_tb);
end

initial begin
	//inicializando variables
    clk_fast_tb = 1'b0;
    rst_tb = 1'b1;
    we_tb = 1'b0;
	 signal_tb = 1'b0;
	 signalup_recover_tb = 1'b0;
    #1 rst_tb = 1'b0;
    #10 rst_tb = 1'b1;

    for(i=0; i<=(DIM*DIM); i=i+1) begin
        @(posedge clk_slow_tb)
        we_tb = 1'b1;
		  $fscanf(fileR1,"%b\n",dataRAM_R1_tb);
        $fscanf(fileI1,"%b\n",dataRAM_I1_tb);
        $fscanf(fileR2,"%b\n",dataRAM_R2_tb);
        $fscanf(fileI2,"%b\n",dataRAM_I2_tb);
        write_addr_R1_tb = i;
        write_addr_I1_tb = i;
        write_addr_R2_tb = i;
        write_addr_I2_tb = i;
    end
    we_tb = 1'b0;
	 #10;
	signal_tb = 1'b1;
end

always#1 clk_fast_tb = ~clk_fast_tb;

endmodule