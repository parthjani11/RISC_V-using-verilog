module REG_FILE(
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

    reg [31:0] reg_memory [31:0]; // 32 memory locations each 32 bits wide
    integer i;

    // Register 0 is always hardwired to 0, and the rest are initialized on reset
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            for (i = 1; i < 32; i = i + 1) begin
                reg_memory[i] <= i;
            end
            reg_memory[0] <= 0; // Ensure reg 0 is always 0
        end else if (regwrite && write_reg != 0) begin
            reg_memory[write_reg] <= write_data;
        end
    end

    // The register file will always output the values corresponding to read register numbers
    always @(*) begin
        read_data1 = reg_memory[read_reg_num1];
        read_data2 = reg_memory[read_reg_num2];
    end

endmodule
