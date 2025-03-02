`ifndef DEF_SVH
`define DEF_SVH

`define WORDLENGTH 16
`define MAXIMUM_OUTPUT_CHANNEL 8
`define MAXIMUM_OUTPUT_LENGTH `MAXIMUM_OUTPUT_CHANNEL*`WORDLENGTH
`define KERNEL_SIZE 3*3
`define PICTURE_CHANNEL 3

`define LAYER1_WIDTH 32
`define LAYER1_READ_PIXEL_COUNT_COL_END `WORDLENGTH'd31//32-1
`define LAYER1_BUFFER_LENGTH `WORDLENGTH'd29//32-3
`define LAYER1_SET_COUNT `WORDLENGTH'd67//32*2+3-1+1+3
`define LAYER1_OUTPUT_LENGTH `LAYER1_OUTPUT_CHANNEL_NUM*`WORDLENGTH
`define LAYER1_WEIGHT_INPUT_LENGTH 48
`define LAYER1_WEIGHT_SET_COUNT `WORDLENGTH'd73//LAYER1_SYSTOLIC_WEIGHT_NUM SRAM:72+1
`define LAYER1_OUTPUT_CHANNEL_NUM 8
`define LAYER1_SYSTOLIC_WEIGHT_NUM `LAYER1_OUTPUT_CHANNEL_NUM*9
`define LAYER1_PIPELINE_ROW `WORDLENGTH'd1//
`define LAYER1_PIPELINE_COL `WORDLENGTH'd27///30-4+  2 prevent same address and read delay 1 cycle

`define LAYER2_WIDTH 30
`define LAYER2_READ_PIXEL_COUNT_COL_END `WORDLENGTH'd29//30-1
`define LAYER2_BUFFER_LENGTH `WORDLENGTH'd27//30-3
`define LAYER2_SET_COUNT `WORDLENGTH'd63//`LAYER2_WIDTH*2+3-1+1//SRAM+1SRAM_REG
`define LAYER2_OUTPUT_LENGTH `LAYER2_OUTPUT_CHANNEL_NUM*`WORDLENGTH
`define LAYER2_WEIGHT_INPUT_LENGTH 128//`LAYER1_OUTPUT_LENGTH
`define LAYER2_WEIGHT_SET_COUNT `WORDLENGTH'd73//LAYER2_SYSTOLIC_WEIGHT_NUM//SRAM:72+1+
`define LAYER2_OUTPUT_CHANNEL_NUM 8
`define LAYER2_SYSTOLIC_WEIGHT_NUM `LAYER2_OUTPUT_CHANNEL_NUM*9
`define LAYER2_PIPELINE_ROW `WORDLENGTH'd21
`define LAYER2_PIPELINE_COL `WORDLENGTH'd13//13
`define LAYER2_PIPELINE_ROW_VALUE `LAYER3_WIDTH-((`LAYER4_WIDTH**2-`LAYER4_WIDTH)/`LAYER3_WIDTH)-1
`define LAYER2_PIPELINE_COL_VALUE `LAYER3_WIDTH-((`LAYER4_WIDTH**2-`LAYER4_WIDTH)%`LAYER3_WIDTH)-1

`define LAYER3_WIDTH 28
`define LAYER3_READ_PIXEL_COUNT_COL_END `WORDLENGTH'd13//LAYER4_WIDTH-1
`define LAYER3_SET_COUNT `LAYER3_WIDTH*1+2-1 //for no SRAM VERSION
`define LAYER3_OUTPUT_LENGTH `LAYER3_OUTPUT_CHANNEL_NUM*`WORDLENGTH
`define LAYER3_WEIGHT_INPUT_LENGTH 128//`LAYER2_OUTPUT_LENGTH
`define LAYER3_OUTPUT_CHANNEL_NUM 8


`define LAYER4_WIDTH 14
`define LAYER4_READ_PIXEL_COUNT_COL_END `WORDLENGTH'd13//LAYER4_WIDTH-1
`define LAYER4_BUFFER_LENGTH `WORDLENGTH'd11//14-3
`define LAYER4_SET_COUNT `WORDLENGTH'd31//`LAYER4_WIDTH*2+3-1+1//SRAM
`define LAYER4_OUTPUT_LENGTH `LAYER4_OUTPUT_CHANNEL_NUM*`WORDLENGTH
`define LAYER4_WEIGHT_INPUT_LENGTH 128//`LAYER3_OUTPUT_LENGTH
`define LAYER4_WEIGHT_SET_COUNT `WORDLENGTH'd73//LAYER4_SYSTOLIC_WEIGHT_NUM//SRAM:72+1
`define LAYER4_OUTPUT_CHANNEL_NUM 8
`define LAYER4_SYSTOLIC_WEIGHT_NUM `LAYER4_OUTPUT_CHANNEL_NUM*9
`define LAYER4_PIPELINE_ROW `WORDLENGTH'd1//1
`define LAYER4_PIPELINE_COL `WORDLENGTH'd10//`LAYER5_WIDTH-4+2


`define LAYER5_WIDTH 12
`define LAYER5_READ_PIXEL_COUNT_COL_END `WORDLENGTH'd11//12-1
`define LAYER5_BUFFER_LENGTH `WORDLENGTH'd9//12-3
`define LAYER5_SET_COUNT `WORDLENGTH'd27//`LAYER5_WIDTH*2+3-1+1//SRAM
`define LAYER5_OUTPUT_LENGTH `LAYER5_OUTPUT_CHANNEL_NUM*`WORDLENGTH
`define LAYER5_WEIGHT_INPUT_LENGTH 128//`LAYER4_OUTPUT_LENGTH
`define LAYER5_OUTPUT_CHANNEL_NUM 8
`define LAYER5_SYSTOLIC_WEIGHT_NUM `LAYER5_OUTPUT_CHANNEL_NUM*9
`define LAYER5_WEIGHT_SET_COUNT `WORDLENGTH'd73//LAYER5_SYSTOLIC_WEIGHT_NUM//SRAM:72+1
`define LAYER5_PIPELINE_ROW `WORDLENGTH'd7
`define LAYER5_PIPELINE_COL `WORDLENGTH'd9
`define LAYER5_PIPELINE_ROW_VALUE`LAYER6_WIDTH-((`LAYER7_WIDTH**2-`LAYER7_WIDTH)/`LAYER6_WIDTH)-1
`define LAYER5_PIPELINE_COL_VALUE `LAYER6_WIDTH-((`LAYER7_WIDTH**2-`LAYER7_WIDTH)%`LAYER6_WIDTH)-1

//______________________________________SRAM only in layer1~layer4 mem

`define LAYER6_WIDTH 10
`define LAYER6_READ_PIXEL_COUNT_COL_END `WORDLENGTH'd4//LAYER7-1
`define LAYER6_SET_COUNT `LAYER6_WIDTH*1+2-1 
`define LAYER6_OUTPUT_LENGTH `LAYER6_OUTPUT_CHANNEL_NUM*`WORDLENGTH
`define LAYER6_WEIGHT_INPUT_LENGTH 128//`LAYER5_OUTPUT_LENGTH
`define LAYER6_OUTPUT_CHANNEL_NUM 8


`define LAYER7_WIDTH 5
`define LAYER7_READ_PIXEL_COUNT_COL_END `WORDLENGTH'd4//LAYER7-1
`define LAYER7_SET_COUNT 16'd26//`LAYER7_WIDTH**2 +1//SRAM
`define LAYER7_OUTPUT_LENGTH `LAYER7_OUTPUT_CHANNEL_NUM*`WORDLENGTH
`define LAYER7_WEIGHT_INPUT_LENGTH 128//`LAYER6_OUTPUT_LENGTH
`define LAYER7_OUTPUT_CHANNEL_NUM 10

`endif




