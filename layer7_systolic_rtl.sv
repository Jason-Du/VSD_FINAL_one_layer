`timescale 1ns/10ps
`include "def.svh"
module layer7_systolic(
	clk,
	rst,
	input_data,
	weight_data,
	bias_data,
	systolic_adder_control,
	
	result_data_out
);
	input         clk;
	input         rst;
	input [127:0] input_data;
	input [127:0] weight_data;
	input [ 15:0] bias_data;
	input         systolic_adder_control;
	
	output logic [15:0] result_data_out;
	
	logic signed [31:0] multiplication_result1;
	logic signed [31:0] multiplication_result2;
	logic signed [31:0] multiplication_result3;
	logic signed [31:0] multiplication_result4;
	logic signed [31:0] multiplication_result5;
	logic signed [31:0] multiplication_result6;
	logic signed [31:0] multiplication_result7;
	logic signed [31:0] multiplication_result8;
	
	logic signed  [15:0] add_data1;
	logic signed  [15:0] add_data2;
	logic signed  [15:0] add_data3;
	logic signed  [15:0] add_data4;
	logic signed  [15:0] add_data5;
	logic signed  [15:0] add_data6;
	logic signed  [15:0] add_data7;
	
	logic signed  [15:0] data_before_bias_register_in;
	logic signed  [15:0] data_before_bias_register_out;
	logic [15:0] test1;
	logic [15:0] test2;
	logic [15:0] test3;
	logic [15:0] test4;
	logic [15:0] test5;
	logic [15:0] test6;
	logic [15:0] test7;
	logic [15:0] test8;

	
	always_comb
	begin

		
		multiplication_result1=signed'(input_data[ 15:0])*signed'(weight_data[15:0]);
		multiplication_result2=signed'(input_data[31:16])*signed'(weight_data[31:16]);
		multiplication_result3=signed'(input_data[47:32])*signed'(weight_data[47:32]);
		multiplication_result4=signed'(input_data[63:48])*signed'(weight_data[63:48]);
		multiplication_result5=signed'(input_data[79:64])*signed'(weight_data[79:64]);
		multiplication_result6=signed'(input_data[95:80])*signed'(weight_data[95:80]);
		multiplication_result7=signed'(input_data[111:96])*signed'(weight_data[111:96]);
		multiplication_result8=signed'(input_data[127:112])*signed'(weight_data[127:112]);
		
		test1=multiplication_result1[25:10];
		test2=multiplication_result2[25:10];
		test3=multiplication_result3[25:10];
		test4=multiplication_result4[25:10];
		test5=multiplication_result5[25:10];
		test6=multiplication_result6[25:10];
		test7=multiplication_result7[25:10];
		test8=multiplication_result8[25:10];
		

		add_data1=signed'(multiplication_result1[25:10])+signed'(multiplication_result2[25:10]);
		add_data2=signed'(multiplication_result3[25:10])+signed'(multiplication_result4[25:10]);
		add_data3=signed'(multiplication_result5[25:10])+signed'(multiplication_result6[25:10]);
		add_data4=signed'(multiplication_result7[25:10])+signed'(multiplication_result8[25:10]);
		add_data5=signed'(add_data1)+signed'(add_data2);
		add_data6=signed'(add_data3)+signed'(add_data4);
		add_data7=signed'(add_data5)+signed'(add_data6);
		data_before_bias_register_in=systolic_adder_control?signed'(add_data7)+signed'(data_before_bias_register_out):signed'(add_data7);
		
		result_data_out=signed'(data_before_bias_register_out)+signed'(bias_data);
	end
	
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			data_before_bias_register_out<=16'd0;
		end
		else
		begin
			data_before_bias_register_out<=data_before_bias_register_in;
		end
	end
	endmodule
	
	
	
	
	
	