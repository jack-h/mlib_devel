`define DEBUG
`define USE_CLOG2

/* Currently, Xilinx doesn't support $clog2, but iverilog doesn't support
 * constant user functions. Decide which to use here
 */
`ifndef log2
`ifdef USE_CLOG2
`define log2(p) $clog2(p)
`else
`define log2(p) log2_func(p)
`endif
`endif

module tb_xeng_top();

    function integer log2_func;
      input integer value;
      integer loop_cnt;
      begin
        value = value-1;
        for (loop_cnt=0; value>0; loop_cnt=loop_cnt+1)
          value = value>>1;
        log2_func = loop_cnt;
      end
    endfunction
    
    localparam PERIOD = 10;

    localparam SERIAL_ACC_LEN_BITS   = 7;  //Serial accumulation length (2^?)
    localparam P_FACTOR_BITS         = 2; //Number of samples to accumulate in parallel (2^?)
    localparam BITWIDTH              = 4;  //bitwidth of each real/imag part of a single sample
    localparam ACC_MUX_LATENCY       = 2;  //Latency of the mux to place the accumulation result on the xeng shift reg
    localparam FIRST_DSP_REGISTERS   = 2;  //number of registers on the input of the first DSP slice in the chain
    localparam DSP_REGISTERS         = 2;  //number of registers on the input of all others DSP slices in the chain
    localparam N_ANTS                = 32; //number of (dual pol) antenna inputs
    localparam BRAM_LATENCY          = 2;  //Latency of brams in delay chain
    localparam DEMUX_FACTOR          = 1;  //Demux Factor -- NOT YET IMPLEMENTED
    localparam MCNT_WIDTH            = 48; //MCNT bus width

    localparam MULT_LATENCY = ((1<<P_FACTOR_BITS)-1 + (FIRST_DSP_REGISTERS+2));         //Multiplier Latency (= latency of first DSP + 1 for every additional DSP)
    localparam ADD_LATENCY = 1;                                                         //Adder latency (currently hardcoded to 1)
    localparam P_FACTOR = 1<<P_FACTOR_BITS;                                             //number of parallel cmults
    localparam INPUT_WIDTH = 2*BITWIDTH*2*(1<<P_FACTOR_BITS);                           //width of complex in/out bus (dual pol)
    localparam ACC_WIDTH = 4*2*((2*BITWIDTH+1)+P_FACTOR_BITS+SERIAL_ACC_LEN_BITS);      //width of complex acc in/out bus (4 stokes)
    localparam N_TAPS = N_ANTS/2 + 1;                                                   //number of taps (including auto)
    localparam CORRECTION_ACC_WIDTH = P_FACTOR_BITS+SERIAL_ACC_LEN_BITS+BITWIDTH+1+1;   //width of correlation correction factors
    localparam SERIAL_ACC_LEN = (1<<SERIAL_ACC_LEN_BITS);                               //Serial accumulation length
    localparam ANT_BITS = `log2(N_ANTS);

    
    reg clk;                          //clock input
    reg ce;                           //clock enable input (not used -- for simulink compatibility only)
    reg sync_in;                      //sync input
    reg [INPUT_WIDTH-1:0] din;        //data input should be {{X_real, X_imag}*parallel samples, {Y_real, Y_imag}*parallel samples} 
    reg vld;                          //data in valid flag -- should be held high for whole window
    reg  [MCNT_WIDTH-1:0] mcnt;        //mcnt timestamp
    wire [ACC_WIDTH-1:0] dout;      //accumulation output (all 4 stokes)
    wire [ACC_WIDTH-1:0] dout_uncorr;      //accumulation output (all 4 stokes) with uint convert uncorrected
    wire sync_out;                    //sync output
    wire vld_out;                     //data output valid flag
    wire [MCNT_WIDTH-1:0] mcnt_out;   //mcnt of data being output

    reg [BITWIDTH-1:0] test_val;

    xeng_top #(
        .SERIAL_ACC_LEN_BITS(SERIAL_ACC_LEN_BITS),
        .P_FACTOR_BITS      (P_FACTOR_BITS      ),
        .BITWIDTH           (BITWIDTH           ),
        .ACC_MUX_LATENCY    (ACC_MUX_LATENCY    ),
        .FIRST_DSP_REGISTERS(FIRST_DSP_REGISTERS),
        .DSP_REGISTERS      (DSP_REGISTERS      ),
        .N_ANTS             (N_ANTS             ),
        .BRAM_LATENCY       (BRAM_LATENCY       ),
        //.DEMUX_FACTOR       (DEMUX_FACTOR       ),
        .MCNT_WIDTH         (MCNT_WIDTH         )
    ) uut (
        .clk         (clk),
        .ce          (ce),
        .sync_in     (sync_in),
        .din         (din),
        .vld         (vld),
        .mcnt        (mcnt),
         
        .dout        (dout),
        .dout_uncorr (dout_uncorr),
        .sync_out    (sync_out),
        .vld_out     (vld_out),
        .mcnt_out    (mcnt_out)
    );


    wire [ANT_BITS-1:0] ant_a_sel;
    wire [ANT_BITS-1:0] ant_b_sel;
    wire buf_sel;
    bl_order_gen #(
        .N_ANTS(N_ANTS)
        ) bl_order_gen_inst (
        .clk(clk),
        .sync(sync_out),
        .en(vld_out),
        .ant_a(ant_a_sel),
        .ant_b(ant_b_sel),
        .buf_sel(buf_sel)
    );

    // Initial values
    integer gold_in;
    initial begin
        gold_in = $fopenr("golden_inputs.dat"); //open file for reading
        clk = 0;
        ce = 0;
        sync_in = 0;
        din = 0;
        vld = 0;
        mcnt = 0;
        test_val = 4'b1001; 

        //sync
        #(100*PERIOD);
        //#(PERIOD/2);
        sync_in = 1'b1;
        #PERIOD
        sync_in = 1'b0;
        #(PERIOD*(1<<SERIAL_ACC_LEN_BITS)*N_ANTS*4) $finish;
    end

    always begin 
       clk = 1'b0;
       #(PERIOD/2) clk = 1'b1;
       #(PERIOD/2);
    end

    reg [31:0] input_ctr;
    always @(posedge(clk)) begin
        if (sync_in) begin
            vld <= 1'b1;
            input_ctr <= 32'b0;
        end else begin
            vld <= 1'b1;
            input_ctr <= input_ctr + 1'b1;
        end
    end

    //generate data
    localparam P_FACTOR_HARDCODE = 1<<2; //hack
    reg [BITWIDTH-1:0] file_val[2*P_FACTOR_HARDCODE-1:0];
    wire [2*P_FACTOR_HARDCODE*BITWIDTH-1:0] dat_single_pol = {file_val[7],file_val[6],file_val[5],file_val[4],
                                                    file_val[3],file_val[2],file_val[1], file_val[0]};
    //wire [2*P_FACTOR*BITWIDTH-1:0] dat_single_pol = {file_val[1],file_val[0]};
    wire [2*P_FACTOR*BITWIDTH-1:0] zero_uint = {2*P_FACTOR{1'b1,{(BITWIDTH-1){1'b0}}}};
    wire [2*P_FACTOR*BITWIDTH-1:0] zero_int = {2*P_FACTOR{1'b0,{(BITWIDTH-1){1'b0}}}};
                                                    

    integer null;
    always @(input_ctr) begin
        if (input_ctr == 32'b0) begin
            null = $fseek(gold_in, 0, 0); //Go to beginning of file
        end
        null = $fscanf(gold_in, "%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n", file_val[7], file_val[6], file_val[5],
                file_val[4], file_val[3], file_val[2], file_val[1], file_val[0]);
        //null = $fscanf(gold_in, "%d\n%d\n", file_val[1], file_val[0]);

        //din = {dat_single_pol[INPUT_WIDTH/2-1:0],dat_single_pol[INPUT_WIDTH/2-1:0]};
        din = {dat_single_pol[INPUT_WIDTH/2-1:0],zero_int};
    end

    wire [ACC_WIDTH/8 -1 : 0] xx_r = dout_uncorr[8*(ACC_WIDTH/8)-1:7*(ACC_WIDTH/8)];
    wire [ACC_WIDTH/8 -1 : 0] xx_i = dout_uncorr[7*(ACC_WIDTH/8)-1:6*(ACC_WIDTH/8)];
    wire [ACC_WIDTH/8 -1 : 0] yy_r = dout_uncorr[6*(ACC_WIDTH/8)-1:5*(ACC_WIDTH/8)];
    wire [ACC_WIDTH/8 -1 : 0] yy_i = dout_uncorr[5*(ACC_WIDTH/8)-1:4*(ACC_WIDTH/8)];
    wire [ACC_WIDTH/8 -1 : 0] xy_r = dout_uncorr[4*(ACC_WIDTH/8)-1:3*(ACC_WIDTH/8)];
    wire [ACC_WIDTH/8 -1 : 0] xy_i = dout_uncorr[3*(ACC_WIDTH/8)-1:2*(ACC_WIDTH/8)];
    wire [ACC_WIDTH/8 -1 : 0] yx_r = dout_uncorr[2*(ACC_WIDTH/8)-1:1*(ACC_WIDTH/8)];
    wire [ACC_WIDTH/8 -1 : 0] yx_i = dout_uncorr[1*(ACC_WIDTH/8)-1:0*(ACC_WIDTH/8)];

    wire [ACC_WIDTH/8 +0 -1 : 0] xx_r_c = dout[8*(ACC_WIDTH/8 + 0)-1:7*(ACC_WIDTH/8 + 0)];
    wire [ACC_WIDTH/8 +0 -1 : 0] xx_i_c = dout[7*(ACC_WIDTH/8 + 0)-1:6*(ACC_WIDTH/8 + 0)];
    wire [ACC_WIDTH/8 +0 -1 : 0] yy_r_c = dout[6*(ACC_WIDTH/8 + 0)-1:5*(ACC_WIDTH/8 + 0)];
    wire [ACC_WIDTH/8 +0 -1 : 0] yy_i_c = dout[5*(ACC_WIDTH/8 + 0)-1:4*(ACC_WIDTH/8 + 0)];
    wire [ACC_WIDTH/8 +0 -1 : 0] xy_r_c = dout[4*(ACC_WIDTH/8 + 0)-1:3*(ACC_WIDTH/8 + 0)];
    wire [ACC_WIDTH/8 +0 -1 : 0] xy_i_c = dout[3*(ACC_WIDTH/8 + 0)-1:2*(ACC_WIDTH/8 + 0)];
    wire [ACC_WIDTH/8 +0 -1 : 0] yx_r_c = dout[2*(ACC_WIDTH/8 + 0)-1:1*(ACC_WIDTH/8 + 0)];
    wire [ACC_WIDTH/8 +0 -1 : 0] yx_i_c = dout[1*(ACC_WIDTH/8 + 0)-1:0*(ACC_WIDTH/8 + 0)];

    initial begin
        $display("clock \t buf \t antA \t antB \t xx_r \t xx_i \t yy_r \t yy_i \t xy_r \t xy_i \t yx_r \t yx_i");
    end

    always @(posedge(clk)) begin
        //$display("SYNC %d, INPUT COUNT: %d, INPUT {%d,%d}{%d,%d}{%d,%d}{%d,%d}", sync_in, input_ctr, file_val[7], file_val[6], file_val[5], file_val[4],
        //                                                            file_val[3], file_val[2], file_val[1], file_val[0]);
        if(vld_out) begin
            $display("%d %d (%d,%d)\t%d(%d)\t%d(%d)\t%d(%d)\t%d(%d)\t%d(%d)\t%d(%d)\t%d(%d)\t%d(%d)",
                    clk_counter,buf_sel, ant_a_sel, ant_b_sel,
                    xx_r, xx_r_c, xx_i, xx_i_c, yy_r, yy_r_c, yy_i, yy_i_c,
                    xy_r, xy_r_c, xy_i, xy_i_c, yx_r, yx_r_c, yx_i, yx_i_c);
        end
    end

    reg [31:0] clk_counter=0;
    always @(posedge(clk)) begin
        clk_counter <= clk_counter + 1;
        if(clk_counter[9:0] == 0) begin
            $display("%d x 10^3 clocks passed", clk_counter[31:10]);
        end
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars;
    end


endmodule
