module interrupt_register(
	clk,
	rst,
	write_signal,
	write_data,
	interrupt_signal
);
input clk;
input rst;
input write_data;
output logic interrupt_signal;

logic interrupt_signal_register_in;

always_ff@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		interrupt_signal<=1'b0;
	end
	else
	begin
		interrupt_signal<=interrupt_signal_register_in;
	end
end
always_comb
begin
	if (write_data)
	begin
		interrupt_signal_register_in=write_data;
	end
	else
	begin
		interrupt_signal_register_in=interrupt_signal;
	end
end