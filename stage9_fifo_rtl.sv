`timescale 1ns/10ps
`include"def.svh"
module stage9_fifo(
	clk,
	rst,
	input_data,
	output_data
);
input               clk;
input               rst;
input        [`LAYER5_WEIGHT_INPUT_LENGTH-1:0] input_data;//127
output logic [`LAYER5_WEIGHT_INPUT_LENGTH-1:0] output_data;
logic        [`LAYER5_WEIGHT_INPUT_LENGTH-1:0] Reg_in  [`LAYER5_WIDTH-3];
logic        [`LAYER5_WEIGHT_INPUT_LENGTH-1:0] Reg_out [`LAYER5_WIDTH-3];
	always_ff@(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			for(int i=0;i<=`LAYER5_WIDTH-4;i++)
			begin
				Reg_out[i]<=`LAYER5_WEIGHT_INPUT_LENGTH'd0;
				//$display("rst check");
				//$display(i);
			end
		end
		else
		begin
			for(int i=0;i<=`LAYER5_WIDTH-4;i++)
			begin
				Reg_out[i]<=Reg_in[i];
			end
		end
	end
	always_comb
	begin
		for(int i=0;i<`LAYER5_WIDTH-4;i++)
		begin
			Reg_in[i+1]=Reg_out[i];
		end
		output_data=Reg_out[`LAYER5_WIDTH-4];
		Reg_in[0]=input_data;
	end
	
endmodule


