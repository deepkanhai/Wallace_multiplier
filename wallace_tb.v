`timescale 1ns / 1ps
module wallace_tb;
	reg clk;
	reg [7:0] in1;
	reg [7:0] in2;
	wire [15:0] out;
	
	wallace_multiplier dut (clk,in1, in2, out );
	
	initial 
	begin
	clk = 1'b0;
	in1 <= 8'h70;
	in2 <= 8'h08;
	#100;
	end
	
	always @ (*) begin
	#100 clk <= ~clk;
	#50 in2 <= 8'h01;
	#50 in2 <= 8'h02;
	#50 in2 <= 8'h03;
	#50 in2 <= 8'h04;
	#50 in2 <= 8'h05;
	#50 in2 <= 8'h06;
	#50 in2 <= 8'h07;
	end
	
	
endmodule
