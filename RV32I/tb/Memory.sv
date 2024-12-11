`timescale 1ns/1ps

module Memory
#(
    parameter DATA_START_ADDRESS = 32'h00000000
)
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input  [ 13:0]  addr0_i
    ,input  [ 31:0]  data0_i
    ,input  [  3:0]  wr0_i
    ,input  [ 13:0]  addr1_i
    ,input  [ 31:0]  data1_i
    ,input  [  3:0]  wr1_i

    // Outputs
    ,output [ 31:0]  data0_o
    ,output [ 31:0]  data1_o
);



//-----------------------------------------------------------------
// Dual Port RAM 128KB
// Mode: Read First
//-----------------------------------------------------------------
/* verilator lint_off MULTIDRIVEN */
reg [31:0]   ram [16383:0] /*verilator public*/;
/* verilator lint_on MULTIDRIVEN */

reg [31:0] ram_read0_q;
reg [31:0] ram_read1_q;

logic [13:0] addr0;

assign addr0 = DATA_START_ADDRESS/4 + addr0_i;


// Synchronous write
always @ (posedge clk_i)
begin
    if (wr0_i[0])
        ram[addr0][7:0] <= data0_i[7:0];
    if (wr0_i[1])
        ram[addr0][15:8] <= data0_i[15:8];
    if (wr0_i[2])
        ram[addr0][23:16] <= data0_i[23:16];
    if (wr0_i[3])
        ram[addr0][31:24] <= data0_i[31:24];
end

always @ (addr0) ram_read0_q <= ram[addr0];


always @ (posedge clk_i)
begin
    if (wr1_i[0])
        ram[addr1_i][7:0] <= data1_i[7:0];
    if (wr1_i[1])
        ram[addr1_i][15:8] <= data1_i[15:8];
    if (wr1_i[2])
        ram[addr1_i][23:16] <= data1_i[23:16];
    if (wr1_i[3])
        ram[addr1_i][31:24] <= data1_i[31:24];
end

always @ (addr1_i) ram_read1_q <= ram[addr1_i];

assign data0_o = ram_read0_q;
assign data1_o = ram_read1_q;

task write; 
    input [31:0] addr;
    input [7:0]  data;
begin
    case (addr[1:0])
    2'd0: ram[addr/4][7:0]   = data;
    2'd1: ram[addr/4][15:8]  = data;
    2'd2: ram[addr/4][23:16] = data;
    2'd3: ram[addr/4][31:24] = data;
    endcase
end
endtask


endmodule
