`timescale 1ns/10ps
module channel8_tree_adder(
	//clk,
	//rst,
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
	//input clk;
	//input rst;
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
	logic signed  [15:0] add_data9;
	always_comb
	begin
		
		add_data1=signed'(input_data1)+signed'(input_data2);
		add_data2=signed'(input_data3)+signed'(input_data4);
		add_data3=signed'(input_data5)+signed'(input_data6);
		add_data4=signed'(input_data7)+signed'(input_data8);
		add_data7=signed'(input_data9)+bias;
		add_data5=add_data1+add_data2;
		add_data6=add_data3+add_data4;
		add_data8=add_data5+add_data6;
		add_data9=add_data7+add_data8;
		
		output_data=add_data9[15]?16'd0:add_data9;
	end
	endmodule
	
	
	
	
	