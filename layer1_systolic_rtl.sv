`timescale 1ns/10ps
module layer1_systolic(
	input_channel,
	
	output_channel1,
	output_channel2,
	output_channel3,
	output_channel4,
	output_channel5,
	output_channel6,
	output_channel7,
	output_channel8,
	weight1,
	weight2,
	weight3,
	weight4,
	weight5,
	weight6,
	weight7,
	weight8
);
	input         [47:0] input_channel;
	input         [47:0] weight1;
	input         [47:0] weight2;
	input         [47:0] weight3;
	input         [47:0] weight4;
	input         [47:0] weight5;
	input         [47:0] weight6;
	input         [47:0] weight7;
	input         [47:0] weight8;
	
	output signed [15:0] output_channel1;
	output signed [15:0] output_channel2;
	output signed [15:0] output_channel3;
	output signed [15:0] output_channel4;
	output signed [15:0] output_channel5;
	output signed [15:0] output_channel6;
	output signed [15:0] output_channel7;
	output signed [15:0] output_channel8;
	
	always_comb
	begin
		output_channel1=(signed'(weight1[47:32])*signed'(input_channel[47:32]))+(signed'(weight1[31:16])*signed'(input_channel[31:16]))+(signed'(weight1[15:0])*signed'(input_channel[15:0]));
		output_channel2=(signed'(weight2[47:32])*signed'(input_channel[47:32]))+(signed'(weight2[31:16])*signed'(input_channel[31:16]))+(signed'(weight2[15:0])*signed'(input_channel[15:0]));
		output_channel3=(signed'(weight3[47:32])*signed'(input_channel[47:32]))+(signed'(weight3[31:16])*signed'(input_channel[31:16]))+(signed'(weight3[15:0])*signed'(input_channel[15:0]));
		output_channel4=(signed'(weight4[47:32])*signed'(input_channel[47:32]))+(signed'(weight4[31:16])*signed'(input_channel[31:16]))+(signed'(weight4[15:0])*signed'(input_channel[15:0]));
		output_channel5=(signed'(weight5[47:32])*signed'(input_channel[47:32]))+(signed'(weight5[31:16])*signed'(input_channel[31:16]))+(signed'(weight5[15:0])*signed'(input_channel[15:0]));
		output_channel6=(signed'(weight6[47:32])*signed'(input_channel[47:32]))+(signed'(weight6[31:16])*signed'(input_channel[31:16]))+(signed'(weight6[15:0])*signed'(input_channel[15:0]));
		output_channel7=(signed'(weight7[47:32])*signed'(input_channel[47:32]))+(signed'(weight7[31:16])*signed'(input_channel[31:16]))+(signed'(weight7[15:0])*signed'(input_channel[15:0]));
		output_channel8=(signed'(weight8[47:32])*signed'(input_channel[47:32]))+(signed'(weight8[31:16])*signed'(input_channel[31:16]))+(signed'(weight8[15:0])*signed'(input_channel[15:0]));
	end
	
endmodule










