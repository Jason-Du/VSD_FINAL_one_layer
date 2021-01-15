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




`define		MEM_PIXEL_FILE		"/pixel.data"
`define		MEM_WEIGHT_FILE		"/weight.data"
`define		MEM_BIAS_FILE		"/bias.data"
`define		PIC1_GOLDEN_FILE_LAYER1		"/PIC1_CORRECT_LAYER1.data"
`define		PIC1_GOLDEN_FILE_LAYER2		"/PIC1_CORRECT_LAYER2.data"
`define		PIC1_GOLDEN_FILE_LAYER3		"/PIC1_CORRECT_LAYER3.data"
`define		PIC1_GOLDEN_FILE_LAYER4		"/PIC1_CORRECT_LAYER4.data"
`define		PIC1_GOLDEN_FILE_LAYER5		"/PIC1_CORRECT_LAYER5.data"
`define		PIC1_GOLDEN_FILE_LAYER6		"/PIC1_CORRECT_LAYER6.data"
`define		PIC1_GOLDEN_FILE_LAYER7		"/PIC1_CORRECT_LAYER7.data"
`define		PIC2_GOLDEN_FILE_LAYER1	    "/PIC2_CORRECT_LAYER1.data"
`define		PIC2_GOLDEN_FILE_LAYER2		"/PIC2_CORRECT_LAYER2.data"
`define		PIC2_GOLDEN_FILE_LAYER3		"/PIC2_CORRECT_LAYER3.data"
`define		PIC2_GOLDEN_FILE_LAYER4		"/PIC2_CORRECT_LAYER4.data"
`define		PIC2_GOLDEN_FILE_LAYER5		"/PIC2_CORRECT_LAYER5.data"
`define		PIC2_GOLDEN_FILE_LAYER6		"/PIC2_CORRECT_LAYER6.data"
`define		PIC2_GOLDEN_FILE_LAYER7		"/PIC2_CORRECT_LAYER7.data"
`define		RESULT_FILE		    "RESULT.csv"
`define MAX 80000
`define CYCLE 20.0
localparam PIC_NUM=2;
localparam PIXEL_NUM=3072;
localparam TOTAL_WEIGHT_NUM=(`PICTURE_CHANNEL*`LAYER1_OUTPUT_CHANNEL_NUM+
							`LAYER1_OUTPUT_CHANNEL_NUM*`LAYER2_OUTPUT_CHANNEL_NUM+
							`LAYER3_OUTPUT_CHANNEL_NUM*`LAYER4_OUTPUT_CHANNEL_NUM+
							`LAYER4_OUTPUT_CHANNEL_NUM*`LAYER5_OUTPUT_CHANNEL_NUM
							)*`KERNEL_SIZE+2000;
localparam TOTAL_BIAS_NUM=`LAYER1_OUTPUT_CHANNEL_NUM+`LAYER2_OUTPUT_CHANNEL_NUM+`LAYER4_OUTPUT_CHANNEL_NUM+`LAYER5_OUTPUT_CHANNEL_NUM+10;
module top_tb;
logic STAGE1_COMPLETE;
logic STAGE2_COMPLETE;
logic STAGE3_COMPLETE;
logic STAGE4_COMPLETE;
logic STAGE5_COMPLETE;
logic STAGE6_COMPLETE;
logic STAGE7_COMPLETE;
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

integer row=0;
integer col=0;
integer bias_num=0;
integer weight_num=0;
integer pic_num=0;

integer weight_index=0;
integer bias_index=0;
integer pixel_index=0;

integer pass_count=0;
integer err=0;
integer fp_r, fp_w, cnt;

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
				if(pixel_set_count==16'd0)
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
					awaddr=32'h0000_0000;
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
		STAGE2_COMPLETE<=0;
		STAGE3_COMPLETE<=0;
		STAGE4_COMPLETE<=0;
		STAGE5_COMPLETE<=0;
		STAGE6_COMPLETE<=0;
		STAGE7_COMPLETE<=0;
	end
	else
	begin
		STAGE1_COMPLETE<=TOP.layer1_calculation_done;
		STAGE2_COMPLETE<=TOP.layer2_calculation_done;
		STAGE3_COMPLETE<=TOP.layer3_calculation_done;
		STAGE4_COMPLETE<=TOP.layer4_calculation_done;
		STAGE5_COMPLETE<=TOP.layer5_calculation_done;
		STAGE6_COMPLETE<=TOP.layer6_calculation_done;
		STAGE7_COMPLETE<=TOP.layer7_calculation_done;
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
always
begin
	#(`CYCLE);
	if(STAGE1_COMPLETE&&(picture_layer1<=2))
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
		/*
		if (picture_layer1==1)
		begin
			$finish;
		end		
		*/
		picture_layer1++;
		//$finish;	
	end
	////////////////////////////////////////////////////////////////////
	pass_count=0;
`ifdef RTL
	if(STAGE2_COMPLETE)
	begin
		$display("PICTURE %d STAGE2_COMPLETE",picture_layer2);
		$display("%d",$time);
		
		row=0;
		col=0;
		memory_index=0;
		memory_even_even=0;
		memory_even_odd=0;
		memory_odd_even=0;
		memory_odd_odd=0;
		if(picture_layer2==1)
		begin
			fp_r = $fopen({data_path,`PIC1_GOLDEN_FILE_LAYER2},"r");
		end
		if(picture_layer2==2)
		begin
			fp_r = $fopen({data_path,`PIC2_GOLDEN_FILE_LAYER2},"r");
		end
		
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",result_reg2);
			row_even=row%2;
			col_even=col%2;
			if (row_even==0&&col_even==0)
			begin
				if(result_reg2==TOP.layer2_data_mem_even_even.layer2_st.i_layer3_sram.Memory[memory_even_even])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg2);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg2,TOP.layer2_data_mem_even_even.layer2_st.i_layer3_sram.Memory[memory_even_even]);
					FAIL_FLAG=1;
				end
				memory_even_even++;
			end
			else if (row_even==0&&col_even==1)
			begin
				if(result_reg2==TOP.layer2_data_mem_even_odd.layer2_st.i_layer3_sram.Memory[memory_even_odd])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg2);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg2,TOP.layer2_data_mem_even_odd.layer2_st.i_layer3_sram.Memory[memory_even_odd]);
					FAIL_FLAG=1;
				end
				memory_even_odd++;
			end
			else if (row_even==1&&col_even==0)
			begin
				if(result_reg2==TOP.layer2_data_mem_odd_even.layer2_st.i_layer3_sram.Memory[memory_odd_even])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg2);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg2,TOP.layer2_data_mem_odd_even.layer2_st.i_layer3_sram.Memory[memory_odd_even]);
					FAIL_FLAG=1;
				end
				memory_odd_even++;
			end
			else if(row_even==1&&col_even==1)
			begin
				if(result_reg2==TOP.layer2_data_mem_odd_odd.layer2_st.i_layer3_sram.Memory[memory_odd_odd])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg2);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg2,TOP.layer2_data_mem_odd_odd.layer2_st.i_layer3_sram.Memory[memory_odd_odd]);
					FAIL_FLAG=1;
				end
				memory_odd_odd++;
			end
			if(col==`LAYER3_WIDTH-1)
			begin
				col=0;
				row=row+1;
			end
			else
			begin
				col=col+1;
			end
			
		end
		$fclose(fp_r);
		photo(.CORRECT_pass_count(`LAYER3_WIDTH**2),.REAL_pass_count(pass_count),.picture_num(picture_layer2),.STAGE("STAGE2"));
		//#(`CYCLE*10)
		/*
		if (picture_layer2==1)
		begin
			$finish;
		end
		*/
	
		
		picture_layer2++;	
	end
	////////////////////////////////////////////////////////////////////
	pass_count=0;
	if(STAGE3_COMPLETE)
	begin
		$display("PICTURE %d STAGE3_COMPLETE",picture_layer3);
		$display("%d",$time);
		row=0;
		col=0;
		memory_index=0;
		memory_even_even=0;
		memory_even_odd=0;
		memory_odd_even=0;
		memory_odd_odd=0;
		if(picture_layer3==1)
		begin
			fp_r = $fopen({data_path,`PIC1_GOLDEN_FILE_LAYER3},"r");
		end
		if(picture_layer3==2)
		begin
			fp_r = $fopen({data_path,`PIC2_GOLDEN_FILE_LAYER3},"r");
		end
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",result_reg3);			
			if(result_reg3==TOP.layer3_data_mem.layer3_st.i_layer3_sram.Memory[memory_index])
			begin
				pass_count=pass_count+1;
				$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg3);
			end
			else
			begin
				$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg3,TOP.layer3_data_mem.layer3_st.i_layer3_sram.Memory[memory_index]);
				FAIL_FLAG=1;
			end
			if(col==`LAYER4_WIDTH-1)
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
		photo(.CORRECT_pass_count(`LAYER4_WIDTH**2),.REAL_pass_count(pass_count),.picture_num(picture_layer3),.STAGE("STAGE3"));
		//#(`CYCLE*10)
		/*
		if (picture_layer3==1)
		begin
			$finish;
		end
		*/
		picture_layer3++;	
	end
	////////////////////////////////////////////////////////////////////
	pass_count=0;
	if(STAGE4_COMPLETE)
	begin
		$display("PICTURE %d STAGE4_COMPLETE",picture_layer4);
		$display("%d",$time);
		/*
		fp_w= $fopen(`RESULT_FILE, "w");
		for(int row=0;row<=`LAYER5_WIDTH-1;row++)
		begin
			for(int col=0;col<=`LAYER5_WIDTH-1;col++)
			begin
				$fwrite(fp_w,"%h",TOP.layer4_data_mem.layer4_results_mem[row][col]);
				if(col<27)
				begin
					$fwrite(fp_w,", ");				
				end
					
			end
			$fwrite(fp_w,"\n");
		end
		$fclose(fp_w);
		*/
		row=0;
		col=0;
		memory_index=0;
		memory_even_even=0;
		memory_even_odd=0;
		memory_odd_even=0;
		memory_odd_odd=0;
		if(picture_layer4==1)
		begin
			fp_r = $fopen({data_path,`PIC1_GOLDEN_FILE_LAYER4},"r");
		end
		if(picture_layer4==2)
		begin
			fp_r = $fopen({data_path,`PIC2_GOLDEN_FILE_LAYER4},"r");
		end
		while(!$feof(fp_r)) 
		begin

			cnt = $fscanf(fp_r, "%h",result_reg4);			
			if(result_reg4==TOP.layer4_data_mem.layer4_st.i_layer4_sram.Memory[memory_index])
			begin
				pass_count=pass_count+1;
				$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg4);
			end
			else
			begin
				$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg4,TOP.layer4_data_mem.layer4_st.i_layer4_sram.Memory[memory_index]);
				FAIL_FLAG=1;
			end
			if(col==`LAYER5_WIDTH-1)
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
		photo(.CORRECT_pass_count(`LAYER5_WIDTH**2),.REAL_pass_count(pass_count),.picture_num(picture_layer4),.STAGE("STAGE4"));
		//#(`CYCLE*10)
		/*
		if (picture_layer4==1)
		begin
			$finish;
		end
		*/
		picture_layer4++;	
	end
		////////////////////////////////////////////////////////////////////
	pass_count=0;

	if(STAGE5_COMPLETE)
	begin
		$display("PICTURE %d STAGE5_COMPLETE",picture_layer5);
		$display("%d",$time);
		memory_index=0;
		memory_even_even=0;
		memory_even_odd=0;
		memory_odd_even=0;
		memory_odd_odd=0;
		row_even=0;
		col_even=0;
		row=0;
		col=0;
		if(picture_layer5==1)
		begin
			fp_r = $fopen({data_path,`PIC1_GOLDEN_FILE_LAYER5},"r");
		end
		if(picture_layer5==2)
		begin
			fp_r = $fopen({data_path,`PIC2_GOLDEN_FILE_LAYER5},"r");
		end
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",result_reg5);
			row_even=row%2;
			col_even=col%2;
			if (row_even==0&&col_even==0)
			begin
				if(result_reg5==TOP.layer5_data_mem_even_even.layer5_results_mem[row>>1][col>>1])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg5);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg5,TOP.layer5_data_mem_even_even.layer5_results_mem[row>>1][col>>1]);
					FAIL_FLAG=1;
				end
			end
			else if (row_even==0&&col_even==1)
			begin
				if(result_reg5==TOP.layer5_data_mem_even_odd.layer5_results_mem[row>>1][col>>1])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg5);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg5,TOP.layer5_data_mem_even_odd.layer5_results_mem[row>>1][col>>1]);
					FAIL_FLAG=1;
				end
			end
			else if (row_even==1&&col_even==0)
			begin
				if(result_reg5==TOP.layer5_data_mem_odd_even.layer5_results_mem[row>>1][col>>1])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg5);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg5,TOP.layer5_data_mem_odd_even.layer5_results_mem[row>>1][col>>1]);
					FAIL_FLAG=1;
				end
			end
			else
			begin
				if(result_reg5==TOP.layer5_data_mem_odd_odd.layer5_results_mem[row>>1][col>>1])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg5);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg5,TOP.layer5_data_mem_odd_odd.layer5_results_mem[row>>1][col>>1]);
					FAIL_FLAG=1;
				end
			end
			if(col==`LAYER6_WIDTH-1)
			begin
				col=0;
				row=row+1;
			end
			else
			begin
				col=col+1;
			end
		end
		$fclose(fp_r);
		photo(.CORRECT_pass_count(`LAYER6_WIDTH**2),.REAL_pass_count(pass_count),.picture_num(picture_layer5),.STAGE("STAGE5"));
		//#(`CYCLE*10)
		/*
		if (picture_layer5==1)
		begin
			$finish;
		end
		*/
		picture_layer5++;	
	end
		////////////////////////////////////////////////////////////////////
	pass_count=0;
	if(STAGE6_COMPLETE)
	begin		
	/*
		fp_w= $fopen(`RESULT_FILE, "w");
		for(int row=0;row<=`LAYER7_WIDTH-1;row++)
		begin
			for(int col=0;col<=`LAYER7_WIDTH-1;col++)
			begin
				$fwrite(fp_w,"%h",TOP.layer6_data_mem.layer6_results_mem[row][col]);
				if(col<27)
				begin
					$fwrite(fp_w,", ");				
				end
					
			end
			$fwrite(fp_w,"\n");
		end
		$fclose(fp_w);
		*/
		row=0;
		col=0;
		if(picture_layer6==1)
		begin
			fp_r = $fopen({data_path,`PIC1_GOLDEN_FILE_LAYER6},"r");
		end
		if(picture_layer6==2)
		begin
			fp_r = $fopen({data_path,`PIC2_GOLDEN_FILE_LAYER6},"r");
		end
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",result_reg6);			
			if(result_reg6==TOP.layer6_data_mem.layer6_results_mem[row][col])
			begin
				pass_count=pass_count+1;
				$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg6);
			end
			else
			begin
				$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg6,TOP.layer6_data_mem.layer6_results_mem[row][col]);
				FAIL_FLAG=1;
			end
			if(col==`LAYER7_WIDTH-1)
			begin
				col=0;
				row=row+1;
			end
			else
			begin
				col=col+1;
			end
		end
		$fclose(fp_r);
		photo(.CORRECT_pass_count(`LAYER7_WIDTH**2),.REAL_pass_count(pass_count),.picture_num(picture_layer6),.STAGE("STAGE6"));
		/*
		if (picture_layer6==1)
		begin
			$finish;
		end
		*/
		picture_layer6++;	
	end
	pass_count=0;
	if(STAGE7_COMPLETE)
	begin		
		fp_w= $fopen(`RESULT_FILE, "w");
			$fwrite(fp_w,"%h",TOP.result_st_mem.result_mem_out);
		$fclose(fp_w);
		if(picture_layer7==1)
		begin
			fp_r = $fopen({data_path,`PIC1_GOLDEN_FILE_LAYER7},"r");
		end
		if(picture_layer7==2)
		begin
			fp_r = $fopen({data_path,`PIC2_GOLDEN_FILE_LAYER7},"r");
		end
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",result_reg7);			
			if(result_reg7==TOP.result_st_mem.result_mem_out)
			begin
				pass_count=pass_count+1;
				$display(" ANSWER:[ %h ] PASS",result_reg7);
			end
			else
			begin
				$display("CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",result_reg7,TOP.result_st_mem.result_mem_out);
				FAIL_FLAG=1;
			end
		end
		$fclose(fp_r);
		photo(.CORRECT_pass_count(1),.REAL_pass_count(pass_count),.picture_num(picture_layer7),.STAGE("STAGE7"));
		
		if (picture_layer7==1)
		begin
			$finish;
		end
		
		picture_layer7++;
		if(FAIL_FLAG)
		begin
			$finish;
		end
	end
`endif	
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
		if(TOP.interrupt_signal)
			begin
			araddr=32'hd000_0000;
			# (`CYCLE)
			if(TOP.rdata==32'h1111_1111)
			begin
				$display("INTERRUPT RESULT MATCH");
			end
			else
			begin
				$display("INTERRUPT RESULT MISMATCH ERROR");
			end
			//$finish;
		end
	endtask
	
endmodule


			/*
			if(result_reg2==TOP.layer2_data_mem.layer2_results_mem[row][col])
			begin
				pass_count=pass_count+1;
				$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg2);
			end
			else
			begin
				$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg2,TOP.layer2_data_mem.layer2_results_mem[row][col]);
				FAIL_FLAG=1;
			end
			*/
			/*
			if(result_reg2==TOP.layer2_data_mem_even_even.layer2_results_mem[row>>1][col>>1])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg2);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg2,TOP.layer2_data_mem_even_even.layer2_results_mem[row>>1][col>>1]);
					FAIL_FLAG=1;
				end
			end
			else if (row_even==0&&col_even==1)
			begin
				if(result_reg2==TOP.layer2_data_mem_even_odd.layer2_results_mem[row>>1][col>>1])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg2);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg2,TOP.layer2_data_mem_even_odd.layer2_results_mem[row>>1][col>>1]);
					FAIL_FLAG=1;
				end
			end
			else if (row_even==1&&col_even==0)
			begin
				if(result_reg2==TOP.layer2_data_mem_odd_even.layer2_results_mem[row>>1][col>>1])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg2);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg2,TOP.layer2_data_mem_odd_even.layer2_results_mem[row>>1][col>>1]);
					FAIL_FLAG=1;
				end
			end
			else
			begin
				if(result_reg2==TOP.layer2_data_mem_odd_odd.layer2_results_mem[row>>1][col>>1])
				begin
					pass_count=pass_count+1;
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ] PASS",row,col,result_reg2);
				end
				else
				begin
					$display("row[%4d]col[%4d] CORRECT ANSWER:[ %h ]YOUR ANSWER:[ %h ]",row,col,result_reg2,TOP.layer2_data_mem_odd_odd.layer2_results_mem[row>>1][col>>1]);
					FAIL_FLAG=1;
				end
			end
			if(col==`LAYER3_WIDTH-1)
			begin
				col=0;
				row=row+1;
			end
			else
			begin
				col=col+1;
			end
		end
		$fclose(fp_r);
		photo(.CORRECT_pass_count(`LAYER3_WIDTH**2),.REAL_pass_count(pass_count),.picture_num(picture_layer2),.STAGE("STAGE2"));
		//#(`CYCLE*10)
		if (picture_layer2==1)
		begin
			$finish;
		end
	
		
		picture_layer2++;	
	end
			*/
