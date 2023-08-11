module wallace_multiplier(clk,in1, in2, out );    //32-bits (16x16)
	input clk;
	input [7:0] in1;
	input [7:0] in2;
	output reg [15:0] out;
	
	reg [7:0] part_prod1 [0:7]; 
	wire [15:0] part_prod2 [0:5]; 
	wire [15:0] part_prod3 [0:3]; 
	wire [15:0] part_prod4 [0:2]; 
	wire [15:0] part_prod5 [0:1]; 
	wire [15:0] part_prod6; 
	wire [10:0] final_carry;
	
	initial begin
	out[15:0] <=16'h0000;
	end
	
//Partial product-1 
	integer i;
	always @ (*) 
	begin
		for (i=0; i<8; i = i+1)
		begin
			case (in2[i])
				1'b1: part_prod1[i] = in1;
				default: part_prod1[i] = 0;
			endcase
		end
	end
	
//Partial product-2
	genvar j;
	genvar k;
	generate 
		for (k=0;k<6; k=k+1) 
		begin :dut2
			full_adder d0 (clk, part_prod1[0][k+2], part_prod1[1][k+1], part_prod1[2][k],part_prod2[0][k+2],part_prod2[1][k+3]);
			full_adder d1 (clk, part_prod1[3][k+2], part_prod1[4][k+1], part_prod1[5][k],part_prod2[2][k+5],part_prod2[3][k+6]);			
		end
	endgenerate
	
	half_adder d2 (clk, part_prod1[0][1], part_prod1[1][0], part_prod2[0][1],part_prod2[1][2]);
	half_adder d3 (clk, part_prod1[1][7], part_prod1[2][6], part_prod2[0][8],part_prod2[1][9]);
	half_adder d4 (clk, part_prod1[3][1], part_prod1[4][0], part_prod2[2][4],part_prod2[3][5]);
	half_adder d5 (clk, part_prod1[4][7], part_prod1[5][6], part_prod2[2][11],part_prod2[3][12]);
	
	assign part_prod2[0][0] = part_prod1[0][0];
	assign part_prod2[2][3] = part_prod1[3][0];
	assign part_prod2[0][9] = part_prod1[2][7];
	assign part_prod2[2][12] = part_prod1[5][7];
	
	assign part_prod2[4][13:6] = part_prod1[6];
	assign part_prod2[5][14:7] = part_prod1[7];
	
//Partial product-3
	 generate 
		for (k=3;k<10; k=k+1) 
		begin :dut3
			full_adder d2 (clk, part_prod2[0][k], part_prod2[1][k], part_prod2[2][k],part_prod3[0][k],part_prod3[1][k+1]);
		end
	endgenerate
	
	generate 
		for (k=7;k<13; k=k+1) 
		begin :dut4
			full_adder d4 (clk, part_prod2[0][k], part_prod2[1][k], part_prod2[2][k],part_prod3[2][k],part_prod3[3][k+1]);
		end
	endgenerate
		
	half_adder h1 (clk, part_prod2[0][2], part_prod2[1][2], part_prod3[0][2],part_prod3[1][3]);
	half_adder h2 (clk, part_prod2[3][6], part_prod2[4][6], part_prod3[2][6],part_prod3[3][7]);
	half_adder h3 (clk, part_prod2[4][13], part_prod2[5][13], part_prod3[2][13],part_prod3[3][14]);

	assign part_prod3[0][0] = part_prod2[0][0];
	assign part_prod3[0][1] = part_prod2[0][1];
	assign part_prod3[2][5] = part_prod2[3][5];
	assign part_prod3[0][10] = part_prod2[2][10];
	assign part_prod3[1][11] = part_prod2[2][11];
	assign part_prod3[1][12] = part_prod2[2][12];
	assign part_prod3[2][14] = part_prod2[5][14];
	
//Partial product-4
	generate 
		for (k=5;k<11; k=k+1) 
		begin :dut6
			full_adder d3 (clk, part_prod3[0][k], part_prod3[1][k], part_prod3[2][k],part_prod4[0][k],part_prod4[1][k+1]);
		end
	endgenerate
	
	half_adder h4 (clk, part_prod3[0][3], part_prod3[1][3], part_prod4[0][3],part_prod4[1][4]);
	half_adder h5 (clk, part_prod3[0][4], part_prod3[1][4], part_prod4[0][4],part_prod4[1][5]);
	half_adder h6 (clk, part_prod3[1][11], part_prod3[2][11], part_prod4[0][11],part_prod4[1][12]);
	half_adder h7 (clk, part_prod3[1][12], part_prod3[2][12], part_prod4[0][12],part_prod4[1][13]);

	assign part_prod4[0][2:0] = part_prod3[0][2:0];
	assign part_prod4[0][13] = part_prod3[2][13];
	assign part_prod4[1][14] = part_prod3[2][14];
	assign part_prod4[2][14:7] = part_prod3[3][14:7];
	
//Partial product-5

	generate 
		for (k=7;k<14; k=k+1) 
		begin :dut5
			full_adder d4 (clk, part_prod4[0][k], part_prod4[1][k], part_prod4[2][k],part_prod5[0][k],part_prod5[1][k+1]);
		end
	endgenerate
	
	half_adder h8 (clk, part_prod4[0][4], part_prod4[1][4], part_prod5[0][4],part_prod5[1][5]);
	half_adder h9 (clk, part_prod4[0][5], part_prod4[1][5], part_prod5[0][5],part_prod5[1][6]);
	half_adder h10 (clk, part_prod4[0][6], part_prod4[1][6], part_prod5[0][6],part_prod5[1][7]);
	half_adder h11 (clk, part_prod4[1][14], part_prod4[2][14], part_prod5[0][14],part_prod5[1][15]);

	assign part_prod5[0][3:0] = part_prod4[0][3:0];
	
//FInal output
	
	assign part_prod6[4:0] = part_prod5[0][4:0];
	
	half_adder h12 (clk, part_prod5[0][5],  part_prod5[1][5], 					  part_prod6[5], final_carry[0]);
	full_adder h13 (clk, part_prod5[0][6],  part_prod5[1][6], final_carry[0], part_prod6[6], final_carry[1]);
	full_adder h14 (clk, part_prod5[0][7],  part_prod5[1][7], final_carry[1], part_prod6[7], final_carry[2]);
	full_adder h15 (clk, part_prod5[0][8],  part_prod5[1][8], final_carry[2], part_prod6[8], final_carry[3]);
	full_adder h16 (clk, part_prod5[0][9],  part_prod5[1][9], final_carry[3], part_prod6[9], final_carry[4]);
	full_adder h17 (clk, part_prod5[0][10], part_prod5[1][10],final_carry[4], part_prod6[10],final_carry[5]);
	full_adder h18 (clk, part_prod5[0][11], part_prod5[1][11],final_carry[5], part_prod6[11],final_carry[6]);
	full_adder h19 (clk, part_prod5[0][12], part_prod5[1][12],final_carry[6], part_prod6[12],final_carry[7]);
	full_adder h20 (clk, part_prod5[0][13], part_prod5[1][13],final_carry[7], part_prod6[13],final_carry[8]);
	full_adder h21 (clk, part_prod5[0][14], part_prod5[1][14],final_carry[8], part_prod6[14],final_carry[9]);
	full_adder h22 (clk, part_prod5[0][15], part_prod5[1][15],final_carry[9], part_prod6[15],final_carry[10]);

	always @ (*) begin
	out <= part_prod6;
	end

	
endmodule	
