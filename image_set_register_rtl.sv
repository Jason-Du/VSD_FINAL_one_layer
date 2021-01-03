`timescale 1ns/10ps
module image_set_register(
	clk,
	rst,
	write_data,
	write_signal,
	
	setting_done_condition
);
input clk;
input rst;
input [1:0] write_data;
input write_signal;

output logic [1:0]setting_done_condition;

logic [1:0]setting_done_condition_register_in;

always_ff@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		setting_done_condition<=1'b0;
	end
	else
	begin
		setting_done_condition<=setting_done_condition_register_in;
	end	
end
always_comb
begin
	if (write_signal)
	begin
		setting_done_condition_register_in=write_data;
	end
	else
	begin
		setting_done_condition_register_in=setting_done_condition;
	end
end
endmodule