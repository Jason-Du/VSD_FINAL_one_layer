`timescale 1ns/10ps
module local_mem_pixel(
	clk,
	rst,
	read_pixel_addr,
	read_pixel_signal,
	
	
	write_pixel_data,
	write_pixel_addr,
	write_pixel_signal,
	
	read_pixel_data

);
localparam red_write_pixel_addr   =2'b00;
localparam green_write_pixel_addr =2'b01;
localparam blue_write_pixel_addr  =2'b10;

input clk;
input rst;
input read_pixel_signal;
input write_pixel_signal;
input [15:0]write_pixel_data;
input [15:0]read_pixel_addr;
input [15:0]write_pixel_addr;

output logic [47:0] read_pixel_data;

logic [2:0][15:0]pixel_mem_in[32][32];
logic [2:0][15:0]pixel_mem_out[32][32];
logic [5:0] write_row;
logic [5:0] write_col;
logic [5:0] read_row;
logic [5:0] read_col;
always_ff@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		for(byte i=0;i<=31;i++)
		begin
			for(byte j=0;j<=31;j++)
			begin
				pixel_mem_out[i][j]<=48'd0;
			end
		end
	end
	else
	begin
		if(write_pixel_signal)
		begin
			pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][write_pixel_addr[11:10]]=write_pixel_data;
		end
		else
		begin
			for(byte i=0;i<=31;i++)
			begin
				for(byte j=0;j<=31;j++)
				begin
					pixel_mem_out[i][j]<=pixel_mem_out[i][j];
				end
			end
		end
	end
end
always_comb
begin
	write_col=write_pixel_addr[4:0];
	write_row=write_pixel_addr[9:5];
	read_row=read_pixel_addr[9:5];
	read_col=read_pixel_addr[4:0];
end
//---------------------------------------------WRITE-----------------------------------------------------
/*
always_comb
begin
	if(write_pixel_signal)
	begin
		case(write_pixel_addr[11:10])
			red_write_pixel_addr:
			begin
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][0]=write_pixel_data;
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][1]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][1];
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][2]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][2];
			end
			green_write_pixel_addr:
			begin
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][0]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][0];
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][1]=write_pixel_data;
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][2]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][2];
			end
			blue_write_pixel_addr:
			begin
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][0]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][0];
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][1]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][1];
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][2]=write_pixel_data;
			end
			default
			begin
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][0]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][0];
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][1]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][1];
				pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][2]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][2];
			end
		endcase
	end
	else
	begin
		pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][0]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][0];
		pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][1]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][1];
		pixel_mem_in[write_pixel_addr[9:5]][write_pixel_addr[4:0]][2]=pixel_mem_out[write_pixel_addr[9:5]][write_pixel_addr[4:0]][2];
	end
end
*/
//---------------------------------------------READ-----------------------------------------------------
always_comb
begin
	if(read_pixel_signal)
	begin
		read_pixel_data[ 15:0]=pixel_mem_out[read_pixel_addr[9:5]][read_pixel_addr[4:0]][0];
		read_pixel_data[31:16]=pixel_mem_out[read_pixel_addr[9:5]][read_pixel_addr[4:0]][1];
		read_pixel_data[47:32]=pixel_mem_out[read_pixel_addr[9:5]][read_pixel_addr[4:0]][2];
	end
	else
	begin
		read_pixel_data=48'd0;
	end
end
endmodule


