module layer7_local_mem_weight(
	clk,
	rst,
	read_weight_signal,
	read_weight_addr1,
	read_weight_addr2,
	
	write_weight_data,
	write_weight_signal,
	write_weight_addr,
	//IN OUT
	
	read_weight_data1,
	read_weight_data2
);
localparam maximum_weight_num=2000;//8010

input clk;
input rst;
input read_weight_signal;
input write_weight_signal;
input [15:0]write_weight_data;
input [15:0]read_weight_addr1;
input [15:0]read_weight_addr2;
input [15:0]write_weight_addr;

output logic [127:0] read_weight_data1;
output logic [127:0] read_weight_data2;


logic [15:0] output_addr1;
logic [15:0] output_addr2;
logic [15:0] output_addr3;
logic [15:0] output_addr4;
logic [15:0] output_addr5;
logic [15:0] output_addr6;
logic [15:0] output_addr7;
logic [15:0] output_addr8;
logic [15:0] output_data_shift;
logic [15:0] weight_mem_out [maximum_weight_num];
always_ff@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		for(int i=0;i<=maximum_weight_num-1;i++)
		begin
			weight_mem_out[i]<=128'd0;
		end
	end
	else
	begin
	//---------------------------------------------WRITE-----------------------------------------------------
		if(write_weight_signal)
		begin
			weight_mem_out[write_weight_addr]<=write_weight_data;
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
	if(read_weight_signal)
	begin
		output_data_shift=read_weight_addr1<<3;

		output_addr1=output_data_shift;
		output_addr2=output_data_shift+16'd1;
		output_addr3=output_data_shift+16'd2;
		output_addr4=output_data_shift+16'd3;
		output_addr5=output_data_shift+16'd4;
		output_addr6=output_data_shift+16'd5;
		output_addr7=output_data_shift+16'd6;
		output_addr8=output_data_shift+16'd7;
		
		read_weight_data1[   15:0]=weight_mem_out[output_addr1];
		read_weight_data1[  31:16]=weight_mem_out[output_addr2];
		read_weight_data1[  47:32]=weight_mem_out[output_addr3];
		read_weight_data1[  63:48]=weight_mem_out[output_addr4];
		read_weight_data1[  79:64]=weight_mem_out[output_addr5];
		read_weight_data1[  95:80]=weight_mem_out[output_addr6];
		read_weight_data1[ 111:96]=weight_mem_out[output_addr7];
		read_weight_data1[127:112]=weight_mem_out[output_addr8];
		
		read_weight_data2[   15:0]=weight_mem_out[output_addr1+16'd25];
		read_weight_data2[  31:16]=weight_mem_out[output_addr2+16'd25];
		read_weight_data2[  47:32]=weight_mem_out[output_addr3+16'd25];
		read_weight_data2[  63:48]=weight_mem_out[output_addr4+16'd25];
		read_weight_data2[  79:64]=weight_mem_out[output_addr5+16'd25];
		read_weight_data2[  95:80]=weight_mem_out[output_addr6+16'd25];
		read_weight_data2[ 111:96]=weight_mem_out[output_addr7+16'd25];
		read_weight_data2[127:112]=weight_mem_out[output_addr8+16'd25];
	end
	else
	begin
		read_weight_data1=128'd0;
		read_weight_data2=128'd0;
		output_data_shift=16'd0;
		output_addr1=16'd0;
		output_addr2=16'd0;
		output_addr3=16'd0;
		output_addr4=16'd0;
		output_addr5=16'd0;
		output_addr6=16'd0;
		output_addr7=16'd0;
		output_addr8=16'd0;
	end
end
endmodule


