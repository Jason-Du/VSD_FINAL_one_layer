`timescale 1ns/10ps
`include "counter_cnn_rtl.sv"
module local_mem_weight(
	clk,
	rst,
	read_weight_signal,
	read_weight_addr1,
	read_weight_addr2,
	buffer_num_sel,
	
	
	write_weight_data,
	write_weight_signal,
	layer7_read_weight_signal,
	write_weight_addr,
	weight_fsm_cs,
	weight_store_done,
	//IN OUT
	
	read_weight_data1,
	read_weight_data2

);
localparam maximum_weight_num=1000;//8010
localparam WEIGHT_IDLE                    =4'b0000;
localparam WEIGHT_LAYER1_STORE            =4'b0001;
localparam WEIGHT_LAYER2_STORE            =4'b0010;
localparam WEIGHT_LAYER4_STORE            =4'b0011;
localparam WEIGHT_LAYER5_STORE            =4'b0100;
localparam WEIGHT_LAYER7_STORE            =4'b0101;
localparam WEIGHT_FINISH                  =4'b1111;
input clk;
input rst;
input read_weight_signal;
input layer7_read_weight_signal;
input write_weight_signal;
input [15:0]write_weight_data;
input [15:0]read_weight_addr1;
input [15:0]read_weight_addr2;
input [15:0]write_weight_addr;
input [ 4:0]buffer_num_sel;
input [ 3:0]weight_fsm_cs;
input weight_store_done;

output logic [127:0] read_weight_data1;
output logic [127:0] read_weight_data2;

logic [1:0] weight_channel3_state;
logic [2:0] weight_channel8_state;
logic [1:0] weight_channel3_state_ns;
logic [2:0] weight_channel8_state_ns;
localparam STATE_R=2'b00;
localparam STATE_G=2'b01;
localparam STATE_B=2'b10;
localparam STATE_1=3'b000;
localparam STATE_2=3'b001;
localparam STATE_3=3'b010;
localparam STATE_4=3'b011;
localparam STATE_5=3'b100;
localparam STATE_6=3'b101;
localparam STATE_7=3'b110;
localparam STATE_8=3'b111;
logic read_enable2;
logic read_enable1;
logic [6:0] addrA_sram;
logic [6:0] addrB_sram;

logic [15:0] write_addr;
logic        write_addr_clear;
logic        write_addr_keep;
logic [ 7:0] write_web;
logic [127:0] write_data;
logic weight_store_done_register_out;

/*
counter_cnn weight_channel_count(
	.clk(clk),
	.rst(rst),
	.count(write_addr),
	.clear(write_addr_clear),
	.keep(write_addr_keep)
);


always_ff@(posedge clk or rst)
begin
	if(rst)
	begin		
		weight_channel3_state=STATE_R;
		weight_channel8_state=STATE_1;
		weight_store_done_register_out=1'b0;
	end
	else
	begin
		weight_channel3_state=weight_channel3_state_ns;
		weight_channel8_state=weight_channel8_state_ns;
		 weight_store_done_register_out=weight_store_done;
	end
end


always_comb
begin
	read_enable2=read_weight_signal?1'b1:1'b0;
	read_enable1=layer7_read_weight_signal?1'b1:1'b0;
	
	addrA_sram=write_weight_signal?write_addr[6:0]:read_weight_addr2[6:0];//WRITE PORT
	addrB_sram=(read_weight_addr1[6:0]==7'd72)?7'd0:read_weight_addr1[6:0];//READ_PORT
	write_addr_clear=weight_store_done_register_out?1'b1:1'b0;
	if(write_weight_signal)
	begin
		if (weight_fsm_cs==WEIGHT_LAYER1_STORE||weight_fsm_cs==WEIGHT_IDLE)
		begin
			case(weight_channel3_state)
				STATE_R:
				begin
					write_data={112'd0,write_weight_data};
					write_web=8'b11111110;
					weight_channel3_state_ns=STATE_G;
					write_addr_keep=1'b1;
				end
				STATE_G:
				begin
					write_data={96'd0,write_weight_data,16'd0};
					write_web=8'b11111101;
					weight_channel3_state_ns=STATE_B;
					write_addr_keep=1'b1;
				end
				STATE_B:
				begin
					write_data={80'd0,write_weight_data,32'd0};
					write_web=8'b11111011;
					weight_channel3_state_ns=STATE_R;
					write_addr_keep=1'b0;
				end
				default:
				begin
					write_data=128'd0;
					write_web=8'b11111111;
					weight_channel3_state_ns=STATE_R;
					write_addr_keep=1'b1;
				end
			endcase
		end
		else
		begin
			case(weight_channel8_state)
				STATE_1:
				begin
					write_data={112'd0,write_weight_data};
					write_web=8'b11111110;
					weight_channel8_state_ns=STATE_2;
					write_addr_keep=1'b1;
				end
				STATE_2:
				begin
					write_data={96'd0,write_weight_data,16'd0};
					write_web=8'b11111101;
					weight_channel8_state_ns=STATE_3;
					write_addr_keep=1'b1;
				end
				STATE_3:
				begin
					write_data={80'd0,write_weight_data,32'd0};
					write_web=8'b11111011;
					weight_channel8_state_ns=STATE_4;
					write_addr_keep=1'b1;
				end	
				STATE_4:
				begin
					write_data={64'd0,write_weight_data,48'd0};
					write_web=8'b11110111;
					weight_channel8_state_ns=STATE_5;
					write_addr_keep=1'b1;
				end
				STATE_5:
				begin
					write_data={48'd0,write_weight_data,64'd0};
					write_web=8'b11101111;
					weight_channel8_state_ns=STATE_6;
					write_addr_keep=1'b1;
				end
				STATE_6:
				begin
					write_data={32'd0,write_weight_data,80'd0};
					write_web=8'b11011111;
					weight_channel8_state_ns=STATE_7;
					write_addr_keep=1'b1;
				end
				STATE_7:
				begin
					write_data={16'd0,write_weight_data,96'd0};
					write_web=8'b10111111;
					weight_channel8_state_ns=STATE_8;
					write_addr_keep=1'b1;
				end
				STATE_8:
				begin
					write_data={write_weight_data,112'd0};
					write_web=8'b01111111;
					weight_channel8_state_ns=STATE_1;
					write_addr_keep=1'b0;
				end
			endcase
		end
	end
	else
	begin
		write_data=128'd0;
		write_web=8'b11111111;
		weight_channel3_state_ns=weight_channel3_state;
		weight_channel8_state_ns=weight_channel8_state;
		write_addr_keep=1'b1;
	end
end

word72_wrapper weight_st(
  .CK(~clk),
  .OEA(read_enable1),
  .OEB(read_enable2),
  .WEAN(write_web),
  .WEBN(8'b11111111),
  .A(addrA_sram),
  .B(addrA_sram),
  .DOA(read_weight_data2),
  .DOB(read_weight_data1),
  .DIA(),
  .DIB(128'd0)
);
*/

logic [15:0] output_addr1;
logic [15:0] output_addr2;
logic [15:0] output_addr3;
logic [15:0] output_addr4;
logic [15:0] output_addr5;
logic [15:0] output_addr6;
logic [15:0] output_addr7;
logic [15:0] output_addr8;
logic [15:0] output_data_shift;


//logic [15:0]weight_mem_in[maximum_weight_num];
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
	if(read_weight_signal&&buffer_num_sel==5'd1)
	begin
		output_data_shift=read_weight_addr1<<1;
		output_addr1=output_data_shift+read_weight_addr1;
		output_addr2=output_data_shift+read_weight_addr1+16'd1;
		output_addr3=output_data_shift+read_weight_addr1+16'd2;
		output_addr4=16'd0;
		output_addr5=16'd0;
		output_addr6=16'd0;
		output_addr7=16'd0;
		output_addr8=16'd0;
		read_weight_data1[  15:0]=weight_mem_out[output_addr1];
		read_weight_data1[ 31:16]=weight_mem_out[output_addr2];
		read_weight_data1[ 47:32]=weight_mem_out[output_addr3];
		read_weight_data1[127:48]=80'd0;
		read_weight_data2=128'd0;
	end
	else if(read_weight_signal&&(buffer_num_sel==5'd2||buffer_num_sel==5'd4||buffer_num_sel==5'd5))
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
		read_weight_data2=128'd0;
	end
	else if(buffer_num_sel==5'd7)
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
		
		read_weight_data2[   15:0]=weight_mem_out[output_addr1+16'd200];
		read_weight_data2[  31:16]=weight_mem_out[output_addr2+16'd200];
		read_weight_data2[  47:32]=weight_mem_out[output_addr3+16'd200];
		read_weight_data2[  63:48]=weight_mem_out[output_addr4+16'd200];
		read_weight_data2[  79:64]=weight_mem_out[output_addr5+16'd200];
		read_weight_data2[  95:80]=weight_mem_out[output_addr6+16'd200];
		read_weight_data2[ 111:96]=weight_mem_out[output_addr7+16'd200];
		read_weight_data2[127:112]=weight_mem_out[output_addr8+16'd200];
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


