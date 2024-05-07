`include "defines.v"

module ALU (BusA, BusB, EXE_CMD, aluOut, Zero);
  input [`WORD_LEN-1:0] BusA, BusB;
  input [`EXE_CMD_LEN-1:0] EXE_CMD;
  output reg [`WORD_LEN-1:0] aluOut;
  output reg Zero;

  always @ ( * ) begin
    case (EXE_CMD)
      `EXE_ADD: aluOut <= BusA + BusB;
      `EXE_SUB: begin 
						aluOut <= BusA - BusB;
						Zero <= (BusA == BusB)? 1 : 0 ;
						end
      `EXE_AND: aluOut <= BusA & BusB;
      `EXE_OR:  aluOut <= BusA | BusB;
      `EXE_XOR: aluOut <= BusA ^ BusB;
		`EXE_SLT: aluOut <= (BusA < BusB)? 1 : 0 ;
      default:  aluOut <= 0;
    endcase
  end
endmodule
