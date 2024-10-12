module processor_risc( 
    input clock, 
    input reset,
    output zero
);

    wire [31:0] instruction_code;
    wire [3:0] alu_control;
    wire regwrite;

    // Instantiate Instruction Fetch Unit
    IFU IFU_module(
        .clock(clock),
        .reset(reset),
        .instruction_code(instruction_code)  // Fixed naming
    );
    
    // Instantiate Control Unit
    control_1 control_module(
        .funct7(instruction_code[31:25]),
        .funct3(instruction_code[14:12]),
        .opcode(instruction_code[6:0]),
        .alu_control(alu_control),
        .regwrite(regwrite)
    );
    
    // Instantiate Data Path
    DATAPATH_1 datapath_module(
        .read_reg_num1(instruction_code[19:15]),
        .read_reg_num2(instruction_code[24:20]),
        .write_reg(instruction_code[11:7]),
        .alu_control(alu_control),
        .regwrite(regwrite),
        .clock(clock),
        .reset(reset),
        .zero_flag(zero)
    );

endmodule

module control_1(
    input [6:0] funct7,
    input [2:0] funct3,
    input [6:0] opcode,
    output reg [3:0] alu_control,
    output reg regwrite
);
    always @(*) begin
        if (opcode == 7'b0110011) begin // R-type instructions
            regwrite = 1;
            case (funct3)
                3'b000: begin
                    if (funct7 == 7'b0000000)
                        alu_control = 4'b0010; // ADD
                    else if (funct7 == 7'b0100000)
                        alu_control = 4'b0100; // SUB
                    else
                        alu_control = 4'b0000; // Default
                end
                3'b110: alu_control = 4'b0001; // OR
                3'b111: alu_control = 4'b0000; // AND
                3'b001: alu_control = 4'b0011; // SLL
                3'b101: alu_control = 4'b0101; // SRL
                3'b010: alu_control = 4'b0110; // MUL
                3'b100: alu_control = 4'b0111; // XOR
                default: alu_control = 4'b0000; // Default
            endcase
        end else begin
            regwrite = 0;
            alu_control = 4'b0000; // Default NOP
        end
    end
endmodule

module DATAPATH_1(
    input [4:0] read_reg_num1,
    input [4:0] read_reg_num2,
    input [4:0] write_reg,
    input [3:0] alu_control,
    input regwrite,
    input clock,
    input reset,
    output zero_flag
);

    // Internal wires
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_data;

    // Instantiate Register File
    REG_FILE_1 reg_file_module(
        .read_reg_num1(read_reg_num1),
        .read_reg_num2(read_reg_num2),
        .write_reg(write_reg),
        .write_data(write_data),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .regwrite(regwrite),
        .clock(clock),
        .reset(reset)
    );

    // Instantiate ALU
    ALU_1 alu_module(
        .in1(read_data1),
        .in2(read_data2),
        .alu_control(alu_control),
        .alu_result(write_data),
        .zero_flag(zero_flag)
    );
     
endmodule

module REG_FILE_1(
    input [4:0] read_reg_num1,
    input [4:0] read_reg_num2,
    input [4:0] write_reg,
    input [31:0] write_data,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2,
    input regwrite,
    input clock,
    input reset
);

    reg [31:0] reg_memory [31:0]; // 32 registers, each 32 bits wide
    integer i;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            reg_memory[0] <= 0; // Register x0 is always zero
            for (i = 1; i < 32; i = i + 1) begin
                reg_memory[i] <= i; // Initialize registers for testing
            end
        end else if (regwrite && write_reg != 0) begin
            reg_memory[write_reg] <= write_data;
        end
    end

    // Continuous read from registers
    always @(*) begin
        read_data1 = reg_memory[read_reg_num1];
        read_data2 = reg_memory[read_reg_num2];
    end

endmodule

module ALU_1 (
    input [31:0] in1,
    input [31:0] in2, 
    input [3:0] alu_control,
    output reg [31:0] alu_result,
    output reg zero_flag
);
    always @(*) begin
        case(alu_control)
            4'b0000: alu_result = in1 & in2;  // AND
            4'b0001: alu_result = in1 | in2;  // OR
            4'b0010: alu_result = in1 + in2;  // ADD
            4'b0100: alu_result = in1 - in2;  // SUB
            4'b1000: alu_result = (in1 < in2) ? 1 : 0; // SLT
            4'b0011: alu_result = in1 << in2; // SLL
            4'b0101: alu_result = in1 >> in2; // SRL
            4'b0110: alu_result = in1 * in2;  // MUL
            4'b0111: alu_result = in1 ^ in2;  // XOR
            default: alu_result = 0;          // Default
        endcase

        // Set zero_flag
        zero_flag = (alu_result == 0) ? 1'b1 : 1'b0;
    end
endmodule

module IFU(
    input clock,
    input reset,
    output [31:0] instruction_code  // fixed naming
);
    reg [31:0] pc_reg = 32'b0;  // Program counter

    // Instantiate Instruction Memory
    Instruction_Memory instr_mem(
        .pc(pc_reg),
        .reset(reset),
        .instruction_code(instruction_code)
    );

    always @(posedge clock or posedge reset) begin
        if (reset)
            pc_reg <= 0;
        else
            pc_reg <= pc_reg + 4; // Increment PC
    end
endmodule

module Instruction_Memory(
    input [31:0] pc,
    input reset,
    output reg [31:0] instruction_code
);
    reg [7:0] memory [0:31]; // 32 bytes of instruction memory

    always @(posedge reset) begin
        if (reset) begin
            // Initialize instructions
            // Instruction 1: add t1, s0, s1
            memory[0] = 8'h33;
            memory[1] = 8'h03;
            memory[2] = 8'h94;
            memory[3] = 8'h00;
            // Instruction 2: sub t2, s2, s3
            memory[4] = 8'hb3;
            memory[5] = 8'h03;
            memory[6] = 8'h39;
            memory[7] = 8'h41;
            // Instruction 3: mul t0, s4, s5
            memory[8]  = 8'hb3;
            memory[9]  = 8'h02;
            memory[10] = 8'h5a;
            memory[11] = 8'h03;
            // Instruction 4: xor t3, s6, s7
            memory[12] = 8'h33;
            memory[13] = 8'h4e;
            memory[14] = 8'h7b;
            memory[15] = 8'h01;
            // Instruction 5: sll t4, s8, s9
            memory[16] = 8'hb3;
            memory[17] = 8'h1e;
            memory[18] = 8'h9c;
            memory[19] = 8'h01;
            // Instruction 6: srl t5, s10, s11
            memory[20] = 8'h33;
            memory[21] = 8'h5f;
            memory[22] = 8'hbd;
            memory[23] = 8'h02;
        end
    end

    always @(*) begin
        // Fetch the instruction
        instruction_code = {memory[pc + 3], memory[pc + 2], memory[pc + 1], memory[pc]};
    end
endmodule
