module RISCV_pipeline_tb;

    logic clock = 0;
    logic reset;
    logic MemWrite;
    logic [31:0] instructionAddress, dataAddress, instruction, data_i, data_o;

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

    Memory #(
        .SIZE(100),
        .START_ADDRESS(MARS_INSTRUCTION_OFFSET),
        .imageFileName("BubbleSort_code.txt")
    ) INSTRUCTION_MEMORY (
        .clock(clock),
        .MemWrite(1'b0),
        .address(instructionAddress),
        .data_i(data_o),
        .data_o(instruction)
    ); 

    Memory #(
        .SIZE(100),
        .START_ADDRESS(MARS_DATA_OFFSET),
        .imageFileName("BubbleSort_data.txt")
    ) DATA_MEMORY (
        .clock(clock),
        .MemWrite(MemWrite),
        .address(dataAddress),
        .data_i(data_o),
        .data_o(data_i)
    );

    always #5 clock = ~clock;

    initial begin
        reset = 1'b1;
        #7;
        reset = 1'b0;
    end

endmodule
