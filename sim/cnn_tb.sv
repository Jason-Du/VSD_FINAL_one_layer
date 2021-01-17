`timescale 1ns/10ps
`ifdef SYN
`include "cnn_syn.v"
`include "../src/counter_cnn_rtl.sv"
`include "layer1/layer1_sram.v"
`include "layer3/layer3_sram.v"
`include "layer4/layer4_sram.v"
`include "pixel/pixel_sram.v"
`include "word64/word64.v"
`include "word72/word72.v"
`include "/usr/cad/CBDK/CBDK018_UMC_Faraday_v1.0/orig_lib/fsa0m_a/2009Q2v2.0/GENERIC_CORE/FrontEnd/verilog/fsa0m_a_generic_core_21.lib"
`else
`include "layer1/layer1_sram_rtl.sv"
`include "layer3/layer3_sram_rtl.sv"
`include "layer4/layer4_sram_rtl.sv"
`include "pixel/pixel_sram_rtl.sv"
`include "word64/word64_rtl.sv"
`include "word72/word72_rtl.sv"
`include "cnn_rtl.sv"
`include "counter_cnn_rtl.sv"
`endif
`include "def.svh"



`ifdef MNIST
`define		MEM_PIXEL_FILE		"/MNIST/pixel.data"
`define		MEM_WEIGHT_FILE		"/MNIST/weight.data"
`define		MEM_BIAS_FILE		"/MNIST/bias.data"
`define		MEM_PREDICT_FILE		"/MNIST/predict.data"
`define		PIC1_GOLDEN_FILE_LAYER1		"/MNIST/PIC1_CORRECT_LAYER1.data"
`define		PIC1_GOLDEN_FILE_LAYER2		"/MNIST/PIC1_CORRECT_LAYER2.data"
`define		PIC1_GOLDEN_FILE_LAYER3		"/MNIST/PIC1_CORRECT_LAYER3.data"
`define		PIC1_GOLDEN_FILE_LAYER4		"/MNIST/PIC1_CORRECT_LAYER4.data"
`define		PIC1_GOLDEN_FILE_LAYER5		"/MNIST/PIC1_CORRECT_LAYER5.data"
`define		PIC1_GOLDEN_FILE_LAYER6		"/MNIST/PIC1_CORRECT_LAYER6.data"
`define		PIC1_GOLDEN_FILE_LAYER7		"/MNIST/PIC1_CORRECT_LAYER7.data"
`define		PIC2_GOLDEN_FILE_LAYER1	    "/MNIST/PIC2_CORRECT_LAYER1.data"
`define		PIC2_GOLDEN_FILE_LAYER2		"/MNIST/PIC2_CORRECT_LAYER2.data"
`define		PIC2_GOLDEN_FILE_LAYER3		"/MNIST/PIC2_CORRECT_LAYER3.data"
`define		PIC2_GOLDEN_FILE_LAYER4		"/MNIST/PIC2_CORRECT_LAYER4.data"
`define		PIC2_GOLDEN_FILE_LAYER5		"/MNIST/PIC2_CORRECT_LAYER5.data"
`define		PIC2_GOLDEN_FILE_LAYER6		"/MNIST/PIC2_CORRECT_LAYER6.data"
`define		PIC2_GOLDEN_FILE_LAYER7		"/MNIST/PIC2_CORRECT_LAYER7.data"
`endif

`ifdef CIFAR
`define		MEM_PIXEL_FILE		"/CIFAR/pixel.data"
`define		MEM_WEIGHT_FILE		"/CIFAR/weight.data"
`define		MEM_BIAS_FILE		"/CIFAR/bias.data"
`define		MEM_PREDICT_FILE		"/CIFAR/predict.data"
`define		PIC1_GOLDEN_FILE_LAYER1		"/CIFAR/PIC1_CORRECT_LAYER1.data"
`define		PIC1_GOLDEN_FILE_LAYER2		"/CIFAR/PIC1_CORRECT_LAYER2.data"
`define		PIC1_GOLDEN_FILE_LAYER3		"/CIFAR/PIC1_CORRECT_LAYER3.data"
`define		PIC1_GOLDEN_FILE_LAYER4		"/CIFAR/PIC1_CORRECT_LAYER4.data"
`define		PIC1_GOLDEN_FILE_LAYER5		"/CIFAR/PIC1_CORRECT_LAYER5.data"
`define		PIC1_GOLDEN_FILE_LAYER6		"/CIFAR/PIC1_CORRECT_LAYER6.data"
`define		PIC1_GOLDEN_FILE_LAYER7		"/CIFAR/PIC1_CORRECT_LAYER7.data"
`define		PIC2_GOLDEN_FILE_LAYER1	    "/CIFAR/PIC2_CORRECT_LAYER1.data"
`define		PIC2_GOLDEN_FILE_LAYER2		"/CIFAR/PIC2_CORRECT_LAYER2.data"
`define		PIC2_GOLDEN_FILE_LAYER3		"/CIFAR/PIC2_CORRECT_LAYER3.data"
`define		PIC2_GOLDEN_FILE_LAYER4		"/CIFAR/PIC2_CORRECT_LAYER4.data"
`define		PIC2_GOLDEN_FILE_LAYER5		"/CIFAR/PIC2_CORRECT_LAYER5.data"
`define		PIC2_GOLDEN_FILE_LAYER6		"/CIFAR/PIC2_CORRECT_LAYER6.data"
`define		PIC2_GOLDEN_FILE_LAYER7		"/CIFAR/PIC2_CORRECT_LAYER7.data"
`endif




`define		RESULT_FILE		    "RESULT.csv"
`define MAX 1000000000
`define CYCLE 2.0
localparam PIC_NUM=1000;

localparam TOTAL_WEIGHT_NUM=(`PICTURE_CHANNEL*`LAYER1_OUTPUT_CHANNEL_NUM+
							`LAYER1_OUTPUT_CHANNEL_NUM*`LAYER2_OUTPUT_CHANNEL_NUM+
							`LAYER3_OUTPUT_CHANNEL_NUM*`LAYER4_OUTPUT_CHANNEL_NUM+
							`LAYER4_OUTPUT_CHANNEL_NUM*`LAYER5_OUTPUT_CHANNEL_NUM
							)*`KERNEL_SIZE+2000;
localparam TOTAL_BIAS_NUM=`LAYER1_OUTPUT_CHANNEL_NUM+`LAYER2_OUTPUT_CHANNEL_NUM+`LAYER4_OUTPUT_CHANNEL_NUM+`LAYER5_OUTPUT_CHANNEL_NUM+10;
localparam PIXEL_NUM=3072;
module top_tb;
logic STAGE1_COMPLETE;
logic STAGE2_COMPLETE;
logic STAGE3_COMPLETE;
logic STAGE4_COMPLETE;
logic STAGE5_COMPLETE;
logic STAGE6_COMPLETE;
logic STAGE7_COMPLETE;
logic INTERRUPT_SIG;
integer picture_layer7=1;
integer picture_layer6=1;
integer picture_layer5=1;
integer picture_layer4=1;
integer picture_layer3=1;
integer picture_layer2=1;
integer picture_layer1=1;
string prog_path;
string data_path;
logic	clk;
logic 	rst;
logic [31:0]mem_pixel_in[PIXEL_NUM*PIC_NUM];
logic [31:0]mem_weight_in[TOTAL_WEIGHT_NUM];
logic [31:0]mem_bias_in[TOTAL_BIAS_NUM];
logic [31:0]mem_predict_in[PIC_NUM];
logic [31:0]araddr; 
logic [31:0]awaddr; 
logic [31:0]wdata; 
logic arvalid;
logic awvalid;
logic wvalid;
logic [31:0]rdata;
logic interrupt_signal;


logic [           `WORDLENGTH-1:0] reg1;
logic [ `LAYER1_OUTPUT_LENGTH-1:0] result_reg1;
logic [ `LAYER2_OUTPUT_LENGTH-1:0] result_reg2;
logic [ `LAYER3_OUTPUT_LENGTH-1:0] result_reg3;
logic [ `LAYER4_OUTPUT_LENGTH-1:0] result_reg4;
logic [ `LAYER5_OUTPUT_LENGTH-1:0] result_reg5;
logic [ `LAYER6_OUTPUT_LENGTH-1:0] result_reg6;
logic [                     159:0] result_reg7;
logic [                     127:0] cnn_128;

integer row=0;
integer col=0;
integer bias_num=0;
integer weight_num=0;
integer pic_num=0;
integer predict_num=0;

integer weight_index=0;
integer bias_index=0;
integer pixel_index=0;
integer predict_index=0;

integer pass_count=0;
integer err=0;
integer cnt;
integer fp_r, fp_w;

cnn TOP(
	.clk(clk),
	.rst(rst),
	.araddr(araddr),
	.arvalid(arvalid),
	
	.wdata(wdata),
	.wvalid(wvalid),
	
	.awaddr(awaddr),
	.awvalid(awvalid),
	//in out port
	.cnn_128(cnn_128),
	.rdata(rdata),
	.interrupt_signal(interrupt_signal)
);

initial 
begin
	 $value$plusargs("data_path=%s",data_path);
	 //data_path="test";
	 $display("%s",data_path);
	fp_r = $fopen({data_path,`MEM_PIXEL_FILE}, "r");
		while(!$feof(fp_r)) 
		begin
			//$display("pixel_setting");
			cnt = $fscanf(fp_r, "%h",reg1);
			//$display("%h",reg1);
			mem_pixel_in[pic_num]={16'd0,reg1};
			pic_num++;
		end
	$fclose(fp_r);
	fp_r = $fopen({data_path,`MEM_BIAS_FILE}, "r");
		while(!$feof(fp_r)) 
		begin
			//$display("bias_setting");
			cnt = $fscanf(fp_r, "%h",reg1);
			//$display("%h",reg1);
			mem_bias_in[bias_num]={16'd0,reg1};
			bias_num=bias_num+1;
		end
	$fclose(fp_r);
	fp_r = $fopen({data_path,`MEM_WEIGHT_FILE}, "r");
		while(!$feof(fp_r)) 
		begin
			//$display("weight_setting");
			cnt = $fscanf(fp_r, "%h",reg1);
			//$display("%h",reg1);
			mem_weight_in[weight_num]={16'd0,reg1};
			weight_num=weight_num+1;
		end
	$fclose(fp_r);
	fp_r = $fopen({data_path,`MEM_PREDICT_FILE}, "r");
	while(!$feof(fp_r)) 
	begin
		//$display("weight_setting");
		cnt = $fscanf(fp_r, "%h",reg1);
		//$display("%h",reg1);
		mem_predict_in[predict_num]={28'd0,reg1};
		predict_num=predict_num+1;
	end
	$fclose(fp_r);
end

//Initialize
/*
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
*/
initial
begin
	araddr=32'h0000_0000;
	clk   =1'b0;
	rst   =1'b1;
	#(`CYCLE/2) rst   =1'b0;
end
`ifdef SYN
initial
begin 
	$sdf_annotate("cnn_syn.sdf", TOP);
end
`endif
initial
begin

`ifdef RTL
	$fsdbDumpfile("top.fsdb");
	$fsdbDumpvars("+struct", "+mda",TOP);
`endif

	//$fsdbDumpvars(0,TOP);
	//Simulation Limitation
	#(`CYCLE*`MAX);
	$finish;
end


	//$display("%d",$time);
	//$display("%d",weight_set_count);
	//$display("%d",weight_set_clear);
	
logic [15:0] weight_count;
logic weight_clear;
logic weight_keep;
logic [15:0] weight_set_count;
logic weight_set_clear;
logic weight_set_keep;


logic [15:0] bias_count;
logic bias_clear;
logic bias_keep;
logic [15:0] bias_set_count;
logic bias_set_clear;
logic bias_set_keep;

logic [15:0] pixel_count;
logic pixel_clear;
logic pixel_keep;
logic [15:0] pixel_set_count;
logic pixel_set_clear;
logic pixel_set_keep;

logic [2:0] cs;
logic [2:0] ns;
logic [5:0] picture_count_in;
logic [5:0] picture_count_out;
int FAIL_FLAG=0;


localparam FEED_WEIGHT=3'b000;
localparam FEED_BIAS  =3'b001;
localparam FEED_PIXEL =3'b010;
counter_cnn weight_set_counter(
	.clk(clk),
	.rst(rst),
	.count(weight_set_count),
	.clear(weight_set_clear),
	.keep(1'd0)
);
counter_cnn weight_counter(
	.clk(clk),
	.rst(rst),
	.count(weight_count),
	.clear(1'd0),
	.keep(weight_keep)
);
counter_cnn bias_set_counter(
	.clk(clk),
	.rst(rst),
	.count(bias_set_count),
	.clear(bias_set_clear),
	.keep(1'd0)
);
counter_cnn bias_counter(
	.clk(clk),
	.rst(rst),
	.count(bias_count),
	.clear(1'd0),
	.keep(bias_keep)
);
counter_cnn pixel_set_counter(
	.clk(clk),
	.rst(rst),
	.count(pixel_set_count),
	.clear(pixel_set_clear),
	.keep(1'd0)
);
counter_cnn pixel_counter(
	.clk(clk),
	.rst(rst),
	.count(pixel_count),
	.clear(1'd0),
	.keep(pixel_keep)
);

always_ff@(posedge clk or rst)
begin
	if(rst)
	begin
		cs<=3'd0;
		picture_count_out<=6'd0;
	end
	else
	begin
		cs<=ns;
		picture_count_out<=picture_count_in;
	end
end
always_comb
begin
	picture_count_in=interrupt_signal?picture_count_out+6'd1:picture_count_out;
end
always_comb
begin
	if(~rst)
	begin
		awvalid=(TOP.interrupt_signal)?1'b1:1'b0;
		case(cs)
			FEED_WEIGHT:
			begin
			`ifdef nonideal_transfer
				if(weight_set_count==16'd4)
				begin
					weight_set_clear=1'd1;
				end
				else
				begin
					weight_set_clear=1'd0;
				end
				if(weight_set_count==16'd0)
				begin
					wvalid=1'd1;
					weight_keep=1'd0;
					awaddr=32'hd333_0000;
					wdata=mem_weight_in[weight_count];
				end
				else
				begin
					wvalid=1'd0;
					weight_keep=1'd1;
					awaddr=32'h0000_0000;
					wdata=32'd0;
				end
			`endif
			`ifdef ideal_transfer
				awaddr=32'hd333_0000;
				wvalid=1'd1;
				weight_keep=1'd0;
				wdata=mem_weight_in[weight_count];
			`endif
				
				if(weight_count==TOTAL_WEIGHT_NUM)
				begin
					ns=FEED_BIAS;
				end
				else
				begin
					ns=FEED_WEIGHT;
				end
			end
			
			FEED_BIAS:
			begin
				`ifdef nonideal_transfer
				if(bias_set_count==16'd4)
				begin
					bias_set_clear=1'd1;
				end
				else
				begin
					bias_set_clear=1'd0;
				end
				if(bias_set_count==16'd0)
				begin
					wvalid=1'd1;
					bias_keep=1'd0;
					awaddr=32'hd444_0000;
					wdata=mem_bias_in[bias_count];
				end
				else
				begin
					wvalid=1'd0;
					bias_keep=1'd1;
					awaddr=32'h0000_0000;
					wdata=32'd0;
				end
				`endif
				`ifdef ideal_transfer
				wvalid=1'd1;
				bias_keep=1'd0;
				awaddr=32'hd444_0000;
				wdata=mem_bias_in[bias_count];
				`endif
				if(bias_count==TOTAL_BIAS_NUM)
				begin
					ns=FEED_PIXEL;
				end
				else
				begin
					ns=FEED_BIAS;
				end
			end
			FEED_PIXEL:
			begin
				`ifdef nonideal_transfer
				if(pixel_set_count==16'd4)
				begin
					pixel_set_clear=1'd1;
				end
				else
				begin
					pixel_set_clear=1'd0;
				end
				if(pixel_set_count==16'd0&&!(TOP.interrupt_signal))
				begin
					wvalid=1'd1;
					pixel_keep=1'd0;
					awaddr=32'hd555_0000;
					wdata=mem_pixel_in[pixel_count];
				end
				else
				begin
					wvalid=1'd0;
					pixel_keep=1'd1;
					awaddr=(TOP.interrupt_signal)?32'hd000_0200:32'h0000_0000;
					
					wdata=32'd0;
				end
				`endif
				`ifdef ideal_transfer
				wvalid=1'd1;
				pixel_keep=1'd0;
				awaddr=32'hd555_0000;
				wdata=mem_pixel_in[pixel_count];
				pixel_set_clear=1'd1;
				`endif
				ns=FEED_PIXEL;
			end
			default
			begin
				bias_keep=1'b1;
				bias_set_clear=1'd1;
				weight_keep=1'b1;
				weight_set_clear=1'd1;
				pixel_keep=1'b1;
				pixel_set_clear=1'd1;
				wvalid=1'b0;
				awaddr=32'h0000_0000;
				wdata=32'd0;
				ns=FEED_WEIGHT;
			end
		endcase
	end
	else
	begin
		awvalid=1'b0;
		bias_keep=1'b1;
		bias_set_clear=1'd1;
		weight_keep=1'b1;
		weight_set_clear=1'd1;
		pixel_keep=1'b1;
		pixel_set_clear=1'd1;
		wvalid=1'b0;
		awaddr=32'h0000_0000;
		wdata=32'd0;
		ns=FEED_WEIGHT;
	end
end
`ifdef RTL
always_ff@(posedge clk)
begin
	if(rst)
	begin	
		STAGE1_COMPLETE<=0;
	end
	else
	begin
		STAGE1_COMPLETE<=TOP.layer1_calculation_done;
	end
end
`endif
`ifdef SYN
always_ff@(posedge clk)
begin
	if(rst)
	begin	
		STAGE1_COMPLETE<=0;
	end
	else
	begin
		STAGE1_COMPLETE<=TOP.layer1.layer1_calculation_done;
	end
end
`endif
always
begin
	#(`CYCLE/2) clk = ~clk;
end
int memory_index=0;
int memory_even_even=0;
int memory_even_odd=0;
int memory_odd_even=0;
int memory_odd_odd=0;
int row_even=0;
int col_even=0;
int predict_hit=0;
int read_pic_num=0;
always
begin
	#(`CYCLE);
	if(STAGE1_COMPLETE)
	begin
		$display("PICTURE %d STAGE1_COMPLETE",picture_layer1);
		$display("%d",$time);
		row=0;
		col=0;
		memory_index=0;
		memory_even_even=0;
		memory_even_odd=0;
		memory_odd_even=0;
		memory_odd_odd=0;
		pass_count=0;
		if(picture_layer1==1)
		begin
			fp_r = $fopen({data_path,`PIC1_GOLDEN_FILE_LAYER1}, "r");
		end
		if(picture_layer1==2)
		begin
			fp_r = $fopen({data_path,`PIC2_GOLDEN_FILE_LAYER1}, "r");
		end
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",result_reg1);			
			if(result_reg1==TOP.layer1_data_mem.layer1_st.i_layer1_sram.Memory[memory_index])
			begin
				pass_count=pass_count+1;
				$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg1);
			end
			else
			begin
				$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg1,TOP.layer1_data_mem.layer1_st.i_layer1_sram.Memory[memory_index]);
				FAIL_FLAG=1;
			end
			
			if(col==`LAYER2_WIDTH-1)
			begin
				col=0;
				row=row+1;
			end
			else
			begin
				col=col+1;
			end
			memory_index++;
		end
		$fclose(fp_r);
		photo(.CORRECT_pass_count(`LAYER2_WIDTH**2),.REAL_pass_count(pass_count),.picture_num(picture_layer1),.STAGE("STAGE1"));
		if (picture_layer1==2)
		begin
			$finish;
		end		
		picture_layer1++;
	end
end

	task photo();
		input int CORRECT_pass_count;
		input int REAL_pass_count;
		input int picture_num;
		input string STAGE;
		$display("PICTURE [%2d] %s COMPLETE",picture_num,STAGE);
		$display("%d",$time);
		if (REAL_pass_count==CORRECT_pass_count)
		begin
			$display("%d PASS",pass_count);
			$display("PICTURE [%2d] %s IS PASS",picture_num,STAGE);
			$display("\n");
			$display("        ****************************               ");
			$display("        **                        **       |\__||  ");
			$display("        **  Congratulations !!    **      / O.O  | ");
			$display("        **                        **    /_____   | ");
			$display("        **  Simulation PASS!!     **   /^ ^ ^ \\  |");
			$display("        **                        **  |^ ^ ^ ^ |w| ");
			$display("        ****************************   \\m___m__|_|");
			$display("\n");
		end
		else
		begin
			err=CORRECT_pass_count-REAL_pass_count;
			$display("PICTURE [%2d] %s IS FAIL",picture_num,STAGE);
			$display("        ****************************   ");
			$display("        **                        **   ");
			$display("        **  OOPS!!                **   ");
			$display("        **                        **   ");
			$display("        **  Simulation Failed!!   **   ");
			$display("        **                        **   ");
			$display("        ****************************   ");
			$display("                 .   .                 ");
			$display("                . ':' .                ");
			$display("                ___:____     |//\//|   ");
			$display("              ,'        `.    \  /     ");
			$display("              |  O        \___/  |     ");
			$display("~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~");
			$display("         Totally has %d errors ", err); 
			$display("\n");
		end
	endtask
	task interrupt_test();
		//input answer;
		if(STAGE7_COMPLETE)
		begin
			araddr=32'hd000_0000;
			# (`CYCLE)
			if(TOP.rdata==mem_predict_in[predict_index])
			begin
				$display("INTERRUPT RESULT MATCH");
				$display("CORRECT ANSWER:[ %h ]",mem_predict_in[predict_index]);
				predict_hit++;

			end
			else
			begin
				$display("PREDICT MISS INDEX:[%2d]",predict_index+1);
				$display("INTERRUPT RESULT MISMATCH ERROR");
				$display("CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",mem_predict_in[predict_index],TOP.rdata);
			end
			predict_index++;
		end
		if(predict_index==30)
		begin	
			$finish();
		end
	endtask
	
	
	
	
endmodule