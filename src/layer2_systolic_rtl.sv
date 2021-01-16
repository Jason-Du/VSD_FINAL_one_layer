`timescale 1ns/10ps
`include"def.svh"
module layer2_systolic(
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
	input         [`LAYER2_WEIGHT_INPUT_LENGTH-1:0] input_channel;//127
	input         [`LAYER2_WEIGHT_INPUT_LENGTH-1:0] weight1;
	input         [`LAYER2_WEIGHT_INPUT_LENGTH-1:0] weight2;
	input         [`LAYER2_WEIGHT_INPUT_LENGTH-1:0] weight3;
	input         [`LAYER2_WEIGHT_INPUT_LENGTH-1:0] weight4;
	input         [`LAYER2_WEIGHT_INPUT_LENGTH-1:0] weight5;
	input         [`LAYER2_WEIGHT_INPUT_LENGTH-1:0] weight6;
	input         [`LAYER2_WEIGHT_INPUT_LENGTH-1:0] weight7;
	input         [`LAYER2_WEIGHT_INPUT_LENGTH-1:0] weight8;
	
	output logic signed [`WORDLENGTH-1:0] output_channel1;//16
	output logic signed [`WORDLENGTH-1:0] output_channel2;
	output logic signed [`WORDLENGTH-1:0] output_channel3;
	output logic signed [`WORDLENGTH-1:0] output_channel4;
	output logic signed [`WORDLENGTH-1:0] output_channel5;
	output logic signed [`WORDLENGTH-1:0] output_channel6;
	output logic signed [`WORDLENGTH-1:0] output_channel7;
	output logic signed [`WORDLENGTH-1:0] output_channel8;

	logic  signed       [31:0] channel1_data1;
	logic  signed       [31:0] channel1_data2;
	logic  signed       [31:0] channel1_data3;
	logic  signed       [31:0] channel1_data4;
	logic  signed       [31:0] channel1_data5;
	logic  signed       [31:0] channel1_data6;
	logic  signed       [31:0] channel1_data7;
	logic  signed       [31:0] channel1_data8;
		/*
	logic  signed       [31:0] channel1_tree1;
	logic  signed       [31:0] channel1_tree2;
	logic  signed       [31:0] channel1_tree3;
	logic  signed       [31:0] channel1_tree4;
	logic  signed       [31:0] channel1_tree5;
	logic  signed       [31:0] channel1_tree6;
	logic  signed       [31:0] channel1_tree7;
	*/
	
	logic  signed       [31:0] channel2_data1;
	logic  signed       [31:0] channel2_data2;
	logic  signed       [31:0] channel2_data3;
	logic  signed       [31:0] channel2_data4;
	logic  signed       [31:0] channel2_data5;
	logic  signed       [31:0] channel2_data6;
	logic  signed       [31:0] channel2_data7;
	logic  signed       [31:0] channel2_data8;
	
	logic  signed       [31:0] channel3_data1;
	logic  signed       [31:0] channel3_data2;
	logic  signed       [31:0] channel3_data3;
	logic  signed       [31:0] channel3_data4;
	logic  signed       [31:0] channel3_data5;
	logic  signed       [31:0] channel3_data6;
	logic  signed       [31:0] channel3_data7;
	logic  signed       [31:0] channel3_data8;
	
	logic  signed       [31:0] channel4_data1;
	logic  signed       [31:0] channel4_data2;
	logic  signed       [31:0] channel4_data3;
	logic  signed       [31:0] channel4_data4;
	logic  signed       [31:0] channel4_data5;
	logic  signed       [31:0] channel4_data6;
	logic  signed       [31:0] channel4_data7;
	logic  signed       [31:0] channel4_data8;
	
	logic  signed       [31:0] channel5_data1;
	logic  signed       [31:0] channel5_data2;
	logic  signed       [31:0] channel5_data3;
	logic  signed       [31:0] channel5_data4;
	logic  signed       [31:0] channel5_data5;
	logic  signed       [31:0] channel5_data6;
	logic  signed       [31:0] channel5_data7;
	logic  signed       [31:0] channel5_data8;
	
	logic  signed       [31:0] channel6_data1;
	logic  signed       [31:0] channel6_data2;
	logic  signed       [31:0] channel6_data3;
	logic  signed       [31:0] channel6_data4;
	logic  signed       [31:0] channel6_data5;
	logic  signed       [31:0] channel6_data6;
	logic  signed       [31:0] channel6_data7;
	logic  signed       [31:0] channel6_data8;
	
	logic  signed       [31:0] channel7_data1;
	logic  signed       [31:0] channel7_data2;
	logic  signed       [31:0] channel7_data3;
	logic  signed       [31:0] channel7_data4;
	logic  signed       [31:0] channel7_data5;
	logic  signed       [31:0] channel7_data6;
	logic  signed       [31:0] channel7_data7;
	logic  signed       [31:0] channel7_data8;
	
	logic  signed       [31:0] channel8_data1;
	logic  signed       [31:0] channel8_data2;
	logic  signed       [31:0] channel8_data3;
	logic  signed       [31:0] channel8_data4;
	logic  signed       [31:0] channel8_data5;
	logic  signed       [31:0] channel8_data6;
	logic  signed       [31:0] channel8_data7;
	logic  signed       [31:0] channel8_data8;
	
	
	
	
	
	logic  signed       [15:0] channel1_add1;
	logic  signed       [15:0] channel1_add2;
	logic  signed       [15:0] channel1_add3;
	logic  signed       [15:0] channel1_add4;
	logic  signed       [15:0] channel1_add1_1;
	logic  signed       [15:0] channel1_add1_2;
	
	logic  signed       [15:0] channel2_add1;
	logic  signed       [15:0] channel2_add2;
	logic  signed       [15:0] channel2_add3;
	logic  signed       [15:0] channel2_add4;
	logic  signed       [15:0] channel2_add1_1;
	logic  signed       [15:0] channel2_add1_2;
	
	logic  signed       [15:0] channel3_add1;
	logic  signed       [15:0] channel3_add2;
	logic  signed       [15:0] channel3_add3;
	logic  signed       [15:0] channel3_add4;
	logic  signed       [15:0] channel3_add1_1;
	logic  signed       [15:0] channel3_add1_2;
	
	logic  signed       [15:0] channel4_add1;
	logic  signed       [15:0] channel4_add2;
	logic  signed       [15:0] channel4_add3;
	logic  signed       [15:0] channel4_add4;
	logic  signed       [15:0] channel4_add1_1;
	logic  signed       [15:0] channel4_add1_2;
	
	logic  signed       [15:0] channel5_add1;
	logic  signed       [15:0] channel5_add2;
	logic  signed       [15:0] channel5_add3;
	logic  signed       [15:0] channel5_add4;
	logic  signed       [15:0] channel5_add1_1;
	logic  signed       [15:0] channel5_add1_2;
	
	logic  signed       [15:0] channel6_add1;
	logic  signed       [15:0] channel6_add2;
	logic  signed       [15:0] channel6_add3;
	logic  signed       [15:0] channel6_add4;
	logic  signed       [15:0] channel6_add1_1;
	logic  signed       [15:0] channel6_add1_2;
	
	
	logic  signed       [15:0] channel7_add1;
	logic  signed       [15:0] channel7_add2;
	logic  signed       [15:0] channel7_add3;
	logic  signed       [15:0] channel7_add4;
	logic  signed       [15:0] channel7_add1_1;
	logic  signed       [15:0] channel7_add1_2;
	
	logic  signed       [15:0] channel8_add1;
	logic  signed       [15:0] channel8_add2;
	logic  signed       [15:0] channel8_add3;
	logic  signed       [15:0] channel8_add4;
	logic  signed       [15:0] channel8_add1_1;
	logic  signed       [15:0] channel8_add1_2;
	
	
	always_comb
	begin
	
		channel1_data1=(signed'(weight1[127:112])*signed'(input_channel[127:112]));
		channel1_data2=(signed'(weight1[111:96])*signed'(input_channel[111:96]));
		channel1_data3=(signed'(weight1[95:80])*signed'(input_channel[95:80]));
		channel1_data4=(signed'(weight1[79:64])*signed'(input_channel[79:64]));
		channel1_data5=(signed'(weight1[63:48])*signed'(input_channel[63:48]));
		channel1_data6=(signed'(weight1[47:32])*signed'(input_channel[47:32]));
		channel1_data7=(signed'(weight1[31:16])*signed'(input_channel[31:16]));
		channel1_data8=(signed'(weight1[15:0])*signed'(input_channel[15:0]));
		channel1_add1=signed'(channel1_data1[25:10])+signed'(channel1_data2[25:10]);
		channel1_add2=signed'(channel1_data3[25:10])+signed'(channel1_data4[25:10]);
		channel1_add3=signed'(channel1_data5[25:10])+signed'(channel1_data6[25:10]);
		channel1_add4=signed'(channel1_data7[25:10])+signed'(channel1_data8[25:10]);
		channel1_add1_1=channel1_add1+channel1_add2;
		channel1_add1_2=channel1_add3+channel1_add4;
		output_channel1=channel1_add1_1+channel1_add1_2;
		
		channel2_data1=(signed'(weight2[127:112])*signed'(input_channel[127:112]));
		channel2_data2=(signed'(weight2[111:96])*signed'(input_channel[111:96]));
		channel2_data3=(signed'(weight2[95:80])*signed'(input_channel[95:80]));
		channel2_data4=(signed'(weight2[79:64])*signed'(input_channel[79:64]));
		channel2_data5=(signed'(weight2[63:48])*signed'(input_channel[63:48]));
		channel2_data6=(signed'(weight2[47:32])*signed'(input_channel[47:32]));
		channel2_data7=(signed'(weight2[31:16])*signed'(input_channel[31:16]));
		channel2_data8=(signed'(weight2[15:0])*signed'(input_channel[15:0]));
		channel2_add1=signed'(channel2_data1[25:10])+signed'(channel2_data2[25:10]);
		channel2_add2=signed'(channel2_data3[25:10])+signed'(channel2_data4[25:10]);
		channel2_add3=signed'(channel2_data5[25:10])+signed'(channel2_data6[25:10]);
		channel2_add4=signed'(channel2_data7[25:10])+signed'(channel2_data8[25:10]);
		channel2_add1_1=channel2_add1+channel2_add2;
		channel2_add1_2=channel2_add3+channel2_add4;
		output_channel2=channel2_add1_1+channel2_add1_2;
		
		channel3_data1=(signed'(weight3[127:112])*signed'(input_channel[127:112]));
		channel3_data2=(signed'(weight3[111:96])*signed'(input_channel[111:96]));
		channel3_data3=(signed'(weight3[95:80])*signed'(input_channel[95:80]));
		channel3_data4=(signed'(weight3[79:64])*signed'(input_channel[79:64]));
		channel3_data5=(signed'(weight3[63:48])*signed'(input_channel[63:48]));
		channel3_data6=(signed'(weight3[47:32])*signed'(input_channel[47:32]));
		channel3_data7=(signed'(weight3[31:16])*signed'(input_channel[31:16]));
		channel3_data8=(signed'(weight3[15:0])*signed'(input_channel[15:0]));
		channel3_add1=signed'(channel3_data1[25:10])+signed'(channel3_data2[25:10]);
		channel3_add2=signed'(channel3_data3[25:10])+signed'(channel3_data4[25:10]);
		channel3_add3=signed'(channel3_data5[25:10])+signed'(channel3_data6[25:10]);
		channel3_add4=signed'(channel3_data7[25:10])+signed'(channel3_data8[25:10]);
		channel3_add1_1=channel3_add1+channel3_add2;
		channel3_add1_2=channel3_add3+channel3_add4;
		output_channel3=channel3_add1_1+channel3_add1_2;
		
		
		
		
		channel4_data1=(signed'(weight4[127:112])*signed'(input_channel[127:112]));
		channel4_data2=(signed'(weight4[111:96])*signed'(input_channel[111:96]));
		channel4_data3=(signed'(weight4[95:80])*signed'(input_channel[95:80]));
		channel4_data4=(signed'(weight4[79:64])*signed'(input_channel[79:64]));
		channel4_data5=(signed'(weight4[63:48])*signed'(input_channel[63:48]));
		channel4_data6=(signed'(weight4[47:32])*signed'(input_channel[47:32]));
		channel4_data7=(signed'(weight4[31:16])*signed'(input_channel[31:16]));
		channel4_data8=(signed'(weight4[15:0])*signed'(input_channel[15:0]));
		channel4_add1=signed'(channel4_data1[25:10])+signed'(channel4_data2[25:10]);
		channel4_add2=signed'(channel4_data3[25:10])+signed'(channel4_data4[25:10]);
		channel4_add3=signed'(channel4_data5[25:10])+signed'(channel4_data6[25:10]);
		channel4_add4=signed'(channel4_data7[25:10])+signed'(channel4_data8[25:10]);
		channel4_add1_1=channel4_add1+channel4_add2;
		channel4_add1_2=channel4_add3+channel4_add4;
		output_channel4=channel4_add1_1+channel4_add1_2;
		
		
		
		channel5_data1=(signed'(weight5[127:112])*signed'(input_channel[127:112]));
		channel5_data2=(signed'(weight5[111:96])*signed'(input_channel[111:96]));
		channel5_data3=(signed'(weight5[95:80])*signed'(input_channel[95:80]));
		channel5_data4=(signed'(weight5[79:64])*signed'(input_channel[79:64]));
		channel5_data5=(signed'(weight5[63:48])*signed'(input_channel[63:48]));
		channel5_data6=(signed'(weight5[47:32])*signed'(input_channel[47:32]));
		channel5_data7=(signed'(weight5[31:16])*signed'(input_channel[31:16]));
		channel5_data8=(signed'(weight5[15:0])*signed'(input_channel[15:0]));
		channel5_add1=signed'(channel5_data1[25:10])+signed'(channel5_data2[25:10]);
		channel5_add2=signed'(channel5_data3[25:10])+signed'(channel5_data4[25:10]);
		channel5_add3=signed'(channel5_data5[25:10])+signed'(channel5_data6[25:10]);
		channel5_add4=signed'(channel5_data7[25:10])+signed'(channel5_data8[25:10]);
		channel5_add1_1=channel5_add1+channel5_add2;
		channel5_add1_2=channel5_add3+channel5_add4;
		output_channel5=channel5_add1_1+channel5_add1_2;
		
		channel6_data1=(signed'(weight6[127:112])*signed'(input_channel[127:112]));
		channel6_data2=(signed'(weight6[111:96])*signed'(input_channel[111:96]));
		channel6_data3=(signed'(weight6[95:80])*signed'(input_channel[95:80]));
		channel6_data4=(signed'(weight6[79:64])*signed'(input_channel[79:64]));
		channel6_data5=(signed'(weight6[63:48])*signed'(input_channel[63:48]));
		channel6_data6=(signed'(weight6[47:32])*signed'(input_channel[47:32]));
		channel6_data7=(signed'(weight6[31:16])*signed'(input_channel[31:16]));
		channel6_data8=(signed'(weight6[15:0])*signed'(input_channel[15:0]));
		channel6_add1=signed'(channel6_data1[25:10])+signed'(channel6_data2[25:10]);
		channel6_add2=signed'(channel6_data3[25:10])+signed'(channel6_data4[25:10]);
		channel6_add3=signed'(channel6_data5[25:10])+signed'(channel6_data6[25:10]);
		channel6_add4=signed'(channel6_data7[25:10])+signed'(channel6_data8[25:10]);
		channel6_add1_1=channel6_add1+channel6_add2;
		channel6_add1_2=channel6_add3+channel6_add4;
		output_channel6=channel6_add1_1+channel6_add1_2;
		
		
		
		channel7_data1=(signed'(weight7[127:112])*signed'(input_channel[127:112]));
		channel7_data2=(signed'(weight7[111:96])*signed'(input_channel[111:96]));
		channel7_data3=(signed'(weight7[95:80])*signed'(input_channel[95:80]));
		channel7_data4=(signed'(weight7[79:64])*signed'(input_channel[79:64]));
		channel7_data5=(signed'(weight7[63:48])*signed'(input_channel[63:48]));
		channel7_data6=(signed'(weight7[47:32])*signed'(input_channel[47:32]));
		channel7_data7=(signed'(weight7[31:16])*signed'(input_channel[31:16]));
		channel7_data8=(signed'(weight7[15:0])*signed'(input_channel[15:0]));
		channel7_add1=signed'(channel7_data1[25:10])+signed'(channel7_data2[25:10]);
		channel7_add2=signed'(channel7_data3[25:10])+signed'(channel7_data4[25:10]);
		channel7_add3=signed'(channel7_data5[25:10])+signed'(channel7_data6[25:10]);
		channel7_add4=signed'(channel7_data7[25:10])+signed'(channel7_data8[25:10]);
		channel7_add1_1=channel7_add1+channel7_add2;
		channel7_add1_2=channel7_add3+channel7_add4;
		output_channel7=channel7_add1_1+channel7_add1_2;
		
		
		
		channel8_data1=(signed'(weight8[127:112])*signed'(input_channel[127:112]));
		channel8_data2=(signed'(weight8[111:96])*signed'(input_channel[111:96]));
		channel8_data3=(signed'(weight8[95:80])*signed'(input_channel[95:80]));
		channel8_data4=(signed'(weight8[79:64])*signed'(input_channel[79:64]));
		channel8_data5=(signed'(weight8[63:48])*signed'(input_channel[63:48]));
		channel8_data6=(signed'(weight8[47:32])*signed'(input_channel[47:32]));
		channel8_data7=(signed'(weight8[31:16])*signed'(input_channel[31:16]));
		channel8_data8=(signed'(weight8[15:0])*signed'(input_channel[15:0]));
		channel8_add1=signed'(channel8_data1[25:10])+signed'(channel8_data2[25:10]);
		channel8_add2=signed'(channel8_data3[25:10])+signed'(channel8_data4[25:10]);
		channel8_add3=signed'(channel8_data5[25:10])+signed'(channel8_data6[25:10]);
		channel8_add4=signed'(channel8_data7[25:10])+signed'(channel8_data8[25:10]);
		channel8_add1_1=channel8_add1+channel8_add2;
		channel8_add1_2=channel8_add3+channel8_add4;
		output_channel8=channel8_add1_1+channel8_add1_2;
		
		
	end
	
endmodule

/*
	logic  signed       [15:0] channel1_test1;
	logic  signed       [15:0] channel1_test2;
	logic  signed       [15:0] channel1_test3;
	
	logic signed        [15:0] channel2_test1;
	logic signed        [15:0] channel2_test2;
	logic signed        [15:0] channel2_test3;
	
	logic signed        [15:0] channel3_test1;
	logic signed        [15:0] channel3_test2;
	logic signed        [15:0] channel3_test3;
	
	logic signed        [15:0] channel4_test1;
	logic signed        [15:0] channel4_test2;
	logic signed        [15:0] channel4_test3;
	
	logic signed        [15:0] channel5_test1;
	logic signed        [15:0] channel5_test2;
	logic signed        [15:0] channel5_test3;
	
	logic signed        [15:0] channel6_test1;
	logic signed        [15:0] channel6_test2;
	logic signed        [15:0] channel6_test3;
	
	logic signed        [15:0] channel7_test1;
	logic signed        [15:0] channel7_test2;
	logic signed        [15:0] channel7_test3;
	
	logic signed        [15:0] channel8_test1;
	logic signed        [15:0] channel8_test2;
	logic signed        [15:0] channel8_test3;
	always_comb
	begin
		channel1_test1=channel1_data1[25:10];
		channel1_test2=channel1_data2[25:10];
		channel1_test3=channel1_data3[25:10];
		               
		channel2_test1=channel2_data1[25:10];
		channel2_test2=channel2_data2[25:10];
		channel2_test3=channel2_data3[25:10];
		               
		channel3_test1=channel3_data1[25:10];
		channel3_test2=channel3_data2[25:10];
		channel3_test3=channel3_data3[25:10];
		               
		channel4_test1=channel4_data1[25:10];
		channel4_test2=channel4_data2[25:10];
		channel4_test3=channel4_data3[25:10];
		               
		channel5_test1=channel5_data1[25:10];
		channel5_test2=channel5_data2[25:10];
		channel5_test3=channel5_data3[25:10];
		               
		channel6_test1=channel6_data1[25:10];
		channel6_test2=channel6_data2[25:10];
		channel6_test3=channel6_data3[25:10];
		               
		channel7_test1=channel7_data1[25:10];
		channel7_test2=channel7_data2[25:10];
		channel7_test3=channel7_data3[25:10];
		               
		channel8_test1=channel8_data1[25:10];
		channel8_test2=channel8_data2[25:10];
		channel8_test3=channel8_data3[25:10];
	end
*/








