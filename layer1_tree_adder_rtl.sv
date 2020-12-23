`timescale 1ns/10ps
module layer1_tree_adder(
	input_data1,
	input_data2,
	input_data3,
	input_data4,
	input_data5,
	input_data6,
	input_data7,
	input_data8,
	input_data9,
	bias,
	output_data
);
	input signed  [15:0] input_data1;
	input signed  [15:0] input_data2;
	input signed  [15:0] input_data3;
	input signed  [15:0] input_data4;
	input signed  [15:0] input_data5;
	input signed  [15:0] input_data6;
	input signed  [15:0] input_data7;
	input signed  [15:0] input_data8;
	input signed  [15:0] input_data9;
	input signed  [15:0] bias;
	
	output logic signed [15:0] output_data;
	
	logic signed  [15:0] add_data1;
	logic signed  [15:0] add_data2;
	logic signed  [15:0] add_data3;
	logic signed  [15:0] add_data4;
	logic signed  [15:0] add_data5;
	logic signed  [15:0] add_data6;
	logic signed  [15:0] add_data7;
	logic signed  [15:0] add_data8;
	
	always_comb
	begin
		add_data1=signed'(input_data1)+signed'(input_data2);
		add_data2=signed'(input_data3)+signed'(input_data4);
		add_data3=signed'(input_data5)+signed'(input_data6);
		add_data4=signed'(input_data7)+signed'(input_data8);
		add_data5=signed'(add_data1)+signed'(add_data2);
		add_data6=signed'(add_data3)+signed'(add_data4);
		
		add_data7=signed'(input_data9)+bias;
		add_data8=signed'(add_data5)+signed'(add_data6);
		
		output_data=signed'(add_data8)+signed'(add_data7);
	end
	
	
	
	endmodule
	
	
	
	
	