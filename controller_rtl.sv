`timescale 1ns/10ps
`include"counter_rtl.sv"
module controller(
	clk,
	rst,
	bus_addr,
	bus_write_signal,
	bus_read_signal,
	bus_write_data,
	image_set_register_data_output,
	wvalid
	//------------------------IN/OUT PORT
	arready,
	awready,
	
	image_set_register_data_in,
	image_set_register_write_signal,
	interrupr_rsgister_data_in,
	interrupr_rsgister_write_signal,
	
	layer1_weight_store_done,
	layer1_bias_store_done,
	pixel_store_done,
	
	read_pixel_mem,
	write_pixel_mem,
	pixel_mem_addr,
	pixel_mem_data,
);
localparam image_set_register_ADDRESS =3'b100;
localparam interrupr_rsgister_ADDRESS =3'b101;
localparam local_pixel_mem_ADDRESS    =3'b001;
localparam local_weight_mem_ADDRESS   =3'b010;
localparam local_bias_mem_ADDRESS     =3'b011;


input               clk;
input               rst;
input        [31:0] bus_addr;
input               bus_read_signal;
input               bus_write_signal;
input        [31:0] bus_write_data;
input        [ 1:0] image_set_register_data_output;
input               wvalid;

output logic	    layer1_weight_store_done;
output logic	    layer1_bias_store_done;
output logic     	pixel_store_done;
output logic        arready;
output logic        awready;
output logic [ 1:0] image_set_register_data_in;
output logic        image_set_register_write_signal;
output logic        interrupr_rsgister_data_in;
output logic        interrupr_rsgister_write_signal;

output logic        read_pixel_mem;
output logic        write_pixel_mem;
output logic [12:0] pixel_mem_addr;
output logic [15:0] pixel_mem_data;
//----------------------------INTTERUPT RESET FROM CPU--------------//
/*
always_comb
begin
	if(bus_addr[31:29]==interrupr_rsgister_ADDRESS)
	begin
		interrupr_rsgister_write_signal=1'b1;
		interrupr_rsgister_data_in=1'b0;
	end
	else
	begin
		interrupr_rsgister_write_signal=1'b0;
		interrupr_rsgister_data_in=1'b0;
	end
end
*/
//----------------------------TRANSSFER LAST DATA--------------//
always_comb
begin
	if(bus_addr[31:29]==image_set_register_ADDRESS)
	begin
		image_set_register_write_signal=1'b1;
		image_set_register_data_in=bus_write_data[1:0];
	end
	else if(image_set_register_data_output)
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
//----------------------------TRANSSFER PICTURE-------STOREING STAGE-----------//
logic weight_counter_clear;
logic weight_count_data;
logic weight_fsm_state;
logic [3:0] weight_fsm_ns;
logic [3:0] weight_fsm_cs;

localparam WEIGHT_IDLE   =4'b0000;
localparam WEIGHT_SETTING=4'b0001;
localparam WEIGHT_NUM    =16'd215
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
	case(weight_fsm_state)
		WEIGHT_IDLE:
		begin
			layer1_weight_store_done=1'b0;
			if (bus_addr[31:29]==local_weight_mem_ADDRESS)
			begin
				weight_fsm_ns=WEIGHT_SETTING;
				clear=1'b0;
				
			end
			else
			begin
				weight_fsm_ns<=WEIGHT_IDLE;
				clear=1'b1;
			end
		end
		WEIGHT_SETTING:
		begin
			clear=1'b0;
			if(weight_count_data=WEIGHT_NUM)
			begin
				weight_fsm_ns=WEIGHT_SETTING;
				layer1_weight_store_done=1'b1;
			end
			else
			begin
				weight_fsm_ns=WEIGHT_SETTING;
				layer1_weight_store_done=1'b0;
			end
		end
		default
		begin
			layer1_weight_store_done=1'b0;
			weight_fsm_ns=WEIGHT_IDLE;
			clear=1'b0;
		end
	endcase
end
counter weight_counter	(
	.clk(clk),
	.rst(rst),
	.count(weight_count_data),
	.clear(weight_counter_clear),
);





endmodule

















