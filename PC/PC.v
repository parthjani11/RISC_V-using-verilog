module PC(
          input [31:0]pc,
			 input reset,
			 output [31:0]instruction_code
			 
);
reg [7:0]memory [31:0];

assign instruction_code={memory[pc+3],memory[pc+2],memory[pc+1],memory[pc]};
always@(reset)
begin
if(reset==1)
begin
// Setting 32-bit instruction: add t1, s0,s1 => 0x00940333 
            memory[3] = 8'h00;
            memory[2] = 8'h94;
            memory[1] = 8'h03;
            memory[0] = 8'h33;
            // Setting 32-bit instruction: sub t2, s2, s3 => 0x413903b3
            memory[7] = 8'h41;
            memory[6] = 8'h39;
            memory[5] = 8'h03;
            memory[4] = 8'hb3;
            // Setting 32-bit instruction: mul t0, s4, s5 => 0x035a02b3
            memory[11] = 8'h03;
            memory[10] = 8'h5a;
            memory[9] = 8'h02;
            memory[8] = 8'hb3;
            // Setting 32-bit instruction: xor t3, s6, s7 => 0x017b4e33
            memory[15] = 8'h01;
            memory[14] = 8'h7b;
            memory[13] = 8'h4e;
            memory[12] = 8'h33;
            // Setting 32-bit instruction: sll t4, s8, s9
            memory[19] = 8'h01;
            memory[18] = 8'h9c;
            memory[17] = 8'h1e;
            memory[16] = 8'hb3;
            // Setting 32-bit instruction: srl t5, s10, s11
            memory[23] = 8'h01;
            memory[22] = 8'hbd;
            memory[21] = 8'h5f;
            memory[20] = 8'h33;
            // Setting 32-bit instruction: and t6, a2, a3
            memory[27] = 8'h00;
            memory[26] = 8'hd6;
            memory[25] = 8'h7f;
            memory[24] = 8'hb3;
            // Setting 32-bit instruction: or a7, a4, a5
            memory[31] = 8'h00;
            memory[30] = 8'hf7;
            memory[29] = 8'h68;
            memory[28] = 8'hb3;
				end
				end
				endmodule
				
				
				
