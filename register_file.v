`include "defines.v"

module register_file (clk, rst, Rs, Rt, Rd, writeData, regWrite, reg1, reg2);
  input clk, rst, regWrite;
  input [`REG_FILE_ADDR_LEN-1:0] Rs, Rt, Rd;
  input [`WORD_LEN-1:0] writeData;
  output [`WORD_LEN-1:0] reg1, reg2;

  reg [`WORD_LEN-1:0] regMem [0:`REG_FILE_SIZE-1];
  integer i;

  always @ (negedge clk) begin
    if (rst) begin
      for (i = 0; i < `WORD_LEN; i = i + 1)
        regMem[i] <= 0;
	    end

    else if (regWrite) regMem[Rd] <= writeData;
    regMem[0] <= 0;
  end

  assign reg1 = (regMem[Rs]);
  assign reg2 = (regMem[Rt]);
endmodule // regFile