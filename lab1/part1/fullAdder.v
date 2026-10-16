module fullAdder(input cin, input a, input b, output s, output cout);

	// Sum is the low bit; carry is 1 when at least two inputs are 1.
	assign s = a ^ b ^ cin;
	assign cout = (a & b) | (a & cin) | (b & cin);
endmodule
