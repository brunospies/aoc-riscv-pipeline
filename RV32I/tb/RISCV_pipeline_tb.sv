module RISCV_pipeline_tb;

    logic clock = 0;
    logic reset;
    logic [3:0]  MemWrite;
    logic [31:0] instructionAddress, dataAddress, instruction, data_i, data_o;
    logic [7:0]  mem[131072:0];
    integer i;
    integer f;

    localparam logic [31:0] MARS_INSTRUCTION_OFFSET = 32'h00400000;
    localparam logic [31:0] MARS_DATA_OFFSET        = 32'h10010000;

    //DUT (Device Under Test) - RISCV_PIPELINE (VHDL)
    RISCV_PIPELINE #( 
        .PC_START_ADDRESS($unsigned(MARS_INSTRUCTION_OFFSET))
    ) DUV (
        .clock(clock),
        .reset(reset),
        .instructionAddress(instructionAddress),
        .instruction(instruction),
        .dataAddress(dataAddress),
        .data_i(data_i),
        .data_o(data_o),
        .MemWrite(MemWrite)
    );

    always #5 clock = ~clock;

    initial begin
        reset = 1'b1;
        #7;
        reset = 1'b0;

        // Load TCM memory
        for (i=0;i<131072;i=i+1)
            mem[i] = 0;

        f = $fopenr("./build/tcm.bin");
        i = $fread(mem, f);
        for (i=0;i<131072;i=i+1)
            u_mem.write(i, mem[i]);
    end

    Memory
u_mem
(
    // Inputs
     .clk_i(clock)
    ,.rst_i(reset)
    ,.data0_i(data_o)
    ,.addr0_i(dataAddress)
    ,.wr0_i(MemWrite)
    ,.data1_i(data_o)
    ,.addr1_i(instructionAddress)
    ,.wr1_i(4'b0)

    // Outputs
    ,.data0_o(data_i)
    ,.data1_o(instruction)
);


endmodule
