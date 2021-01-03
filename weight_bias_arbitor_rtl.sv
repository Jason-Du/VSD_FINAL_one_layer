module weight_bias_arbitor(
	weight_sel,
	bias_sel,
	layer1_read_weight_signal,
	layer2_read_weight_signal,
	layer1_read_bias_signal,
	layer2_read_bias_signal,
	layer1_read_weight_addr,
	layer2_read_weight_addr,
	layer1_read_bias_addr,
	layer2_read_bias_addr,
	//INOUT
	read_weight_signal_data,
	read_weight_addr_data,
	read_bias_signal_data,
	read_bias_addr_data
);

input [4:0] weight_sel;
input [4:0] bias_sel;
input layer1_read_bias_signal;
input layer2_read_bias_signal;
input layer1_read_weight_signal;
input layer2_read_weight_signal;
input [15:0] layer1_read_bias_addr;
input [15:0] layer2_read_bias_addr;
input [15:0] layer1_read_weight_addr;
input [15:0] layer2_read_weight_addr;

output logic read_weight_signal_data;
output logic [15:0] read_weight_addr_data;
output logic read_bias_signal_data;
output logic [15:0] read_bias_addr_data;
always_comb
begin
	if(weight_sel==5'd1)
	begin
		read_weight_addr_data=layer1_read_weight_addr;
		read_weight_signal_data=layer1_read_weight_signal;
	end
	else if(weight_sel==5'd2)
	begin
		read_weight_addr_data=layer2_read_weight_addr;
		read_weight_signal_data=layer2_read_weight_signal;
	end
	else
	begin
		read_weight_addr_data=16'd0;
		read_weight_signal_data=1'd0;
	end
end
always_comb
begin
	if(bias_sel==5'd1)
	begin
		read_bias_addr_data=layer1_read_bias_addr;
		read_bias_signal_data=layer1_read_bias_signal;
	end
	else if(bias_sel==5'd2)
	begin
		read_bias_addr_data=layer2_read_bias_addr;
		read_bias_signal_data=layer2_read_bias_signal;
	end
	else
	begin
		read_bias_addr_data=16'd0;
		read_bias_signal_data=1'd0;
	end
end
endmodule
