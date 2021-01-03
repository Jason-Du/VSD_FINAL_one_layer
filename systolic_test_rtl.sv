`timescale 1ns/10ps
`include "layer1_systolic_rtl.sv"
module systolic_test(
	 testin,
	 weight_in1,
	 weight_in2,
	 weight_in3,
	 weight_in4,
	 weight_in5,
	 weight_in6,
	 weight_in7,
	 weight_in8,
	
	
	 systolic1_output1,
	 systolic1_output2,
	 systolic1_output3,
	 systolic1_output4,
	 systolic1_output5,
	 systolic1_output6,
	 systolic1_output7,
	 systolic1_output8
);

	input [47:0] testin;
	input [47:0] weight_in1;
	input [47:0] weight_in2;
	input [47:0] weight_in3;
	input [47:0] weight_in4;
	input [47:0] weight_in5;
	input [47:0] weight_in6;
	input [47:0] weight_in7;
	input [47:0] weight_in8;
	
	
	output logic signed [15:0] systolic1_output1;
	output logic signed [15:0] systolic1_output2;
	output logic signed [15:0] systolic1_output3;
	output logic signed [15:0] systolic1_output4;
	output logic signed [15:0] systolic1_output5;
	output logic signed [15:0] systolic1_output6;
	output logic signed [15:0] systolic1_output7;
	output logic signed [15:0] systolic1_output8;
	always_comb
	begin
	
		layer1_systolic array1(
		.input_channel(testin),
		
		.output_channel1(systolic1_output1),
		.output_channel2(systolic1_output2),
		.output_channel3(systolic1_output3),
		.output_channel4(systolic1_output4),
		.output_channel5(systolic1_output5),
		.output_channel6(systolic1_output6),
		.output_channel7(systolic1_output7),
		.output_channel8(systolic1_output8),
		
		.weight1(weight_in1),
		.weight2(weight_in2),
		.weight3(weight_in3),
		.weight4(weight_in4),
		.weight5(weight_in5),
		.weight6(weight_in6),
		.weight7(weight_in7),
		.weight8(weight_in8)
	);

	end
	
endmodule