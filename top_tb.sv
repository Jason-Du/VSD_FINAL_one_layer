`timescale 1ns/10ps
`include "top_rtl.sv"
`include "def.svh"
`include "counter_rtl.sv"
`define		MEM_PIXEL_FILE		"./top_data/pixel.data"
`define		MEM_WEIGHT_FILE		"./top_data/weight.data"
`define		MEM_BIAS_FILE		"./top_data/bias.data"
`define		PIC1_GOLDEN_FILE_LAYER1		"./top_data/PIC1_CORRECT_LAYER1.data"
`define		PIC1_GOLDEN_FILE_LAYER2		"./top_data/PIC1_CORRECT_LAYER2.data"
`define		PIC1_GOLDEN_FILE_LAYER3		"./top_data/PIC1_CORRECT_LAYER3.data"
`define		PIC2_GOLDEN_FILE_LAYER1	    "./top_data/PIC2_CORRECT_LAYER1.data"
`define		PIC2_GOLDEN_FILE_LAYER2		"./top_data/PIC2_CORRECT_LAYER2.data"
`define		PIC2_GOLDEN_FILE_LAYER3		"./top_data/PIC2_CORRECT_LAYER3.data"
`define		RESULT_FILE		    "RESULT.csv"
`define MAX 50000
`define CYCLE 2.0
module top_tb;

logic	clk;
logic 	rst;
logic [31:0]mem_pixel_in[3072*2];
logic [31:0]mem_weight_in[216+576];
logic [31:0]mem_bias_in[8+8];
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

top TOP(
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
	
	fp_r = $fopen(`MEM_PIXEL_FILE, "r");
		while(!$feof(fp_r)) 
		begin
			//$display("pixel_setting");
			cnt = $fscanf(fp_r, "%h",reg1);
			//$display("%h",reg1);
			mem_pixel_in[pic_num]={16'd0,reg1};
			pic_num++;
		end
	$fclose(fp_r);
	fp_r = $fopen(`MEM_BIAS_FILE, "r");
		while(!$feof(fp_r)) 
		begin
			//$display("bias_setting");
			cnt = $fscanf(fp_r, "%h",reg1);
			//$display("%h",reg1);
			mem_bias_in[bias_num]={16'd0,reg1};
			bias_num=bias_num+1;
		end
	$fclose(fp_r);
	fp_r = $fopen(`MEM_WEIGHT_FILE, "r");
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
	#(`CYCLE) rst   =1'b0;
end
initial
begin
	$fsdbDumpfile("top.fsdb");
	$fsdbDumpvars("+struct", "+mda",TOP);
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
logic STAGE1_COMPLETE;
logic STAGE2_COMPLETE;
logic STAGE3_COMPLETE;

localparam FEED_WEIGHT=3'b000;
localparam FEED_BIAS  =3'b001;
localparam FEED_PIXEL =3'b010;
counter weight_set_counter(
	.clk(clk),
	.rst(rst),
	.count(weight_set_count),
	.clear(weight_set_clear),
	.keep(1'd0)
);
counter weight_counter(
	.clk(clk),
	.rst(rst),
	.count(weight_count),
	.clear(1'd0),
	.keep(weight_keep)
);
counter bias_set_counter(
	.clk(clk),
	.rst(rst),
	.count(bias_set_count),
	.clear(bias_set_clear),
	.keep(1'd0)
);
counter bias_counter(
	.clk(clk),
	.rst(rst),
	.count(bias_count),
	.clear(1'd0),
	.keep(bias_keep)
);
counter pixel_set_counter(
	.clk(clk),
	.rst(rst),
	.count(pixel_set_count),
	.clear(pixel_set_clear),
	.keep(1'd0)
);
counter pixel_counter(
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
	case(cs)
		FEED_WEIGHT:
		begin
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
			if(weight_count==216+576)
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
			if(bias_count==8+8)
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
always_ff@(posedge clk)
begin
	if(rst)
	begin	
		STAGE1_COMPLETE<=0;
		STAGE2_COMPLETE<=0;
		STAGE3_COMPLETE<=0;
	end
	else
	begin
		STAGE1_COMPLETE<=TOP.layer1_calculation_done;
		STAGE2_COMPLETE<=TOP.layer2_calculation_done;
		STAGE3_COMPLETE<=TOP.layer3_calculation_done;
	end
end
integer picture_layer3=1;
integer picture_layer2=1;
integer picture_layer1=1;
always
begin
	#(`CYCLE/2) clk = ~clk;
end
always
begin
	#(`CYCLE);
	if(STAGE1_COMPLETE&&(picture_layer1<=2))
	begin
		$display("PICTURE %d STAGE1_COMPLETE",picture_layer1);
		$display("%d",$time);
		row=0;
		col=0;
		if(picture_layer1==1)
		begin
			fp_r = $fopen(`PIC1_GOLDEN_FILE_LAYER1, "r");
		end
		if(picture_layer1==2)
		begin
			fp_r = $fopen(`PIC2_GOLDEN_FILE_LAYER1, "r");
		end
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",result_reg1);			
			if(result_reg1==TOP.layer1_data_mem.layer1_results_mem[row][col])
			begin
				pass_count=pass_count+1;
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
		end
		$fclose(fp_r);
		if (pass_count==`LAYER2_WIDTH**2)
		begin
			$display("PICTURE %d STAGE1 IS PASS",picture_layer1);
			$display("%d PASS",pass_count);
			$display("\n");
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
			err=`LAYER2_WIDTH**2-pass_count;

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
		/*
		if (picture_layer1==2)
		begin
			$finish;
		end
		*/
		picture_layer1++;
		//$finish;	
	end
	////////////////////////////////////////////////////////////////////
	pass_count=0;
	if(STAGE2_COMPLETE)
	begin
		$display("PICTURE %d STAGE2_COMPLETE",picture_layer2);
		$display("%d",$time);
		
		row=0;
		col=0;
		if(picture_layer2==1)
		begin
			fp_r = $fopen(`PIC1_GOLDEN_FILE_LAYER2,"r");
		end
		if(picture_layer2==2)
		begin
			fp_r = $fopen(`PIC2_GOLDEN_FILE_LAYER2,"r");
		end
		
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",result_reg2);			
			if(result_reg2==TOP.layer2_data_mem.layer2_results_mem[row][col])
			begin
				pass_count=pass_count+1;
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
		if (pass_count==`LAYER3_WIDTH**2)
		begin
			$display("%d PASS",pass_count);
			$display("PICTURE %d STAGE2 IS PASS",picture_layer2);
			$display("\n");
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
			err=`LAYER3_WIDTH**2-pass_count;

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
		//#(`CYCLE*10)
		/*
		if (picture_layer2==2)
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
		fp_w= $fopen(`RESULT_FILE, "w");
		for(int row=0;row<=13;row++)
		begin
			for(int col=0;col<=13;col++)
			begin
				$fwrite(fp_w,"%h",TOP.layer3_data_mem.layer3_results_mem[row][col]);
				if(col<27)
				begin
					$fwrite(fp_w,", ");				
				end
					
			end
			$fwrite(fp_w,"\n");
		end
		$fclose(fp_w);
		row=0;
		col=0;
		if(picture_layer3==1)
		begin
			fp_r = $fopen(`PIC1_GOLDEN_FILE_LAYER3,"r");
		end
		if(picture_layer3==2)
		begin
			fp_r = $fopen(`PIC2_GOLDEN_FILE_LAYER3,"r");
		end
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",result_reg3);			
			if(result_reg3==TOP.layer3_data_mem.layer3_results_mem[row][col])
			begin
				pass_count=pass_count+1;
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
		end
		$fclose(fp_r);
		if (pass_count==`LAYER4_WIDTH**2)
		begin
			$display("%d PASS",pass_count);
			$display("PICTURE %d STAGE3 IS PASS",picture_layer3);
			$display("\n");
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
			err=`LAYER4_WIDTH**2-pass_count;

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
		//#(`CYCLE*10)
		if (picture_layer3==2)
		begin
			$finish;
		end
		picture_layer3++;	
	end
	////////////////////////////////////////////////////////////////////INTERRUPT_TEST
	/*
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
	*/
end
endmodule
/*

*/




