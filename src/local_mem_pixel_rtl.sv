`timescale 1ns/10ps
`include "pixel_wrapper.sv"
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


logic [	2:0] write_web;
logic [47:0] write_data_sram;
logic [47:0] null_wire;

logic [9:0] write_addr_sram;
logic [9:0] read_addr_sram;

always_comb
begin
	if(write_pixel_signal)
	case(write_pixel_addr[11:10])
		2'b00:
		begin
			write_web=3'b110;
			write_data_sram={32'd0,write_pixel_data};
		end
		2'b01:
		begin
			write_web=3'b101;
			write_data_sram={16'd0,write_pixel_data,16'd0};
		end
		2'b10:
		begin
			write_web=3'b011;
			write_data_sram={write_pixel_data,32'd0};
		end
		default:
		begin
			write_web=3'b111;
			write_data_sram=48'd0;
		end
	endcase
	else
	begin
		write_web=3'b111;
		write_data_sram=48'd0;
	end
	read_addr_sram=read_pixel_addr[9:0];
	write_addr_sram=write_pixel_addr[9:0];
end
pixel_wrapper pixel_st(
 .CK(clk),
 .OEA(1'b0),
 .OEB(read_pixel_signal),
 .WEAN(write_web),
 .WEBN(3'b111),
 .A(write_addr_sram),
 .B(read_addr_sram),
 .DOA(null_wire),
 .DOB(read_pixel_data),
 .DIA(write_data_sram),
 .DIB(48'd0)
);
/*
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
*/
endmodule


