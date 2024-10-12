# RISC Processor Design: Verilog Implementation

## Overview

This project is a Verilog-based implementation of a basic RISC (Reduced Instruction Set Computer) processor. The processor features instruction fetching, a control unit, a datapath with register file, ALU, and basic instruction memory. This is a simplified model for educational purposes, supporting common R-type operations such as `ADD`, `SUB`, `OR`, `AND`, `SLL`, `SRL`, `MUL`, and `XOR`.

### Original Project
This project is inspired by and based on work performed by **Ash Olakangal**. You can find the original implementation and more details at [https://github.com/ash-olakangal/RISC-V-Processor](https://github.com/ash-olakangal/RISC-V-Processor). 

The current project is a personal exercise aimed at refining the basics and gaining a better understanding of how to design a RISC-V processor using Verilog.

## Module Descriptions

### Top Module: `processor_risc`
This is the top-level module that connects the main components of the processor:
- **Instruction Fetch Unit (IFU)**
- **Control Unit**
- **Data Path**

It takes `clock` and `reset` as inputs and outputs a `zero` signal, indicating when the result from the ALU is zero.

### 1. **IFU (Instruction Fetch Unit)**
Responsible for fetching instructions from memory. It contains a program counter (`pc_reg`) that increments on every clock cycle to point to the next instruction.
- **Inputs:** `clock`, `reset`
- **Output:** `instruction_code` (32-bit instruction)

### 2. **Control Unit**
The control unit decodes the instruction fetched by the IFU and generates control signals required to perform operations. It decodes the `funct7`, `funct3`, and `opcode` fields of the instruction and generates:
- **alu_control** (4-bit ALU control signal)
- **regwrite** (enables writing to the register file)

Supported operations:
- **ADD**, **SUB**, **OR**, **AND**, **SLL**, **SRL**, **MUL**, **XOR**

### 3. **DATAPATH_1**
The datapath module manages data flow and connects the **Register File** and the **ALU**. It reads from two source registers, performs the operation using the ALU, and writes the result back to the destination register.
- **Inputs:** `read_reg_num1`, `read_reg_num2`, `write_reg`, `alu_control`, `regwrite`, `clock`, `reset`
- **Output:** `zero_flag` (high when ALU result is zero)

### 4. **REG_FILE_1 (Register File)**
This module handles the register file, consisting of 32 registers, each 32 bits wide. It supports continuous reads from two registers and writing to a register (if `regwrite` is enabled).
- **Inputs:** `read_reg_num1`, `read_reg_num2`, `write_reg`, `write_data`, `regwrite`, `clock`, `reset`
- **Outputs:** `read_data1`, `read_data2`

### 5. **ALU (Arithmetic Logic Unit)**
Performs arithmetic and logic operations based on the control signal `alu_control`. It supports operations such as:
- **AND**, **OR**, **ADD**, **SUB**, **SLT**, **SLL**, **SRL**, **MUL**, **XOR**

The result is returned, and a `zero_flag` is set if the result is zero.

### 6. **Instruction Memory**
Stores a small set of predefined instructions (up to 8 instructions, each 32 bits wide) and outputs the current instruction based on the value of the program counter.
- **Inputs:** `pc`, `reset`
- **Output:** `instruction_code`

#### Predefined Instructions
1. **ADD t1, s0, s1**: Add the values of registers `s0` and `s1`, store result in `t1`
2. **SUB t2, s2, s3**: Subtract the value of `s3` from `s2`, store result in `t2`
3. **MUL t0, s4, s5**: Multiply the values of `s4` and `s5`, store result in `t0`
4. **XOR t3, s6, s7**: XOR the values of `s6` and `s7`, store result in `t3`
5. **SLL t4, s8, s9**: Shift the value of `s8` left by `s9` bits, store result in `t4`
6. **SRL t5, s10, s11**: Shift the value of `s10` right by `s11` bits, store result in `t5`

## File Structure
```
.
├── processor_risc.v          # Top-level module for RISC processor
├── control_1.v               # Control unit
├── DATAPATH_1.v              # Data path connecting ALU and register file
├── REG_FILE_1.v              # Register file with 32 registers
├── ALU_1.v                   # ALU performing arithmetic and logic operations
├── IFU.v                     # Instruction Fetch Unit
├── Instruction_Memory.v      # Instruction memory with hardcoded instructions
└── README.md                 # Project documentation
```

## How to Simulate

1. **Simulation Environment:**
   You can use any Verilog simulator such as:
   - ModelSim
   - Icarus Verilog
   - Xilinx Vivado
  
2. **Testbench:**
   - Create a testbench file to initialize the `clock` and `reset` signals.
   - Monitor the output values such as `zero_flag`, `alu_result`, and ensure the instructions are being fetched and executed correctly.

3. **Run the Simulation:**
   - Load the modules into the simulator.
   - Observe the waveforms and values to verify that the processor is executing the instructions as expected.

## Future Enhancements

- Add support for **I-type** and **J-type** instructions to handle immediate values and jumps.
- Implement **Data Memory** for load/store operations.
- Extend instruction memory for more complex programs.
- Add **hazard detection** and **pipelining** for performance improvements.

