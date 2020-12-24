module local_mem_pixel(
	clk,
	rst,
	read_pixel_signal,
	pixel_addr,
	write_pixel_data,
	write_pixel_signal,
	
	read_pixel_data

);
localparam red_pixel_addr   =2'b00;
localparam green_pixel_addr =2'b01;
localparam blue_pixel_addr  =2'b10;

input clk;
input rst;
input read_pixel_signal;
input write_pixel_signal;
input [16:0]write_pixel_data;
input [11:0]pixel_addr;

output logic [47:0] read_pixel_data;

logic [2:0][15:0]pixel_mem_in[32][32];
logic [2:0][15:0]pixel_mem_out[32][32];
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
		for(byte i=0;i<=31;i++)
		begin
			for(byte j=0;j<=31;j++)
			begin
				pixel_mem_out[i][j]<=pixel_mem_in[i][j];
			end
		end
	end
end
//---------------------------------------------WRITE-----------------------------------------------------
always_comb
begin
	if(write_pixel_signal)
	begin
		case(pixel_addr[11:10])
			red_pixel_addr:
			begin
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][0]=write_pixel_data;
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][1]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][1];
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][2]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][2];
			end
			green_pixel_addr:
			begin
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][0]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][0];
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][1]=write_pixel_data;
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][2]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][2];
			end
			blue_pixel_addr:
			begin
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][0]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][0];
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][1]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][1];
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][2]=write_pixel_data;
			end
			default
			begin
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][0]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][0];
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][1]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][1];
				pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][2]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][2];
			end
		endcase
	end
	else
	begin
		pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][0]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][0];
		pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][1]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][1];
		pixel_mem_in[pixel_addr[9:5]][pixel_addr[4:0]][2]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][2];
	end
end
//---------------------------------------------READ-----------------------------------------------------
always_comb
begin
	if(read_pixel_signal)
	begin
		read_pixel_data[ 15:0]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][0];
		read_pixel_data[31:16]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][1];
		read_pixel_data[47:32]=pixel_mem_out[pixel_addr[9:5]][pixel_addr[4:0]][2];
	end
	else
	begin
		read_pixel_data=48'd0;
	end
end
endmodule


