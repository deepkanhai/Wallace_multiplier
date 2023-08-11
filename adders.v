module full_adder(clk, a,b,cin,s,cout);
	input clk,a,b,cin;
	output s, cout;
	
	assign s = a ^ b ^ cin;
	assign cout = (a & b) | cin & (a | b);
endmodule


module half_adder (clk,a,b,s,cout);
	input clk,a,b;
	output s,cout;
	
	assign s = a ^ b;
	assign cout = a & b;
endmodule	
