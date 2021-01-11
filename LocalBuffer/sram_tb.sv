`include "pixel_wrapper.sv"
`timescale 1ns/10ps
`define CYCLE      20.0
`define End_CYCLE  100000000

module sram_tb;

logic	clk = 1;
logic OEA,OEB;
logic [2:0] WEAN,WEBN; //active low
logic [9:0] A;
logic [9:0] B;
logic [47:0] DOA,DOB;
logic [47:0] DIA,DIB;

pixel_wrapper i_pixel_wrapper(
.CK(clk),
.OEA(OEA),
.OEB(1'b0),
.WEAN(3'b111),
.WEBN(WEBN),
.A(A),
.B(B),
.DOA(DOA),
.DOB(),
.DIA(),
.DIB(DIB)
);

always begin #(`CYCLE/2) clk = ~clk; end

initial begin
  $display("-----------------------------------------------------\n");
  $display("START!!! Simulation Start .....\n");
  $display("-----------------------------------------------------\n");
  $monitor($time,":DOA:%h,DOB:%h\n",DOA,DOB);

end
initial begin  
  WEAN=1'b1;DIA=48'h123;OEB=1'b0;
  
  OEA=1'b0; A=10'd0; 
  WEBN=3'b111; B=10'd1; DIB=48'h0;
  
  // Write addr 3 data 9ABC
  #(`CYCLE/2);
  OEA=1'b0; A=10'd2; 
  WEBN=3'b110; B=10'd3; DIB=48'h1234_5678_9ABC;

  #(`CYCLE);
  // #(`CYCLE/2);
  OEA=1'b0; A=10'd4; 
  WEBN=3'b111; B=10'd5; DIB=48'h1234;
  
  #(`CYCLE);
  OEA=1'b0; A=10'd4; 
  WEBN=3'b001; B=10'd3; DIB=48'h1234_5678_9ABC;
  
  // Read 
  #(`CYCLE);
  OEA=1'b1; A=10'd3; 
  WEBN=3'b111; B=10'd6; DIB=48'h1234;

  // no read no write
  #(`CYCLE);  
  OEA=1'b0; A=10'd0; 
  WEBN=3'b111; B=10'd1; DIB=48'h0;
/* 
  // write A
  #(`CYCLE);
  OEA=1'b0; WEAN=1'b0; A=10'd3103; DIA=48'h222;
  OEB=1'b0; WEBN=1'b1; B=10'd3102; DIB=48'h0;
  
  // write B
  #(`CYCLE);
  OEA=1'b0; WEAN=1'b1; A=10'd3103; DIA=48'h0; 
  OEB=1'b0; WEBN=1'b0; B=10'd3102; DIB=48'hfff;
  
  // write A and B
  #(`CYCLE);
  OEA=1'b0; WEAN=1'b0; A=10'd3101; DIA=48'h333; 
  OEB=1'b0; WEBN=1'b0; B=10'd3102; DIB=48'hfff;

  // read A and B
  #(`CYCLE);
  OEA=1'b1; WEAN=1'b1; A=10'd3101; DIA=48'h333; 
  OEB=1'b1; WEBN=1'b1; B=10'd3100; DIB=48'h444;  

  // read A and B
  #(`CYCLE);
  OEA=1'b0; WEAN=1'b1; A=10'd3103; DIA=48'h333; 
  OEB=1'b0; WEBN=1'b1; B=10'd3102; DIB=48'h444;  
  
  // read A and write B
  #(`CYCLE);
  OEA=1'b1; WEAN=1'b1; A=10'd3101; DIA=48'h999; 
  OEB=1'b0; WEBN=1'b0; B=10'd3100; DIB=48'h777;  
   */
  #(`CYCLE*10); $finish;
end

initial begin
  $fsdbDumpfile("sram_pos.fsdb");
  $fsdbDumpvars("+mda"); 
end
endmodule