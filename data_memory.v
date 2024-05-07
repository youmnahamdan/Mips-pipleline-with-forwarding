`include "defines.v"

module data_memory (
  input clk, rst, dataReadEnable, dataWriteEnable,
  input [`WORD_LEN-1:0] address, dataIn,
  output reg [`WORD_LEN-1:0] dataOut
);

  integer i;
  reg [`MEM_CELL_SIZE-1:0] dataMem [0:`DATA_MEM_SIZE-1];

  always @ (posedge clk) begin
    if (rst)
      for (i = 0; i < `DATA_MEM_SIZE; i = i + 1)
        dataMem[i] <= 0;
    else if (dataWriteEnable) begin
      {dataMem[address], dataMem[address + 1], dataMem[address + 2], dataMem[address + 3]} <= dataIn; 
    end
    else if (dataReadEnable) begin
      dataOut ={dataMem[address], dataMem[address + 1], dataMem[address + 2], dataMem[address + 3]};
    end
  end
  
endmodule // dataMem