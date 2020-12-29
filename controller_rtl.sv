`timescale 1ns/10ps
`include"counter_rtl.sv"
module controller(
	clk,
	rst,
	bus_write_signal,
	bus_read_signal,
	
	image_set_register_data_output,
	wdata,
	araddr,
	awaddr,
	wvalid,
	//------------------------IN/OUT PORT
	//arready,
	//awready,
	
	image_set_register_data_in,
	image_set_register_write_signal,
	interrupr_rsgister_data_in,
	interrupr_rsgister_write_signal,
	
	layer1_weight_set_done,
	layer1_bias_set_done,
	layer1_pixel_set_done,
	//setdone signal
	
	read_pixel_mem,
	write_pixel_mem,
	pixel_mem_addr,
	pixel_mem_data,
	
	read_weight_mem,
	write_weight_mem,
	weight_mem_addr,
	weight_mem_data,
	
	
	read_bias_mem,
	write_bias_mem,
	bias_mem_addr,
	bias_mem_data,
	
	read_result_signal,
	write_result_signal
	
);
localparam result_address             =32'hffffffff;
localparam image_set_register_ADDRESS =4'b0001;
localparam interrupr_rsgister_ADDRESS =4'b0010;
localparam local_pixel_mem_ADDRESS    =4'b0100;
localparam local_weight_mem_ADDRESS   =4'b1000;
localparam local_bias_mem_ADDRESS     =4'b1001;

input               clk;
input               rst;
input        [31:0] awaddr;
input        [31:0] araddr;
input               bus_read_signal;
input               bus_write_signal;
input        [31:0] wdata;
input        [ 1:0] image_set_register_data_output;
input               wvalid;

output logic	    layer1_weight_set_done;
output logic	    layer1_bias_set_done;
output logic     	layer1_pixel_set_done;
//output logic        arready;
//output logic        awready;
output logic [ 1:0] image_set_register_data_in;
output logic        image_set_register_write_signal;
output logic        interrupr_rsgister_data_in;
output logic        interrupr_rsgister_write_signal;

output logic        read_pixel_mem;
output logic        write_pixel_mem;
output logic [15:0] pixel_mem_addr;
output logic [15:0] pixel_mem_data;

output logic        read_weight_mem;
output logic        write_weight_mem;
output logic [15:0] weight_mem_addr;
output logic [15:0] weight_mem_data;

output logic 	    read_bias_mem;
output logic     	write_bias_mem;
output logic [15:0]	bias_mem_addr;
output logic [15:0] bias_mem_data;


output logic 	read_result_signal;
output logic	write_result_signal;

//----------------------------INTTERUPT RESET FROM CPU--------MEMORY MAPPING-------//
always_comb
begin
	if(awaddr[31:28]==interrupr_rsgister_ADDRESS)
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
//-------------------------CPU READ DATA----------------------------------------//
always_comb
begin
	if(araddr==result_address)
	begin
		read_result_signal=1'b1;
	end
	else
	begin
		read_result_signal=1'b0;
	end
end 
//----------------------------TRANSSFER  DATA--MEMORY MAPPING------------//
always_comb
begin
	if(awaddr[31:28]==image_set_register_ADDRESS)
	begin
		image_set_register_write_signal=1'b1;
		image_set_register_data_in=wdata[1:0];
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
//-----------------------WEIGHT  STOREING  SETTING ----------//
localparam WEIGHT_IDLE                    =4'b0000;
localparam WEIGHT_LAYER1_SET              =4'b0010;
localparam WEIGHT_LAYER1_STORE            =4'b0001;
localparam WEIGHT_FINISH                  =4'b0011;
localparam LAYER1_WEIGHT_NUM              =16'd216;
localparam LAYER1_WEIGHT_NUM_SET_COUNT    =16'd72;

logic [ 3:0] weight_fsm_cs;
logic [ 3:0] weight_fsm_ns;
logic        weight_store_count_clear;
logic        weight_store_count_keep;
logic [15:0] weight_store_count_data;
logic [ 4:0] layer_weight_sel;
logic [15:0] weight_set_count_data;
logic        weight_set_counter_clear;
logic	    layer1_weight_store_done;
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
			layer1_weight_set_done  =1'b0;
			layer_weight_sel        =5'd0;
			weight_set_counter_clear=1'b1;
			read_weight_mem         =1'b0;
			if(wvalid&&awaddr[31:28]==local_weight_mem_ADDRESS)
			begin
				weight_store_count_keep=1'b0;
				write_weight_mem =1'b1;
				weight_mem_data  =wdata[15:0];
				weight_mem_addr  =weight_store_count_data;
				weight_fsm_ns    =WEIGHT_LAYER1_STORE;
			end
			else
			begin
				weight_store_count_keep=1'b1;
				write_weight_mem =1'b0;
				weight_mem_data  =16'd0;
				weight_mem_addr  =16'd0;
				weight_fsm_ns    =WEIGHT_IDLE;
			end
		end
		WEIGHT_LAYER1_STORE:
		begin
			layer1_weight_set_done   =1'b0;
			layer_weight_sel         =5'd0;
			weight_set_counter_clear =1'b1;
			if(wvalid&&awaddr[31:28]==local_weight_mem_ADDRESS)
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
			if(weight_store_count_data==LAYER1_WEIGHT_NUM)
			begin
				weight_store_count_clear=1'b1;
				layer1_weight_store_done=1'b1;
				weight_fsm_ns           =WEIGHT_FINISH;
			end
			else
			begin
				weight_store_count_clear    =1'b0;
				layer1_weight_store_done    =1'b0;
				weight_fsm_ns               =WEIGHT_LAYER1_STORE;
			end
		end
		
		/*
		WEIGHT_LAYER1_SET:
		begin
			weight_store_count_clear=1'b1;
			layer1_weight_store_done=1'b1;
			layer_weight_sel=5'd0;
			if(wvalid&&awaddr[31:28]==local_weight_mem_ADDRESS)
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
			if (weight_set_count_data==LAYER1_WEIGHT_NUM_SET_COUNT)
			begin
				layer1_weight_set_done  =1'b1;
				weight_set_counter_clear=1'b1;
				read_weight_mem=1'b0;
				weight_fsm_ns=WEIGHT_FINISH;
			end
			else
			begin
				layer1_weight_set_done  =1'b0;
				weight_set_counter_clear=1'b0;
				read_weight_mem=1'b1;
				weight_fsm_ns=WEIGHT_LAYER1_SET;
			end	
		end
		*/
		WEIGHT_FINISH:
		begin
			weight_fsm_ns           =WEIGHT_FINISH;
			weight_store_count_keep =1'b0;
			write_weight_mem        =1'b0;
			weight_mem_data         =16'd0;
			weight_mem_addr         =16'd0;
			weight_store_count_clear=1'b1;
			layer1_weight_store_done=1'b1;
			layer1_weight_set_done  =1'b1;
			layer_weight_sel        =5'd0;
			weight_set_counter_clear=1'b1;
			read_weight_mem         =1'b0;
		end
		default:
		begin
			weight_fsm_ns           =WEIGHT_IDLE;
			weight_store_count_keep =1'b0;
			write_weight_mem        =1'b0;
			weight_mem_data         =16'd0;
			weight_mem_addr         =16'd0;
			weight_store_count_clear=1'b1;
			layer1_weight_store_done=1'b1;
			layer1_weight_set_done  =1'b1;
			layer_weight_sel        =5'd0;
			weight_set_counter_clear=1'b1;
			read_weight_mem         =1'b0;
		end
	endcase
end
counter weight_store_counter(
	.clk(clk),
	.rst(rst),
	.count(weight_store_count_data),
	.keep(weight_store_count_keep),
	.clear(weight_store_count_clear)
);
/*
counter weight_set_counter(
	.clk(clk),
	.rst(rst),
	.count(weight_set_count_data),
	.keep(1'b0),
	.clear(weight_set_counter_clear)
);
*/
//-----------------------BIAS  STOREING  SETTING ----------//
localparam BIAS_IDLE                    =4'b0000;
localparam BIAS_LAYER1_SET              =4'b0010;
localparam BIAS_LAYER1_STORE            =4'b0001;
localparam BIAS_FINISH                  =4'b0011;
localparam LAYER1_BIAS_NUM              =16'd8;
localparam LAYER1_BIAS_NUM_SET_COUNT    =16'd8;

logic [ 3:0] bias_fsm_cs;
logic [ 3:0] bias_fsm_ns;
logic        bias_store_count_clear;
logic        bias_store_count_keep;
logic [15:0] bias_store_count_data;
logic [ 4:0] layer_bias_sel;
logic [15:0] bias_set_count_data;
logic        bias_set_counter_clear;
logic	     layer1_bias_store_done;
/*
output logic 	    read_bias_mem;
output logic     	write_bias_mem;
output logic [ 9:0]	bias_mem_addr;
output logic [15:0] bias_mem_data;
*/
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
			layer1_bias_set_done  =1'b0;
			layer_bias_sel        =5'd0;
			bias_set_counter_clear=1'b1;
			read_bias_mem         =1'b0;
			if(wvalid&&awaddr[31:28]==local_bias_mem_ADDRESS)
			begin
				bias_store_count_keep=1'b0;
				write_bias_mem =1'b1;
				bias_mem_data  =wdata[15:0];
				bias_mem_addr  =bias_store_count_data;
				bias_fsm_ns    =BIAS_LAYER1_STORE;
			end
			else
			begin
				bias_store_count_keep=1'b1;
				write_bias_mem =1'b0;
				bias_mem_data  =16'd0;
				bias_mem_addr  =16'd0;
				bias_fsm_ns    =BIAS_IDLE;
			end
		end
		BIAS_LAYER1_STORE:
		begin
			layer1_bias_set_done   =1'b0;
			layer_bias_sel         =5'd0;
			bias_set_counter_clear =1'b1;
			if(wvalid&&awaddr[31:28]==local_bias_mem_ADDRESS)
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
			if(bias_store_count_data==LAYER1_BIAS_NUM)
			begin
				bias_store_count_clear=1'b1;
				layer1_bias_store_done=1'b1;
				bias_fsm_ns           =BIAS_FINISH;
			end
			else
			begin
				
				bias_store_count_clear    =1'b0;
				layer1_bias_store_done    =1'b0;
				bias_fsm_ns               =BIAS_LAYER1_STORE;
			end
		end
		BIAS_LAYER1_SET:
		begin
		/*
			bias_store_count_keep=1'b0;
			write_bias_mem=1'b0;
			bias_mem_data =16'd0;
			bias_mem_addr =16'd0;
			*/
			bias_store_count_clear=1'b1;
			layer1_bias_store_done=1'b1;
			layer_bias_sel=5'd0;
			if(wvalid&&awaddr[31:28]==local_bias_mem_ADDRESS)
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
			if (bias_set_count_data==LAYER1_BIAS_NUM_SET_COUNT)
			begin
				layer1_bias_set_done  =1'b1;
				bias_set_counter_clear=1'b1;
				read_bias_mem=1'b0;
				bias_fsm_ns=BIAS_FINISH;
			end
			else
			begin
				layer1_bias_set_done  =1'b0;
				bias_set_counter_clear=1'b0;
				read_bias_mem=1'b1;
				bias_fsm_ns=BIAS_LAYER1_SET;
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
			layer1_bias_store_done=1'b1;
			layer1_bias_set_done  =1'b1;
			layer_bias_sel        =5'd0;
			bias_set_counter_clear=1'b1;
			read_bias_mem         =1'b0;
		end
		default:
		begin
			bias_fsm_ns           =BIAS_IDLE;
			bias_store_count_keep =1'b0;
			write_bias_mem        =1'b0;
			bias_mem_data         =16'd0;
			bias_mem_addr         =16'd0;
			bias_store_count_clear=1'b1;
			layer1_bias_store_done=1'b1;
			layer1_bias_set_done  =1'b1;
			layer_bias_sel        =5'd0;
			bias_set_counter_clear=1'b1;
			read_bias_mem         =1'b0;
		end
	endcase
end
//reduce part
counter bias_store_counter(
	.clk(clk),
	.rst(rst),
	.count(bias_store_count_data),
	.keep(bias_store_count_keep),
	.clear(bias_store_count_clear)
);
/*
counter bias_set_counter(
	.clk(clk),
	.rst(rst),
	.count(bias_set_count_data),
	.keep(1'b0),
	.clear(bias_set_counter_clear)
);
*/
//-------------------------------------------PIXEL STORE SET----------------------------------
localparam PIXEL_IDLE                    =4'b0000;
localparam PIXEL_LAYER1_SET              =4'b0010;
localparam PIXEL_LAYER1_STORE            =4'b0001;
localparam PIXEL_FINISH                  =4'b0011;
localparam LAYER1_PIXEL_NUM              =16'd8;
localparam LAYER1_PIXEL_NUM_SET_COUNT    =16'd8;

logic [ 3:0] pixel_fsm_cs;
logic [ 3:0] pixel_fsm_ns;
logic        pixel_store_count_clear;
logic        pixel_store_count_keep;
logic [15:0] pixel_store_count_data;
logic [ 4:0] layer_pixel_sel;
logic [15:0] pixel_set_count_data;
logic        pixel_set_counter_clear;
logic	     layer1_pixel_store_done;
/*
output logic        read_pixel_mem;
output logic        write_pixel_mem;
output logic [15:0] pixel_mem_addr;
output logic [15:0] pixel_mem_data;
*/
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
			layer1_pixel_store_done=1'b0;
			layer1_pixel_set_done  =1'b0;
			layer_pixel_sel        =5'd0;
			pixel_set_counter_clear=1'b1;
			read_pixel_mem         =1'b0;
			if(wvalid&&awaddr[31:28]==local_pixel_mem_ADDRESS)
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
			layer1_pixel_set_done   =1'b0;
			layer_pixel_sel         =5'd0;
			pixel_set_counter_clear =1'b1;
			if(wvalid&&awaddr[31:28]==local_pixel_mem_ADDRESS)
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
			if(pixel_store_count_data==LAYER1_PIXEL_NUM)
			begin
				pixel_store_count_clear=1'b1;
				layer1_pixel_store_done=1'b1;
				pixel_fsm_ns           =PIXEL_LAYER1_STORE;
			end
			else
			begin
				
				pixel_store_count_clear    =1'b0;
				layer1_pixel_store_done    =1'b0;
				pixel_fsm_ns               =PIXEL_LAYER1_STORE;
			end
		end
		/*
		PIXEL_LAYER1_SET:
		begin
		
			pixel_store_count_keep=1'b0;
			write_pixel_mem=1'b0;
			pixel_mem_data =16'd0;
			pixel_mem_addr =16'd0;
			
			pixel_store_count_clear=1'b1;
			layer1_pixel_store_done=1'b1;
			layer_pixel_sel=5'd0;
			if(wvalid&&awaddr[31:28]==local_pixel_mem_ADDRESS)
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
			if (pixel_set_count_data==LAYER1_PIXEL_NUM_SET_COUNT)
			begin
				layer1_pixel_set_done  =1'b1;
				pixel_set_counter_clear=1'b1;
				read_pixel_mem=1'b0;
				pixel_fsm_ns=PIXEL_LAYER1_STORE;
			end
			else
			begin
				layer1_pixel_set_done  =1'b0;
				pixel_set_counter_clear=1'b0;
				read_pixel_mem=1'b1;
				pixel_fsm_ns=PIXEL_LAYER1_SET;
			end	
		end
		*/
		default:
		begin
			pixel_fsm_ns           =PIXEL_IDLE;
			pixel_store_count_keep =1'b0;
			write_pixel_mem        =1'b0;
			pixel_mem_data         =16'd0;
			pixel_mem_addr         =16'd0;
			pixel_store_count_clear=1'b1;
			layer1_pixel_store_done=1'b1;
			layer1_pixel_set_done  =1'b1;
			layer_pixel_sel        =5'd0;
			pixel_set_counter_clear=1'b1;
			read_pixel_mem         =1'b0;
		end
	endcase
end
//reduce part

counter pixexl_store_counter(
	.clk(clk),
	.rst(rst),
	.count(pixel_store_count_data),
	.keep(pixel_store_count_keep),
	.clear(pixel_store_count_clear)
);
/*
counter pixel_set_counter(
	.clk(clk),
	.rst(rst),
	.count(pixel_set_count_data),
	.keep(1'b0),
	.clear(pixel_set_counter_clear)
);
*/
//-------------------------CACULATE LAYER1 IS DONE--------------------------
/*
localparam CACULATE_IDLE     =1'b0;
localparam CACULATE_OPERATION=1'b1;

logic [15:0] calculate_layer1_count_data;
logic        calculate_stage_count_keep;
logic [15:0] calculate_layer1_count_clear;
logic        layer1_caculate_done;
logic        calculate_cs;
logic        calculate_ns;
always_comb
begin
	case(calculate_cs)
		CACULATE_IDLE:
		begin
			if(layer1_bias_set_done)
			begin
				calculate_layer1_count_clear=1'b0;
				calculate_ns=CACULATE_OPERATION;
			end
			else
			begin
				calculate_layer1_count_clear=1'b1;
				calculate_ns=CACULATE_IDLE;
			end
		end
		CACULATE_OPERATION:
		begin
			if(calculate_layer1_count_data==16'd3072)
			begin
				calculate_layer1_count_clear=1'b1;
				layer1_caculate_done         =1'b1;
				calculate_ns=CACULATE_IDLE;
			end
			else
			begin
				calculate_layer1_count_clear=1'b0;
				calculate_ns=CACULATE_OPERATION;
			end			
		end
	endcase
end
always_ff@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		calculate_cs<=1'b0;
	end
	else
	begin
		calculate_cs<=calculate_ns;
	end
end
counter calculate_stage1_counter(
	.clk(clk),
	.rst(rst),
	.count(calculate_layer1_count_data),
	.keep(1'b0),
	.clear(calculate_layer1_count_clear)
);
*/
//--------STOREING RESULT--------------
/*
always_comb
begin
	if(layer1_caculate_done)
	begin
		write_result_signal=1'b1;
	end
	else
	begin
		write_result_signal=1'b0;
	end
end
*/
endmodule
















