`timescale 1ns/10ps
`include"def.svh"
module stage12_fifo(
	clk,
	rst,
	input_data,
	output_data
);
input               clk;
input               rst;
input        [`LAYER3_WEIGHT_INPUT_LENGTH-1:0] input_data;//127
output logic [`LAYER3_WEIGHT_INPUT_LENGTH-1:0] output_data;
logic        [`LAYER3_WEIGHT_INPUT_LENGTH-1:0] Reg_in  [12];
logic        [`LAYER3_WEIGHT_INPUT_LENGTH-1:0] Reg_out [12];
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(byte i=0;i<=11;i++)
			begin
				Reg_out[i]<=`LAYER3_WEIGHT_INPUT_LENGTH'd0;
				//$display("rst check");
				//$display(i);
			end
		end
		else
		begin
			for(byte i=0;i<=11;i++)
			begin
				Reg_out[i]<=Reg_in[i];
			end
		end
	end
	always_comb
	begin
		for(byte i=0;i<11;i++)
		begin
			Reg_in[i+1]=Reg_out[i];
		end
		output_data=Reg_out[11];
		Reg_in[0]=input_data;
	end
	
endmodule


