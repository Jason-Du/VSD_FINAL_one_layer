`timescale 1ns/10ps
module stage28_fifo(
	clk,
	rst,
	input_data,
	output_data
);
input               clk;
input               rst;
input        [47:0] input_data;
output logic [47:0] output_data;
logic        [47:0] Reg_in  [29];
logic        [47:0] Reg_out [29];
	always_ff@(posedge clk)
	begin
		for(byte i=0;i<=28;i++)
		begin
			Reg_out[i]<=Reg_in[i];
		end
	end
	always_comb
	begin
		for(byte i=0;i<28;i++)
		begin
			Reg_in[i+1]=Reg_out[i];
		end
		output_data=Reg_out[28];
		Reg_in[0]=input_data;
	end
	
endmodule


