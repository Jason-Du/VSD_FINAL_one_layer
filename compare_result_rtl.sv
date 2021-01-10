`timescale 1ns/10ps
module compare_result(
	input_data,
	
	compare_result
);
input        [159:0] input_data;
output logic [31:0]compare_result;

logic signed [15:0] data1;
logic signed [15:0] data2;
logic signed [15:0] data3;
logic signed [15:0] data4;
logic signed [15:0] data5;
logic signed [15:0] data6;
logic signed [15:0] data7;
logic signed [15:0] data8;
logic signed [15:0] data9;


always_comb
begin
	data1=(signed'(input_data[159:144])>=signed'(input_data[143:128]))?input_data[159:144]:input_data[143:128];
	data2=(signed'(input_data[127:112])>=signed'(input_data[111:96]))?input_data[127:112]:input_data[111:96];
	data3=(signed'(input_data[95:80])>=signed'(input_data[79:64]))?input_data[95:80]:input_data[79:64];
	data4=(signed'(input_data[63:48])>=signed'(input_data[47:32]))?input_data[63:48]:input_data[47:32];
	data5=(signed'(input_data[31:16])>=signed'(input_data[15:0]))?input_data[31:16]:input_data[15:0];
	data6=(signed'(data1)>=signed'(data2))?data1:data2;
	data7=(signed'(data3)>=signed'(data4))?data3:data4;
	data8=(signed'(data6)>=signed'(data7))?data6:data7;
	data9=(signed'(data8)>=signed'(data5))?data8:data5;
	case(data9)
		input_data[159:144]:
		begin
			compare_result=32'd10;
		end
		input_data[143:128]:
		begin
			compare_result=32'd9;
		end
		input_data[127:112]:
		begin
			compare_result=32'd8;
		end
		input_data[111:96]:
		begin
			compare_result=32'd7;
		end
		input_data[95:80]:
		begin
			compare_result=32'd6;
		end
		input_data[79:64]:
		begin
			compare_result=32'd5;
		end
		input_data[63:48]:
		begin
			compare_result=32'd4;
		end
		input_data[47:32]:
		begin
			compare_result=32'd3;
		end
		input_data[31:16]:
		begin
			compare_result=32'd2;
		end
		input_data[15:0]:
		begin
			compare_result=32'd1;
		end
		default:
		begin
			compare_result=32'd0;
		end
	endcase
end


endmodule