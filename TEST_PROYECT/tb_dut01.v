`timescale 1ps/1ps
module tb_dut01();

parameter DIM = 32;
parameter ADDRESS = $clog2((DIM*DIM*2)-1);

reg clk_tb; 
reg rst_tb;
reg ena_tb;
reg [(ADDRESS-1):0] addr_am1_tb; 
reg [(ADDRESS-1):0] addr_bm1_tb;
reg [(ADDRESS-1):0] addr_am2_tb; 
reg [(ADDRESS-1):0] addr_bm2_tb;

wire flagR_tb;
wire flagI_tb;
wire clkslow_tb;
wire signed [20:-11] accR_tb;
wire signed [20:-11] accI_tb;
wire signed [4:-27] a1_tb;
wire signed [4:-27] a2_tb;
wire signed [4:-27] b1_tb;
wire signed [4:-27] b2_tb;
wire signed [9:-22] a1b1_tb;
wire signed [9:-22] a2b2_tb;
wire signed [9:-22] a1b2_tb;
wire signed [9:-22] a2b1_tb;
wire signed [10:-21] ab_real_tb;
wire signed [10:-21] ab_imag_tb;

integer i,j,h;
integer k,l;
integer fileR;
integer fileI;

top_dut01 #(  .NBIT(32),  .DIM(DIM)) DUT(
    .clk_top        (clk_tb),
    .rst_top        (rst_tb),
    .ena_top        (ena_tb),
    .addr_am1_top   (addr_am1_tb), 
    .addr_bm1_top   (addr_bm1_tb),
    .addr_am2_top   (addr_am2_tb),
    .addr_bm2_top   (addr_bm2_tb),

    .flagR_top       (flagR_tb),
    .flagI_top       (flagI_tb),
	.clkslow_top	(clkslow_tb),
    .accR_top        (accR_tb),
    .accI_top        (accI_tb),
    .a1_top         (a1_tb),
    .a2_top         (a2_tb),
    .b1_top         (b1_tb),
    .b2_top         (b2_tb),
    .a1b1_top       (a1b1_tb),
    .a2b2_top       (a2b2_tb),
    .a1b2_top       (a1b2_tb),
    .a2b1_top       (a2b1_tb)
);

initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, clk_tb);
    $dumpvars(1, clkslow_tb);
    $dumpvars(2, accR_tb);
    $dumpvars(3, accI_tb);

    clk_tb = 1'b0;
    rst_tb = 1'b1;
    
    #3 rst_tb = 1'b0;
    #3 rst_tb = 1'b1;

    #2500000 $stop;
end

initial begin
    #16;
    for(i=0; i<DIM; i=i+1) 
    begin
        for(h=0; h<DIM; h=h+1)
        begin
            for(j=0; j<DIM; j=j+1)
            begin
				@(posedge clkslow_tb)
                addr_am1_tb = 2*j+(DIM*2)*i;
                addr_bm1_tb = ((2*(j+1))-1)+(DIM*2)*i;
                #35;
            end
        end
    end
end

initial begin
    #16;
    for(l=0; l<DIM; l=l+1) 
    begin
        for(k=0; k<=((DIM*DIM)-1); k=k+1)
        begin
		    @(posedge clkslow_tb)
			ena_tb <= 1'b1;
            addr_am2_tb = 2*k;
            addr_bm2_tb = (2*(k+1))-1;
            #35 ena_tb <= 1'b0;
        end
    end
end

initial begin
    fileR = $fopen("outputR.txt", "w");
    if(fileR==0) $display("Error");
    else begin
        while(1) begin
			@(posedge clkslow_tb)
			#10;
			@(flagR_tb == 1'b1)
			$fwrite(fileR, "%b\n", accR_tb);
		  end
    end
    $fclose(fileR);
end

initial begin
    fileI = $fopen("outputI.txt", "w");
    if(fileI==0) $display("Error");
    else begin
        while(1) begin
			@(posedge clkslow_tb)
			#10;
			@(flagI_tb == 1'b1)
			$fwrite(fileI, "%b\n", accI_tb);
		  end
    end
    $fclose(fileI);
end

always#1 clk_tb = ~clk_tb;

endmodule
