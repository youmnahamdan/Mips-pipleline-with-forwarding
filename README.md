# Mips-pipleline-with-forwarding
This project is part of ACA course instructed by Dr. Emad. This project implements MIPS pipeine with forwarding.


## Plan and block ownership:
  Youmna:
  <ul>
    <li>ALU</li>
    <li>Instruction memory</li>
    <li>Forwarding unit</li>
    <li>buffers</li>
    <li>Muxes</li>
  </ul>
    
  Mayar:
  <ul>
    <li>Register file</li>
    <li>Data Memory</li>
    <li>Control unit</li>
    <li>PC</li>
    <li>Hazard Unit</li>
  </ul>


<hr>

# Project Implemntation

### Attempt to create a schematic of Datapath:
The full datapath is constructed using blocks provided in the repository, such as the controller, hazard unit, and instruction memory. Unfortunately, we couldn't get the datapath running due to unclear errors and the tight time frame. However, we managed to verify the functionality of its components (we will provide waveforms shortly).

This is an illustration of the entire datapath.
![image](https://github.com/youmnahamdan/Mips-pipleline-with-forwarding/assets/79578959/bf6afd6a-2823-4fac-9a9a-fbc2f5ba2ea7)

A close up on Datapth:
![image](https://github.com/youmnahamdan/Mips-pipleline-with-forwarding/assets/79578959/304d0ea7-9583-419e-adaa-12ec51149154)
![image](https://github.com/youmnahamdan/Mips-pipleline-with-forwarding/assets/79578959/26e169a0-73a8-4b97-9f75-749a33d0b427)
![image](https://github.com/youmnahamdan/Mips-pipleline-with-forwarding/assets/79578959/4340abe6-728f-4c3e-95a0-e27b7fbd336b)

WE APOLOGIZE FOR THE INCONVENIENCE!!!


### Sample tests of some units:
Register File:
Testbench:
```
`include "defines.v"

`timescale 1ns/1ps

module register_file_tb;

  // Parameters
  parameter SIM_TIME = 100;

  // Inputs
  reg clk;
  reg rst;
  reg regWrite;
  reg [`REG_FILE_ADDR_LEN-1:0] Rs;
  reg [`REG_FILE_ADDR_LEN-1:0] Rt;
  reg [`REG_FILE_ADDR_LEN-1:0] Rd;
  reg [`WORD_LEN-1:0] writeData;

  // Outputs
  wire [`WORD_LEN-1:0] reg1;
  wire [`WORD_LEN-1:0] reg2;

  // Instantiate the register file module
  register_file uut (
    .clk(clk),
    .rst(rst),
    .Rs(Rs),
    .Rt(Rt),
    .Rd(Rd),
    .writeData(writeData),
    .regWrite(regWrite),
    .reg1(reg1),
    .reg2(reg2)
  );

  // Clock generation
  reg clk_gen = 0;
  always #5 clk_gen = ~clk_gen;

  // Stimulus
  initial begin
    $dumpfile("register_file_tb.vcd");
    $dumpvars(0, register_file_tb);

    // Initialize inputs
    clk = 0;
    rst = 1;
    regWrite = 0;
    Rs = 3'b000;
    Rt = 3'b001;
    Rd = 3'b010;
    writeData = 8'hFF;

    // Release reset
    #10 rst = 0;

    // Apply stimulus
    #20;
    clk = 1;
    writeData = 8'h0A;
    regWrite = 1;
    Rd = 3'b000;
    #10;
    regWrite = 0;
    #10;
    Rs = 3'b010;
    Rt = 3'b000;
    #10;
    Rs = 3'b001;
    Rt = 3'b010;
    #10;
    Rs = 3'b011;
    Rt = 3'b010;
    #10;

    // End simulation
    #SIM_TIME;
    $finish;
  end

  // Monitor
  always @(posedge clk_gen) begin
    $display("Time=%0d, clk=%b, rst=%b, Rs=%b, Rt=%b, Rd=%b, writeData=%h, regWrite=%b, reg1=%h, reg2=%h", $time, clk, rst, Rs, Rt, Rd, writeData, regWrite, reg1, reg2);
  end

endmodule

```

#### Waveform:
![EDA WaveForm register file](https://github.com/youmnahamdan/Mips-pipleline-with-forwarding/assets/79578959/24a7200f-58c8-4ec5-842d-273bb8ad7bb5)



ALU:
Testbench:
```
`include "defines.v"

`timescale 1ns/1ps

module ALU_tb;

  // Parameters
  parameter SIM_TIME = 100;

  // Inputs
  reg [`WORD_LEN-1:0] BusA;
  reg [`WORD_LEN-1:0] BusB;
  reg [`EXE_CMD_LEN-1:0] EXE_CMD;

  // Outputs
  wire [`WORD_LEN-1:0] aluOut;
  wire Zero;

  // Instantiate the ALU module
  ALU uut (
    .BusA(BusA),
    .BusB(BusB),
    .EXE_CMD(EXE_CMD),
    .aluOut(aluOut),
    .Zero(Zero)
  );

  // Clock generation
  reg clk = 0;
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    $dumpfile("ALU_tb.vcd");
    $dumpvars(0, ALU_tb);

    // Initialize inputs
    BusA = 8'h0;
    BusB = 8'h0;
    EXE_CMD = `EXE_ADD;

    // Apply stimulus
    #10;
    BusA = 8'h5;
    BusB = 8'h3;
    EXE_CMD = `EXE_ADD;
    #10;
    BusA = 8'h6;
    BusB = 8'h3;
    EXE_CMD = `EXE_SUB;
    #10;
    BusA = 8'h6;
    BusB = 8'h3;
    EXE_CMD = `EXE_AND;
    #10;
    BusA = 8'h6;
    BusB = 8'h3;
    EXE_CMD = `EXE_OR;
    #10;
    BusA = 8'h6;
    BusB = 8'h3;
    EXE_CMD = `EXE_XOR;
    #10;
    BusA = 8'h6;
    BusB = 8'h3;
    EXE_CMD = `EXE_SLT;
    #10;
    // Add more test cases as needed

    // End simulation
    #SIM_TIME;
    $finish;
  end

  // Monitor
  always @(posedge clk) begin
    $display("Time=%0d, BusA=%h, BusB=%h, EXE_CMD=%h, aluOut=%h, Zero=%h", $time, BusA, BusB, EXE_CMD, aluOut, Zero);
  end

endmodule

```
#### Waveform
![EDA WaveForm ](https://github.com/youmnahamdan/Mips-pipleline-with-forwarding/assets/79578959/7a2f2e6c-4a5c-4473-a43e-75c6f25a2fea)

   
### Reference:
GitHub repository: https://github.com/mhyousefi/MIPS-pipeline-processor/tree/master
