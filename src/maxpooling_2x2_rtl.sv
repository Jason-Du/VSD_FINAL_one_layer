`timescale 1ns/10ps

module maxpooling_2x2(
	input_channel1,
	input_channel2,
	input_channel3,
	input_channel4,
	
	output_channel
);

	input [15:0] input_channel1;
	input [15:0] input_channel2;
	input [15:0] input_channel3;
	input [15:0] input_channel4;
	
	output logic [15:0] output_channel;
	
	logic [15:0] stage1_compare1;
	logic [15:0] stage1_compare2;
	always_comb
	begin
		stage1_compare1=(input_channel1>=input_channel2)?input_channel1:input_channel2;
		stage1_compare2=(input_channel3>=input_channel4)?input_channel3:input_channel4;
		output_channel=(stage1_compare1>=stage1_compare2)?stage1_compare1:stage1_compare2;
	end
endmodule