`timescale 1ns/10ps
module local_mem_weight(
	clk,
	rst,
	read_weight_signal,
	read_weight_addr,
	buffer_num_sel,
	
	write_weight_data,
	write_weight_signal,
	write_weight_addr,
	//IN OUT
	
	read_weight_data

);
localparam maximum_weight_num=8010;

input clk;
input rst;
input read_weight_signal;
input write_weight_signal;
input [15:0]write_weight_data;
input [15:0]read_weight_addr;
input [15:0]write_weight_addr;
input [ 4:0]buffer_num_sel;

output logic [127:0] read_weight_data;


//logic [15:0]weight_mem_in[maximum_weight_num];
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
	//---------------------------------------------WRITE-----------------------------------------------------
		if(write_weight_signal)
		begin
			weight_mem_out[write_weight_addr]=write_weight_data;
		end
		else
		begin
			weight_mem_out<=weight_mem_out;
		end
	end
end

//---------------------------------------------READ-----------------------------------------------------
always_comb
begin
	if(read_weight_signal&&buffer_num_sel==5'd1)
	begin
		read_weight_data[  15:0]=weight_mem_out[      read_weight_addr<<1+read_weight_addr];
		read_weight_data[ 31:16]=weight_mem_out[read_weight_addr<<1+read_weight_addr+16'd1];
		read_weight_data[ 47:32]=weight_mem_out[read_weight_addr<<1+read_weight_addr+16'd2];
		read_weight_data[127:48]=80'd0;
	end
	else if(read_weight_signal&&buffer_num_sel==5'd2)
	begin
		read_weight_data[   15:0]=weight_mem_out[            read_weight_addr<<3];
		read_weight_data[  31:16]=weight_mem_out[      read_weight_addr<<3+16'd1];
		read_weight_data[  47:32]=weight_mem_out[      read_weight_addr<<3+16'd2];
		read_weight_data[  63:48]=weight_mem_out[      read_weight_addr<<3+16'd3];
		read_weight_data[  79:64]=weight_mem_out[      read_weight_addr<<3+16'd4];
		read_weight_data[  95:80]=weight_mem_out[      read_weight_addr<<3+16'd5];
		read_weight_data[ 111:96]=weight_mem_out[      read_weight_addr<<3+16'd6];
		read_weight_data[127:112]=weight_mem_out[      read_weight_addr<<3+16'd7];
	end
	else
	begin
		read_weight_data=128'd0;
	end
end
endmodule


