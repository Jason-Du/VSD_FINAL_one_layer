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
	logic [79:0]pipeline_add_data_register_out1;
	logic [79:0]pipeline_add_data_register_in1;
	logic [63:0]pipeline_add_data_register_out2;
	logic [31:0]pipeline_add_data_register_out3;
	always_comb
	begin
		
		add_data1=signed'(input_data1)+signed'(input_data2);
		add_data2=signed'(input_data3)+signed'(input_data4);
		add_data3=signed'(input_data5)+signed'(input_data6);
		add_data4=signed'(input_data7)+signed'(input_data8);
		add_data7=signed'(input_data9)+bias;
		pipeline_add_data_register_in1={add_data7,add_data4,add_data3,add_data2,add_data1};
		add_data5=add_data1+add_data2;
		add_data6=add_data3+add_data4;
		add_data8=add_data5+add_data6;
		add_data9=add_data7+add_data8;
		
		/*
		add_data5=signed'(pipeline_add_data_register_out1[15:0])+signed'(pipeline_add_data_register_out1[31:16]);
		add_data6=signed'(pipeline_add_data_register_out1[47:32])+signed'(pipeline_add_data_register_out1[63:48]);
		add_data8=signed'(pipeline_add_data_register_out2[15:0])+signed'(pipeline_add_data_register_out2[31:16]);
		
		add_data9=signed'(pipeline_add_data_register_out3[31:16])+signed'(pipeline_add_data_register_out3[15:0]);
		*/
		output_data=add_data9[15]?16'd0:add_data9;
	end
	/*
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			pipeline_add_data_register_out1<=80'd0;
			pipeline_add_data_register_out2<=48'd0;
			pipeline_add_data_register_out3<=32'd0;
		end
		else
		begin
			pipeline_add_data_register_out1<=pipeline_add_data_register_in1;
			pipeline_add_data_register_out2<={pipeline_add_data_register_out1[79:64],add_data5,add_data6};
			pipeline_add_data_register_out3<={pipeline_add_data_register_out2[47:32],add_data8};
		end
		
	end
	
	*/
	endmodule
	
	
	
	
	