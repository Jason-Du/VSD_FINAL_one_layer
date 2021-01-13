`timescale 1ns/10ps
`include"top_cnn.sv"
`define		MEM_PIXEL_FILE		"./cnn_layer1_data/pixel.data"
`define		MEM_WEIGHT_FILE		"./cnn_layer1_data/weight.data"
`define		MEM_BIAS_FILE		"./cnn_layer1_data/bias.data"
`define		GOLDEN_FILE		    "./cnn_layer1_data/CORRECT.data"
`define		RESULT_FILE		    "RESULT.csv"
`define MAX 50000
`define CYCLE 2.0
module layer1_cnn_tb;

logic	clk;
logic 	rst;
logic [47:0]mem_pixel_in[32][32];
logic [47:0]mem_weight_in[72];
logic [15:0]mem_bias_in[8];

logic [47:0] reg1;
logic [127:0]result_reg;
integer row=0;
integer col=0;
integer bias_num=0;
integer weight_num=0;
integer pass_count=0;
integer err=0;
integer fp_r, fp_w, cnt;
logic        cnndonesignal;
 top_cnn TOP(
    .clk(clk),
    .rst(rst),
	.cnndonesignal(cnndonesignal)
  );
initial begin
	fp_r = $fopen(`MEM_PIXEL_FILE, "r");
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",reg1);
			//$display("%h",reg1);
			mem_pixel_in[row][col]=reg1;
			if(col==31)
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
	fp_r = $fopen(`MEM_BIAS_FILE, "r");
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",reg1);
			//$display("%h",reg1);
			mem_bias_in[bias_num]=reg1;
			bias_num=bias_num+1;
		end
	$fclose(fp_r);
	fp_r = $fopen(`MEM_WEIGHT_FILE, "r");
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",reg1);
			//$display("%h",reg1);
			mem_weight_in[weight_num]=reg1;
			weight_num=weight_num+1;
		end
	$fclose(fp_r);
end
initial
begin
	clk   =1'b0;
	rst   =1'b1;
	for(int i = 0; i <=31; i++)
	begin
		for(int j = 0; j <=31; j++)
		begin
			TOP.mem_pixel_in[i][j]=mem_pixel_in[i][j];
		end
	end
	for(int i = 0; i <=71; i++)
	begin
		TOP.mem_weight_in[i]=mem_weight_in[i];
	end
	for(int i = 0; i <=7; i++)
	begin
		TOP.mem_bias_in[i]=mem_bias_in[i];
	end
	#(`CYCLE) rst=1'b0;
end
//Initialize
initial
begin
	$fsdbDumpfile("top_cnn.fsdb");
	$fsdbDumpvars("+struct", "+mda",TOP);
	
	#(`CYCLE*`MAX)
	$finish;
end
always
begin
	#(`CYCLE/2) clk = ~clk;
	if(cnndonesignal)
	begin
		fp_w= $fopen(`RESULT_FILE, "w");
		for(int row=0;row<=29;row++)
		begin
			for(int col=0;col<=29;col++)
			begin
				$fwrite(fp_w,"%h",TOP.mem_result[row][col]);
				if(col<29)
				begin
					$fwrite(fp_w,",");				
				end
					
			end
			$fwrite(fp_w,"\n");
		end
		$fclose(fp_w);
		
		row=0;
		col=0;
		
		fp_r = $fopen(`GOLDEN_FILE, "r");
		while(!$feof(fp_r)) 
		begin
			cnt = $fscanf(fp_r, "%h",result_reg);			
			if(result_reg==TOP.mem_result[row][col])
			begin
				pass_count=pass_count+1;
			end
			if(col==29)
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
		if (pass_count==900)
		begin
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
			err=900-pass_count;
			$display("\n");
			$display("\n");
			$display("        ****************************   ");
			$display("        **                        **   ");
			$display("        **  OOPS!!                **   ");
			$display("        **                        **   ");
			$display("        **  Simulation Failed!!   **   ");
			$display("        **                        **   ");
			$display("        ****************************   ");
			$display("                . .  ..                 ");
			$display("                  ':'                   ");
			$display("                ___:____     |//\//|   ");
			$display("              ,'        `.    \  /     ");
			$display("              |  O        \___/  |     ");
			$display("~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~");
			$display("         Totally has %d errors ", err); 
			$display("\n");
		end
		$finish;	
	end	
end
endmodule
/*
initial begin
	if(cnndonesignal)
	begin
		fp_w= $fopen(`RESULT_FILE, "w");
		for(int row=0;row<=31;row++)
		begin
			for(int col=0;col<=31;col++)
			begin
				$fwrite(fp_w,"%h",mem_pixel_in[row][col]);
				$fwrite(fp_w," ");
			end
			$fwrite(fp_w,"\n");
		end
		for(int row=0;row<=71;row++)
		begin
			$fwrite(fp_w,"%h",mem_weight_in[row]);
			$fwrite(fp_w,"\n");
		end
		for(int row=0;row<=7;row++)
		begin
			$fwrite(fp_w,"%h",mem_bias_in[row]);
			$fwrite(fp_w,"\n");
		end
			
		$fclose(fp_w);	
	end
end	
*/

