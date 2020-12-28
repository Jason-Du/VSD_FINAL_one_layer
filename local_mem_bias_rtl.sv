module local_bias(
	clk,
	rst,
	read_bias_signal,
	bias_addr,
	write_bias_data,
	write_bias_signal,
	
	read_bias_data

);
localparam maximum_bias_num=10;

input clk;
input rst;
input read_bias_signal;
input write_bias_signal;
input [15:0]write_bias_data;
input [15:0]bias_addr;

output logic [31:0] read_bias_data;


logic [15:0]bias_mem_in [maximum_bias_num];
logic [15:0]bias_mem_out[maximum_bias_num];
always_ff@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		for(byte i=0;i<=maximum_bias_num-1;i++)
		begin
			bias_mem_out[i]<=16'd0;
		end
	end
	else
	begin
		for(byte i=0;i<=maximum_bias_num-1;i++)
		begin
			bias_mem_out[i]<=bias_mem_in[i];
		end
	end
end
//---------------------------------------------WRITE-----------------------------------------------------
always_comb
begin
	if(write_bias_signal)
	begin
		bias_mem_in[bias_addr]=write_bias_data;
	end
	else
	begin
		bias_mem_in[bias_addr]=bias_mem_out[bias_addr];
	end
end
//---------------------------------------------READ-----------------------------------------------------
always_comb
begin
	if(read_bias_signal)
	begin
		read_bias_data[ 15:0]=bias_mem_out[      2*bias_addr];
		read_bias_data[31:16]=bias_mem_out[2*bias_addr+16'd1];
	end
	else
	begin
		read_bias_data=48'd0;
	end
end
endmodule



