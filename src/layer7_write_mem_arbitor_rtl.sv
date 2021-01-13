`timescale 1ns/10ps
module layer7_write_mem_arbitor(
	layer7_write_sel,
	layer7_write_signal,
	
	layer7_mem1_write,
	layer7_mem2_write,
	layer7_mem3_write,
	layer7_mem4_write,
	layer7_mem5_write
);

	input [2:0] layer7_write_sel;
	input       layer7_write_signal;
	
	output logic layer7_mem1_write;
	output logic layer7_mem2_write;
	output logic layer7_mem3_write;
	output logic layer7_mem4_write;
	output logic layer7_mem5_write;
	
	
	always_comb
	begin
		case(layer7_write_sel)
		3'd1:
		begin
			layer7_mem1_write=layer7_write_signal?1'b1:1'b0;
			layer7_mem2_write=1'b0;
			layer7_mem3_write=1'b0;
			layer7_mem4_write=1'b0;
			layer7_mem5_write=1'b0;
		end
		3'd2:
		begin
			layer7_mem1_write=1'b0;
			layer7_mem2_write=layer7_write_signal?1'b1:1'b0;
			layer7_mem3_write=1'b0;
			layer7_mem4_write=1'b0;
			layer7_mem5_write=1'b0;
			
		end
		3'd3:
		begin
			layer7_mem1_write=1'b0;
			layer7_mem2_write=1'b0;
			layer7_mem3_write=layer7_write_signal?1'b1:1'b0;
			layer7_mem4_write=1'b0;
			layer7_mem5_write=1'b0;			
		end
		3'd4:
		begin
			layer7_mem1_write=1'b0;
			layer7_mem2_write=1'b0;
			layer7_mem3_write=1'b0;
			layer7_mem4_write=layer7_write_signal?1'b1:1'b0;
			layer7_mem5_write=1'b0;		
		end
		3'd5:
		begin
			layer7_mem1_write=1'b0;
			layer7_mem2_write=1'b0;
			layer7_mem3_write=1'b0;
			layer7_mem4_write=1'b0;
			layer7_mem5_write=layer7_write_signal?1'b1:1'b0;		
		end
		default:
		begin
			layer7_mem1_write=1'b0;
			layer7_mem2_write=1'b0;
			layer7_mem3_write=1'b0;
			layer7_mem4_write=1'b0;
			layer7_mem5_write=1'b0;
			
		end
		endcase
	end
	endmodule