module 28stage_fifo
(
	clk,
	rst,
	input_data,
	output_data
);
input         clk;
input         rst;
input  [47:0] input_data;
output [47:0] output_data;

logic  [ 4:0][47:0] Reg_in   ;
logic  [ 4:0][47:0] Reg_out ;
	always_ff@(posedge clk)
	begin
		for(byte i=0;i<=27;i++)
		begin
			Reg_out[i]=Reg_in[i];
		end
	end
	always_comb
	begin
		for(byte i=0;i<27;i++)
			begin
				Reg_in[i+1]=Reg_out[i];
			end
		output_data=Reg_in[27];
	end
endmodule


