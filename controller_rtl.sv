`timescale 1ns/10ps
`include "def.svh"
`include "counter_cnn_rtl.sv"
module controller(
	clk,
	rst,
	//bus_write_signal,
	//bus_read_signal,
	
	image_set_register_data_output,
	wdata,
	wvalid,
//	araddr,
//	arvalid,
	awaddr,
	awvalid,
	
	//------------------------IN/OUT PORT
	layer1_input_store_done,
	layer1_weight_store_done,
	layer1_bias_store_done,
	
	
	
	layer2_weight_store_done,
	layer2_bias_store_done,
	
	layer4_weight_store_done,
	layer4_bias_store_done,
	
	layer5_weight_store_done,
	layer5_bias_store_done,
	
	
	layer7_weight_store_done,
	layer7_bias_store_done,
	
	//////////////////
	
	
	layer_weight_sel,
	layer_bias_sel,
	layer7_weight_mem_sel,
	
	image_set_register_data_in,
	image_set_register_write_signal,
	interrupt_register_data_in,
	interrupt_register_write_signal,
	
	
	//read_pixel_mem,
	write_pixel_mem,
	pixel_mem_addr,
	pixel_mem_data,
	
	//read_weight_mem,
	write_weight_mem,
	write_layer7_weight_mem,
	weight_mem_addr,
	weight_mem_data,
	
	
	//read_bias_mem,
	write_bias_mem,
	bias_mem_addr,
	bias_mem_data
);
/*
/ CNN
`define SLAVE6_ADDR_START 32'hd000_0000
`define SLAVE6_ADDR_END 32'hdfff_ffff


`define result_address             32'hd000_0000
`define image_set_register_ADDRESS 32'hd111_0000
`define interrupr_rsgister_ADDRESS 32'hd222_0000

`define local_weight_mem_ADDRESS_START 32'hd333_0000
`define local_weight_mem_ADDRESS_END 32'hd333_ffff


`define local_bias_mem_ADDRESS_START 32'hd444_0000
`define local_bias_mem_ADDRESS_END 32'hd444_ffff

`define local_pixel_mem_ADDRESS_START 32'hd555_0000
`define local_pixel_mem_ADDRESS_END  32'hd555_ffff
`endif

*/
localparam result_address             =32'hd000_0000;
localparam image_set_register_ADDRESS =32'hd111_0000;
localparam interrupr_rsgister_ADDRESS =32'hd222_0000;
localparam local_pixel_mem_ADDRESS    =16'hd555;
localparam local_weight_mem_ADDRESS   =16'hd333;
localparam local_bias_mem_ADDRESS     =16'hd444;
input               clk;
input               rst;
input        [31:0] awaddr;
input               awvalid;
//input        [31:0] araddr;
//input               arvalid;
input        [31:0] wdata;
input               wvalid;

//input               bus_read_signal;
//input               bus_write_signal;


input        [ 1:0] image_set_register_data_output;


output logic [ 1:0] image_set_register_data_in;
output logic        image_set_register_write_signal;
output logic        interrupt_register_data_in;
output logic        interrupt_register_write_signal;

//output logic        read_pixel_mem;
output logic        write_pixel_mem;
output logic [15:0] pixel_mem_addr;
output logic [15:0] pixel_mem_data;

//output logic        read_weight_mem;
output logic        write_weight_mem;
output logic        write_layer7_weight_mem;
output logic [15:0] weight_mem_addr;
output logic [15:0] weight_mem_data;

//output logic 	    read_bias_mem;
output logic     	write_bias_mem;
output logic [15:0]	bias_mem_addr;
output logic [15:0] bias_mem_data;

output logic	layer1_input_store_done;
output logic	layer1_weight_store_done;
output logic	layer1_bias_store_done;

output logic	layer2_weight_store_done;
output logic	layer2_bias_store_done;

output logic	layer4_weight_store_done;
output logic	layer4_bias_store_done;

output logic	layer5_weight_store_done;
output logic	layer5_bias_store_done;

output logic	layer7_weight_store_done;
output logic	layer7_bias_store_done;

output logic [4:0] 	layer_weight_sel;
output logic [4:0] 	layer_bias_sel;
output logic [2:0]  layer7_weight_mem_sel;

//----------------------------INTTERUPT RESET FROM CPU--------MEMORY MAPPING-------//
always_comb
begin
	if(awaddr==interrupr_rsgister_ADDRESS&&awvalid==1'b1)
	begin
		interrupt_register_write_signal=1'b1;
		interrupt_register_data_in=1'b0;
	end
	else
	begin
		interrupt_register_write_signal=1'b0;
		interrupt_register_data_in=1'b0;
	end
end
//-------------------------CPU READ DATA----------------------------------------//
//----------------------------TRANSSFER  DATA--MEMORY MAPPING------------//
always_comb
begin
	if(awaddr==image_set_register_ADDRESS&&awvalid==1'b1)
	begin
		image_set_register_write_signal=1'b1;
		image_set_register_data_in=wdata[1:0];
	end
	else if(image_set_register_data_output!=2'b00)
	begin
		image_set_register_write_signal=1'b1;
		image_set_register_data_in=2'b00;
	end
	else
	begin
		image_set_register_write_signal=1'b0;
		image_set_register_data_in=2'b00;
	end
end
//-----------------------WEIGHT  STOREING  SETTING ----------//
localparam WEIGHT_IDLE                    =4'b0000;
localparam WEIGHT_LAYER1_STORE            =4'b0001;
localparam WEIGHT_LAYER2_STORE            =4'b0010;
localparam WEIGHT_LAYER4_STORE            =4'b0011;
localparam WEIGHT_LAYER5_STORE            =4'b0100;
localparam WEIGHT_LAYER7_STORE            =4'b0101;
localparam WEIGHT_FINISH                  =4'b1111;

localparam LAYER1_WEIGHT_NUM              =16'd215;//9*8*3
localparam LAYER2_WEIGHT_NUM              =16'd575;//9*8*8
localparam LAYER4_WEIGHT_NUM              =16'd575;//9*8*8
localparam LAYER5_WEIGHT_NUM              =16'd575;
localparam LAYER7_WEIGHT_NUM              =16'd1999;
//localparam LAYER5_WEIGHT_NUM              =16'd576;//9*8*8

logic [ 3:0] weight_fsm_cs;
logic [ 3:0] weight_fsm_ns;
logic        weight_store_count_clear;
logic        weight_store_count_keep;
logic [15:0] weight_store_count_data;
always_ff@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		weight_fsm_cs<=4'b0000;
	end
	else
	begin
		weight_fsm_cs<=weight_fsm_ns;
	end
end
always_comb
begin
	case(weight_fsm_cs)
	WEIGHT_IDLE:
	begin
		weight_store_count_clear=1'b0;
		layer1_weight_store_done=1'b0;
		layer2_weight_store_done=1'b0;
		layer4_weight_store_done=1'b0;
		layer5_weight_store_done=1'b0;
		layer7_weight_store_done=1'b0;
		layer_weight_sel        =5'd0;
		write_layer7_weight_mem =1'b0;
		layer7_weight_mem_sel   =3'b0;
		if(wvalid&&awaddr[31:16]==local_weight_mem_ADDRESS)
		begin
			weight_store_count_keep=1'b0;
			write_weight_mem =1'b1;
			weight_mem_data  =wdata[15:0];
			weight_mem_addr  =weight_store_count_data;
			weight_fsm_ns=WEIGHT_LAYER1_STORE;
		end
		else
		begin
			weight_store_count_keep=1'b1;
			write_weight_mem =1'b0;
			weight_mem_data  =16'd0;
			weight_mem_addr  =16'd0;
			weight_fsm_ns=WEIGHT_IDLE;
		end
	end
	WEIGHT_LAYER1_STORE:
	begin
		layer2_weight_store_done=1'b0;
		layer4_weight_store_done=1'b0;
		layer5_weight_store_done=1'b0;
		layer7_weight_store_done=1'b0;
		write_layer7_weight_mem =1'b0;
		layer7_weight_mem_sel   =3'b0;
		if(wvalid&&awaddr[31:16]==local_weight_mem_ADDRESS)
		begin
			weight_store_count_keep=1'b0;
			write_weight_mem =1'b1;
			weight_mem_data  =wdata[15:0];
			weight_mem_addr  =weight_store_count_data;			
		end
		else
		begin
			weight_store_count_keep=1'b1;
			write_weight_mem =1'b0;
			weight_mem_data  =16'd0;
			weight_mem_addr  =16'd0;			
		end
		if(weight_store_count_data==LAYER1_WEIGHT_NUM&&wvalid)
		begin
			weight_store_count_clear=1'b1;
			layer1_weight_store_done=1'b1;
			weight_fsm_ns           =WEIGHT_LAYER2_STORE;
			layer_weight_sel         =5'd1;
		end
		else
		begin
			weight_store_count_clear=1'b0;
			layer1_weight_store_done=1'b0;
			weight_fsm_ns           =WEIGHT_LAYER1_STORE;
			layer_weight_sel         =5'd0;
		end
	end
	WEIGHT_LAYER2_STORE:
	begin
		layer1_weight_store_done=1'b0;
		layer4_weight_store_done=1'b0;
		layer5_weight_store_done=1'b0;
		layer7_weight_store_done=1'b0;
		write_layer7_weight_mem =1'b0;
		layer7_weight_mem_sel   =3'b0;
		if(wvalid&&awaddr[31:16]==local_weight_mem_ADDRESS)
		begin
			weight_store_count_keep=1'b0;
			write_weight_mem =1'b1;
			weight_mem_data  =wdata[15:0];
			weight_mem_addr  =weight_store_count_data;			
		end
		else
		begin
			weight_store_count_keep=1'b1;
			write_weight_mem =1'b0;
			weight_mem_data  =16'd0;
			weight_mem_addr  =16'd0;			
		end
		if(weight_store_count_data==LAYER2_WEIGHT_NUM&&wvalid)
		begin
			weight_store_count_clear=1'b1;
			layer2_weight_store_done=1'b1;
			weight_fsm_ns           =WEIGHT_LAYER4_STORE;
			layer_weight_sel         =5'd2;
		end
		else
		begin
			weight_store_count_clear=1'b0;
			layer2_weight_store_done=1'b0;
			weight_fsm_ns           =WEIGHT_LAYER2_STORE;
			layer_weight_sel         =5'd1;
		end
	end
	WEIGHT_LAYER4_STORE:
	begin
		layer1_weight_store_done=1'b0;
		layer2_weight_store_done=1'b0;
		layer5_weight_store_done=1'b0;
		layer7_weight_store_done=1'b0;
		write_layer7_weight_mem =1'b0;
		layer7_weight_mem_sel   =3'b0;
		if(wvalid&&awaddr[31:16]==local_weight_mem_ADDRESS)
		begin
			weight_store_count_keep=1'b0;
			write_weight_mem =1'b1;
			weight_mem_data  =wdata[15:0];
			weight_mem_addr  =weight_store_count_data;			
		end
		else
		begin
			weight_store_count_keep=1'b1;
			write_weight_mem =1'b0;
			weight_mem_data  =16'd0;
			weight_mem_addr  =16'd0;			
		end
		if(weight_store_count_data==LAYER4_WEIGHT_NUM&&wvalid)
		begin
			weight_store_count_clear=1'b1;
			layer4_weight_store_done=1'b1;
			weight_fsm_ns           =WEIGHT_LAYER5_STORE;
			layer_weight_sel         =5'd4;
		end
		else
		begin
			weight_store_count_clear=1'b0;
			layer4_weight_store_done=1'b0;
			weight_fsm_ns           =WEIGHT_LAYER4_STORE;
			layer_weight_sel         =5'd2;
		end
	end
	WEIGHT_LAYER5_STORE:
	begin
		layer1_weight_store_done=1'b0;
		layer2_weight_store_done=1'b0;
		layer4_weight_store_done=1'b0;
		layer7_weight_store_done=1'b0;
		write_layer7_weight_mem =1'b0;
		layer7_weight_mem_sel   =3'b0;
		if(wvalid&&awaddr[31:16]==local_weight_mem_ADDRESS)
		begin
			weight_store_count_keep=1'b0;
			write_weight_mem =1'b1;
			weight_mem_data  =wdata[15:0];
			weight_mem_addr  =weight_store_count_data;			
		end
		else
		begin
			weight_store_count_keep=1'b1;
			write_weight_mem =1'b0;
			weight_mem_data  =16'd0;
			weight_mem_addr  =16'd0;			
		end
		if(weight_store_count_data==LAYER5_WEIGHT_NUM&&wvalid)
		begin
			weight_store_count_clear=1'b1;
			layer5_weight_store_done=1'b1;
			weight_fsm_ns           =WEIGHT_LAYER7_STORE;
			layer_weight_sel         =5'd5;
		end
		else
		begin
			weight_store_count_clear=1'b0;
			layer5_weight_store_done=1'b0;
			weight_fsm_ns           =WEIGHT_LAYER5_STORE;
			layer_weight_sel         =5'd4;
		end
	end
	WEIGHT_LAYER7_STORE:
	begin
		layer1_weight_store_done=1'b0;
		layer2_weight_store_done=1'b0;
		layer4_weight_store_done=1'b0;
		layer5_weight_store_done=1'b0;
		write_weight_mem =1'b0;
		if(wvalid&&awaddr[31:16]==local_weight_mem_ADDRESS)
		begin
			weight_store_count_keep=1'b0;
			write_layer7_weight_mem =1'b1;
			weight_mem_data  =wdata[15:0];			
		end
		else
		begin
			weight_store_count_keep=1'b1;
			write_layer7_weight_mem=1'b0;
			weight_mem_data  =16'd0;		
		end
		
		if(weight_store_count_data<16'd400)
		begin
			layer7_weight_mem_sel=3'd1;
			weight_mem_addr      =weight_store_count_data;
		end
		else if(weight_store_count_data<16'd800)
		begin
			layer7_weight_mem_sel=3'd2;
			weight_mem_addr      =weight_store_count_data-16'd400;
		end
		else if(weight_store_count_data<16'd1200)
		begin
			layer7_weight_mem_sel=3'd3;
			weight_mem_addr      =weight_store_count_data-16'd800;
		end
		else if(weight_store_count_data<16'd1600)
		begin
			layer7_weight_mem_sel=3'd4;
			weight_mem_addr      =weight_store_count_data-16'd1200;
		end
		else
		begin
			layer7_weight_mem_sel=3'd5;
			weight_mem_addr      =weight_store_count_data-16'd1600;
		end
		
		if(weight_store_count_data==LAYER7_WEIGHT_NUM&&wvalid)
		begin
			weight_store_count_clear=1'b1;
			layer7_weight_store_done=1'b1;
			weight_fsm_ns           =WEIGHT_FINISH;
			layer_weight_sel         =5'd7;
		end
		else
		begin
			weight_store_count_clear=1'b0;
			layer7_weight_store_done=1'b0;
			weight_fsm_ns           =WEIGHT_LAYER7_STORE;
			layer_weight_sel         =5'd5;
		end
	end
	WEIGHT_FINISH:
	begin
		weight_fsm_ns           =WEIGHT_FINISH;
		weight_store_count_keep =1'b0;
		write_weight_mem        =1'b0;
		write_layer7_weight_mem =1'b0;
		weight_mem_data         =16'd0;
		weight_mem_addr         =16'd0;
		weight_store_count_clear=1'b1;
		layer1_weight_store_done=1'b0;
		layer2_weight_store_done=1'b0;
		layer4_weight_store_done=1'b0;
		layer5_weight_store_done=1'b0;
		layer7_weight_store_done=1'b0;
		layer_weight_sel        =5'd7;
		layer7_weight_mem_sel   =3'b0;
	end
	default:
	begin
		weight_fsm_ns           =WEIGHT_IDLE;
		weight_store_count_keep =1'b0;
		write_weight_mem        =1'b0;
		write_layer7_weight_mem =1'b0;
		weight_mem_data         =16'd0;
		weight_mem_addr         =16'd0;
		weight_store_count_clear=1'b1;
		layer1_weight_store_done=1'b0;
		layer2_weight_store_done=1'b0;
		layer4_weight_store_done=1'b0;
		layer5_weight_store_done=1'b0;
		layer7_weight_store_done=1'b0;
		layer_weight_sel        =5'd0;
		layer7_weight_mem_sel   =3'b0;
	end
	endcase
end

counter_cnn weight_store_counter(
	.clk(clk),
	.rst(rst),
	.count(weight_store_count_data),
	.keep(weight_store_count_keep),
	.clear(weight_store_count_clear)
);
//-----------------------BIAS STOREING----------//
localparam BIAS_IDLE                    =4'b0000;
localparam BIAS_LAYER1_STORE            =4'b0001;
localparam BIAS_LAYER2_STORE            =4'b0010;
localparam BIAS_LAYER4_STORE            =4'b0011;
localparam BIAS_LAYER5_STORE            =4'b0100;
localparam BIAS_LAYER7_STORE            =4'b0101;
localparam BIAS_FINISH                  =4'b1111;

localparam LAYER1_BIAS_NUM              =16'd7;
localparam LAYER2_BIAS_NUM              =16'd7;
localparam LAYER4_BIAS_NUM              =16'd7;
localparam LAYER5_BIAS_NUM              =16'd7;
localparam LAYER7_BIAS_NUM              =16'd9;

logic [ 3:0] bias_fsm_cs;
logic [ 3:0] bias_fsm_ns;
logic        bias_store_count_clear;
logic        bias_store_count_keep;
logic [15:0] bias_store_count_data;
always_ff@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		bias_fsm_cs<=4'b0000;
	end
	else
	begin
		bias_fsm_cs<=bias_fsm_ns;
	end
end
always_comb
begin
	case(bias_fsm_cs)
	BIAS_IDLE:
	begin
		bias_store_count_clear=1'b0;
		layer1_bias_store_done=1'b0;
		layer2_bias_store_done=1'b0;
		layer4_bias_store_done=1'b0;
		layer5_bias_store_done=1'b0;
		layer7_bias_store_done=1'b0;
		layer_bias_sel        =5'd0;
		if(wvalid&&awaddr[31:16]==local_bias_mem_ADDRESS)
		begin
			bias_store_count_keep=1'b0;
			write_bias_mem =1'b1;
			bias_mem_data  =wdata[15:0];
			bias_mem_addr  =bias_store_count_data;
			bias_fsm_ns=BIAS_LAYER1_STORE;
		end
		else
		begin
			bias_store_count_keep=1'b1;
			write_bias_mem =1'b0;
			bias_mem_data  =16'd0;
			bias_mem_addr  =16'd0;
			bias_fsm_ns=BIAS_IDLE;
		end
	end
	BIAS_LAYER1_STORE:
	begin
		layer2_bias_store_done=1'b0;
		layer4_bias_store_done=1'b0;
		layer5_bias_store_done=1'b0;
		layer7_bias_store_done=1'b0;
		if(wvalid&&awaddr[31:16]==local_bias_mem_ADDRESS)
		begin
			bias_store_count_keep=1'b0;
			write_bias_mem =1'b1;
			bias_mem_data  =wdata[15:0];
			bias_mem_addr  =bias_store_count_data;			
		end
		else
		begin
			bias_store_count_keep=1'b1;
			write_bias_mem =1'b0;
			bias_mem_data  =16'd0;
			bias_mem_addr  =16'd0;			
		end
		if(bias_store_count_data==LAYER1_BIAS_NUM&&wvalid)
		begin
			bias_store_count_clear=1'b1;
			layer1_bias_store_done=1'b1;
			bias_fsm_ns           =BIAS_LAYER2_STORE;
			layer_bias_sel         =5'd1;
			//NORMAL CASE SWITCH SETTING LAYER
		end
		else
		begin
			bias_store_count_clear=1'b0;
			layer1_bias_store_done=1'b0;
			bias_fsm_ns           =BIAS_LAYER1_STORE;
			layer_bias_sel         =5'd0;
		end
	end
	BIAS_LAYER2_STORE:
	begin
		layer1_bias_store_done=1'b0;
		layer4_bias_store_done=1'b0;
		layer5_bias_store_done=1'b0;
		layer7_bias_store_done=1'b0;
		if(wvalid&&awaddr[31:16]==local_bias_mem_ADDRESS)
		begin
			bias_store_count_keep=1'b0;
			write_bias_mem =1'b1;
			bias_mem_data  =wdata[15:0];
			bias_mem_addr  =bias_store_count_data;			
		end
		else
		begin
			bias_store_count_keep=1'b1;
			write_bias_mem =1'b0;
			bias_mem_data  =16'd0;
			bias_mem_addr  =16'd0;			
		end
		if(bias_store_count_data==LAYER2_BIAS_NUM&&wvalid)
		begin
			bias_store_count_clear=1'b1;
			layer2_bias_store_done=1'b1;
			bias_fsm_ns           =BIAS_LAYER4_STORE;
			layer_bias_sel         =5'd2;
			//NORMAL CASE SWITCH SETTING LAYER
		end
		else
		begin
			bias_store_count_clear=1'b0;
			layer2_bias_store_done=1'b0;
			bias_fsm_ns           =BIAS_LAYER2_STORE;
			layer_bias_sel         =5'd1;
		end
	end
	BIAS_LAYER4_STORE:
	begin
		layer1_bias_store_done=1'b0;
		layer2_bias_store_done=1'b0;
		layer5_bias_store_done=1'b0;
		layer7_bias_store_done=1'b0;
		if(wvalid&&awaddr[31:16]==local_bias_mem_ADDRESS)
		begin
			bias_store_count_keep=1'b0;
			write_bias_mem =1'b1;
			bias_mem_data  =wdata[15:0];
			bias_mem_addr  =bias_store_count_data;			
		end
		else
		begin
			bias_store_count_keep=1'b1;
			write_bias_mem =1'b0;
			bias_mem_data  =16'd0;
			bias_mem_addr  =16'd0;			
		end
		if(bias_store_count_data==LAYER4_BIAS_NUM&&wvalid)
		begin
			bias_store_count_clear=1'b1;
			layer4_bias_store_done=1'b1;
			bias_fsm_ns           =BIAS_LAYER5_STORE;
			layer_bias_sel         =5'd4;
			//NORMAL CASE SWITCH SETTING LAYER
		end
		else
		begin
			bias_store_count_clear=1'b0;
			layer4_bias_store_done=1'b0;
			bias_fsm_ns           =BIAS_LAYER4_STORE;
			layer_bias_sel         =5'd2;
		end
	end
	BIAS_LAYER5_STORE:
	begin
		layer1_bias_store_done=1'b0;
		layer2_bias_store_done=1'b0;
		layer4_bias_store_done=1'b0;
		layer7_bias_store_done=1'b0;
		if(wvalid&&awaddr[31:16]==local_bias_mem_ADDRESS)
		begin
			bias_store_count_keep=1'b0;
			write_bias_mem =1'b1;
			bias_mem_data  =wdata[15:0];
			bias_mem_addr  =bias_store_count_data;			
		end
		else
		begin
			bias_store_count_keep=1'b1;
			write_bias_mem =1'b0;
			bias_mem_data  =16'd0;
			bias_mem_addr  =16'd0;			
		end
		if(bias_store_count_data==LAYER5_BIAS_NUM&&wvalid)
		begin
			bias_store_count_clear=1'b1;
			layer5_bias_store_done=1'b1;
			bias_fsm_ns           =BIAS_LAYER7_STORE;
			layer_bias_sel         =5'd5;
			//NORMAL CASE SWITCH SETTING LAYER
		end
		else
		begin
			bias_store_count_clear=1'b0;
			layer5_bias_store_done=1'b0;
			bias_fsm_ns           =BIAS_LAYER5_STORE;
			layer_bias_sel         =5'd4;
		end
	end
	BIAS_LAYER7_STORE:
	begin
		layer1_bias_store_done=1'b0;
		layer2_bias_store_done=1'b0;
		layer4_bias_store_done=1'b0;
		layer5_bias_store_done=1'b0;
		if(wvalid&&awaddr[31:16]==local_bias_mem_ADDRESS)
		begin
			bias_store_count_keep=1'b0;
			write_bias_mem =1'b1;
			bias_mem_data  =wdata[15:0];
			bias_mem_addr  =bias_store_count_data;			
		end
		else
		begin
			bias_store_count_keep=1'b1;
			write_bias_mem =1'b0;
			bias_mem_data  =16'd0;
			bias_mem_addr  =16'd0;			
		end
		if(bias_store_count_data==LAYER7_BIAS_NUM&&wvalid)
		begin
			bias_store_count_clear=1'b1;
			layer7_bias_store_done=1'b1;
			bias_fsm_ns           =BIAS_FINISH;
			layer_bias_sel         =5'd7;
			//NORMAL CASE SWITCH SETTING LAYER
		end
		else
		begin
			bias_store_count_clear=1'b0;
			layer7_bias_store_done=1'b0;
			bias_fsm_ns           =BIAS_LAYER7_STORE;
			layer_bias_sel         =5'd5;
		end
	end
	BIAS_FINISH:
	begin
		bias_fsm_ns           =BIAS_FINISH;
		bias_store_count_keep =1'b0;
		write_bias_mem        =1'b0;
		bias_mem_data         =16'd0;
		bias_mem_addr         =16'd0;
		bias_store_count_clear=1'b1;
		layer1_bias_store_done=1'b0;
		layer2_bias_store_done=1'b0;
		layer4_bias_store_done=1'b0;
		layer5_bias_store_done=1'b0;
		layer7_bias_store_done=1'b0;
		layer_bias_sel        =5'd7;
	end
	default:
	begin
		bias_fsm_ns           =BIAS_IDLE;
		bias_store_count_keep =1'b0;
		write_bias_mem        =1'b0;
		bias_mem_data         =16'd0;
		bias_mem_addr         =16'd0;
		bias_store_count_clear=1'b1;
		layer1_bias_store_done=1'b0;
		layer2_bias_store_done=1'b0;
		layer4_bias_store_done=1'b0;
		layer5_bias_store_done=1'b0;
		layer7_bias_store_done=1'b0;
		layer_bias_sel        =5'd0;
	end
	endcase
end

counter_cnn bias_store_counter(
	.clk(clk),
	.rst(rst),
	.count(bias_store_count_data),
	.keep(bias_store_count_keep),
	.clear(bias_store_count_clear)
);
//-------------------------------------------PIXEL STORE 
localparam LAYER1_PIXEL_NUM              =16'd3071;
localparam PIXEL_IDLE                    =4'b0000;
localparam PIXEL_LAYER1_STORE            =4'b0001;
logic [ 3:0] pixel_fsm_cs;
logic [ 3:0] pixel_fsm_ns;
logic        pixel_store_count_clear;
logic        pixel_store_count_keep;
logic [15:0] pixel_store_count_data;
always_ff@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		pixel_fsm_cs<=4'b0000;
	end
	else
	begin
		pixel_fsm_cs<=pixel_fsm_ns;
	end
end
always_comb
begin
	case(pixel_fsm_cs)
		PIXEL_IDLE:
		begin
			pixel_store_count_clear=1'b0;
			layer1_input_store_done=1'b0;
			if(wvalid&&awaddr[31:16]==local_pixel_mem_ADDRESS)
			begin
				pixel_store_count_keep=1'b0;
				write_pixel_mem =1'b1;
				pixel_mem_data  =wdata[15:0];
				pixel_mem_addr  =pixel_store_count_data;
				pixel_fsm_ns    =PIXEL_LAYER1_STORE;
			end
			else
			begin
				pixel_store_count_keep=1'b1;
				write_pixel_mem =1'b0;
				pixel_mem_data  =16'd0;
				pixel_mem_addr  =16'd0;
				pixel_fsm_ns    =PIXEL_IDLE;
			end
		end
		PIXEL_LAYER1_STORE:
		begin
			if(wvalid&&awaddr[31:16]==local_pixel_mem_ADDRESS)
			begin
				pixel_store_count_keep=1'b0;
				write_pixel_mem =1'b1;
				pixel_mem_data  =wdata[15:0];
				pixel_mem_addr  =pixel_store_count_data;
			end
			else
			begin
				pixel_store_count_keep=1'b1;
				write_pixel_mem =1'b0;
				pixel_mem_data  =16'd0;
				pixel_mem_addr  =16'd0;
			end
			if(pixel_store_count_data==LAYER1_PIXEL_NUM&&wvalid)
			begin
				pixel_store_count_clear=1'b1;
				layer1_input_store_done=1'b1;
				pixel_fsm_ns           =PIXEL_IDLE;
			end
			else
			begin
				
				pixel_store_count_clear    =1'b0;
				layer1_input_store_done    =1'b0;
				pixel_fsm_ns               =PIXEL_LAYER1_STORE;
			end
		end
		default
		begin
			pixel_fsm_ns           =PIXEL_IDLE;
			pixel_store_count_keep =1'b0;
			write_pixel_mem        =1'b0;
			pixel_mem_data         =16'd0;
			pixel_mem_addr         =16'd0;
			pixel_store_count_clear=1'b1;
			layer1_input_store_done=1'b1;
		end
	endcase
end
counter_cnn pixexl_store_counter(
	.clk(clk),
	.rst(rst),
	.count(pixel_store_count_data),
	.keep(pixel_store_count_keep),
	.clear(pixel_store_count_clear)
);

endmodule




