module local_mem_weight(
	clk,
	rst,
	read_weight_signal,
	weight_addr,
	write_weight_data,
	write_weight_signal,
	
	read_weight_data

);
localparam maximum_weight_num=8010;

input clk;
input rst;
input read_weight_signal;
input write_weight_signal;
input [15:0]write_weight_data;
input [15:0]weight_addr;

output logic [47:0] read_weight_data;


logic [15:0]weight_mem_in[maximum_weight_num];
logic [15:0]weight_mem_out[maximum_weight_num];
always_ff@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		for(byte i=0;i<=maximum_weight_num-1;i++)
		begin
			weight_mem_out[i]<=16'd0;
		end
	end
	else
	begin
		for(byte i=0;i<=maximum_weight_num-1;i++)
		begin
			weight_mem_out[i]<=weight_mem_in[i];
		end
	end
end
//---------------------------------------------WRITE-----------------------------------------------------
always_comb
begin
	if(write_weight_signal)
	begin
		weight_mem_in[weight_addr]=write_weight_data;
	end
	else
	begin
		weight_mem_in[weight_addr]=weight_mem_out[weight_addr];
	end
end
//---------------------------------------------READ-----------------------------------------------------
always_comb
begin
	if(read_weight_signal)
	begin
		read_weight_data[ 15:0]=weight_mem_out[      3*weight_addr];
		read_weight_data[31:16]=weight_mem_out[3*weight_addr+16'd1];
		read_weight_data[47:32]=weight_mem_out[3*weight_addr+16'd2];
	end
	else
	begin
		read_weight_data=48'd0;
	end
end
endmodule


