read_file -autoread -top cnn {../src ../include ../LocalBuffer}
current_design cnn
link
uniquify

source ../script/DC.sdc

compile
write_file -format verilog -hier -output ../syn/cnn_syn.v
write_sdf -version 2.1 -context verilog -load_delay net ../syn/cnn_syn.sdf
report_timing

