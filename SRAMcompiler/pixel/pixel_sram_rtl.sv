module pixel_sram (A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,
                   B6,B7,B8,B9,DOA0,DOA1,DOA2,DOA3,DOA4,DOA5,DOA6,
                   DOA7,DOA8,DOA9,DOA10,DOA11,DOA12,DOA13,
                   DOA14,DOA15,DOA16,DOA17,DOA18,DOA19,DOA20,
                   DOA21,DOA22,DOA23,DOA24,DOA25,DOA26,DOA27,
                   DOA28,DOA29,DOA30,DOA31,DOA32,DOA33,DOA34,
                   DOA35,DOA36,DOA37,DOA38,DOA39,DOA40,DOA41,
                   DOA42,DOA43,DOA44,DOA45,DOA46,DOA47,DOB0,
                   DOB1,DOB2,DOB3,DOB4,DOB5,DOB6,DOB7,DOB8,
                   DOB9,DOB10,DOB11,DOB12,DOB13,DOB14,DOB15,
                   DOB16,DOB17,DOB18,DOB19,DOB20,DOB21,DOB22,
                   DOB23,DOB24,DOB25,DOB26,DOB27,DOB28,DOB29,
                   DOB30,DOB31,DOB32,DOB33,DOB34,DOB35,DOB36,
                   DOB37,DOB38,DOB39,DOB40,DOB41,DOB42,DOB43,
                   DOB44,DOB45,DOB46,DOB47,DIA0,DIA1,DIA2,
                   DIA3,DIA4,DIA5,DIA6,DIA7,DIA8,DIA9,DIA10,
                   DIA11,DIA12,DIA13,DIA14,DIA15,DIA16,DIA17,
                   DIA18,DIA19,DIA20,DIA21,DIA22,DIA23,DIA24,
                   DIA25,DIA26,DIA27,DIA28,DIA29,DIA30,DIA31,
                   DIA32,DIA33,DIA34,DIA35,DIA36,DIA37,DIA38,
                   DIA39,DIA40,DIA41,DIA42,DIA43,DIA44,DIA45,
                   DIA46,DIA47,DIB0,DIB1,DIB2,DIB3,DIB4,
                   DIB5,DIB6,DIB7,DIB8,DIB9,DIB10,DIB11,DIB12,
                   DIB13,DIB14,DIB15,DIB16,DIB17,DIB18,DIB19,
                   DIB20,DIB21,DIB22,DIB23,DIB24,DIB25,DIB26,
                   DIB27,DIB28,DIB29,DIB30,DIB31,DIB32,DIB33,
                   DIB34,DIB35,DIB36,DIB37,DIB38,DIB39,DIB40,
                   DIB41,DIB42,DIB43,DIB44,DIB45,DIB46,DIB47,
                   WEAN0,WEAN1,WEAN2,WEBN0,WEBN1,WEBN2,CKA,CKB,CSA,CSB,OEA,OEB);
 
  output     DOA0,DOA1,DOA2,DOA3,DOA4,DOA5,DOA6,DOA7,DOA8,
             DOA9,DOA10,DOA11,DOA12,DOA13,DOA14,DOA15,DOA16,DOA17,DOA18,
             DOA19,DOA20,DOA21,DOA22,DOA23,DOA24,DOA25,DOA26,DOA27,DOA28,
             DOA29,DOA30,DOA31,DOA32,DOA33,DOA34,DOA35,DOA36,DOA37,DOA38,
             DOA39,DOA40,DOA41,DOA42,DOA43,DOA44,DOA45,DOA46,DOA47;
  output     DOB0,DOB1,DOB2,DOB3,DOB4,DOB5,DOB6,DOB7,DOB8,
             DOB9,DOB10,DOB11,DOB12,DOB13,DOB14,DOB15,DOB16,DOB17,DOB18,
             DOB19,DOB20,DOB21,DOB22,DOB23,DOB24,DOB25,DOB26,DOB27,DOB28,
             DOB29,DOB30,DOB31,DOB32,DOB33,DOB34,DOB35,DOB36,DOB37,DOB38,
             DOB39,DOB40,DOB41,DOB42,DOB43,DOB44,DOB45,DOB46,DOB47;
  input      DIA0,DIA1,DIA2,DIA3,DIA4,DIA5,DIA6,DIA7,DIA8,
             DIA9,DIA10,DIA11,DIA12,DIA13,DIA14,DIA15,DIA16,DIA17,DIA18,
             DIA19,DIA20,DIA21,DIA22,DIA23,DIA24,DIA25,DIA26,DIA27,DIA28,
             DIA29,DIA30,DIA31,DIA32,DIA33,DIA34,DIA35,DIA36,DIA37,DIA38,
             DIA39,DIA40,DIA41,DIA42,DIA43,DIA44,DIA45,DIA46,DIA47;
  input      DIB0,DIB1,DIB2,DIB3,DIB4,DIB5,DIB6,DIB7,DIB8,
             DIB9,DIB10,DIB11,DIB12,DIB13,DIB14,DIB15,DIB16,DIB17,DIB18,
             DIB19,DIB20,DIB21,DIB22,DIB23,DIB24,DIB25,DIB26,DIB27,DIB28,
             DIB29,DIB30,DIB31,DIB32,DIB33,DIB34,DIB35,DIB36,DIB37,DIB38,
             DIB39,DIB40,DIB41,DIB42,DIB43,DIB44,DIB45,DIB46,DIB47;
  input      A0,A1,A2,A3,A4,A5,A6,A7,A8,
             A9;
  input      B0,B1,B2,B3,B4,B5,B6,B7,B8,
             B9;
  parameter  AddressSize          = 10;               
  parameter  Bits                 = 16;               
  parameter  Words                = 1024;             
  parameter  Bytes                = 3;    
  
  input      OEA;                                     
  input      OEB;                                     
  input      WEAN0;                                   
  input      WEAN1;                                   
  input      WEAN2;                                   
  input      WEBN0;                                   
  input      WEBN1;                                   
  input      WEBN2;                                   
  input      CKA;                                     
  input      CKB;                                     
  input      CSA;                                     
  input      CSB; 
  logic        [Bits-1:0]           Memory_byte0 [Words-1:0];     
  logic        [Bits-1:0]           Memory_byte1 [Words-1:0];     
  logic        [Bits-1:0]           Memory_byte2 [Words-1:0];     
  logic      [Bytes*Bits-1:0]     DIA;  
  logic      [Bytes*Bits-1:0]     DIB;    
  logic      [Bytes*Bits-1:0]     DOA; 
  logic      [Bytes*Bits-1:0]     DOB;   
  logic      [Bytes*Bits-1:0]     latched_DOA;
  logic      [Bytes*Bits-1:0]     latched_DOB;        
  logic      [AddressSize-1:0]    A;
  logic      [AddressSize-1:0]    B;

  assign     DOA0                  = DOA[0];
  assign     DOA1                  = DOA[1];
  assign     DOA2                  = DOA[2];
  assign     DOA3                  = DOA[3];
  assign     DOA4                  = DOA[4];
  assign     DOA5                  = DOA[5];
  assign     DOA6                  = DOA[6];
  assign     DOA7                  = DOA[7];
  assign     DOA8                  = DOA[8];
  assign     DOA9                  = DOA[9];
  assign     DOA10                 = DOA[10];
  assign     DOA11                 = DOA[11];
  assign     DOA12                 = DOA[12];
  assign     DOA13                 = DOA[13];
  assign     DOA14                 = DOA[14];
  assign     DOA15                 = DOA[15];
  assign     DOA16                 = DOA[16];
  assign     DOA17                 = DOA[17];
  assign     DOA18                 = DOA[18];
  assign     DOA19                 = DOA[19];
  assign     DOA20                 = DOA[20];
  assign     DOA21                 = DOA[21];
  assign     DOA22                 = DOA[22];
  assign     DOA23                 = DOA[23];
  assign     DOA24                 = DOA[24];
  assign     DOA25                 = DOA[25];
  assign     DOA26                 = DOA[26];
  assign     DOA27                 = DOA[27];
  assign     DOA28                 = DOA[28];
  assign     DOA29                 = DOA[29];
  assign     DOA30                 = DOA[30];
  assign     DOA31                 = DOA[31];
  assign     DOA32                 = DOA[32];
  assign     DOA33                 = DOA[33];
  assign     DOA34                 = DOA[34];
  assign     DOA35                 = DOA[35];
  assign     DOA36                 = DOA[36];
  assign     DOA37                 = DOA[37];
  assign     DOA38                 = DOA[38];
  assign     DOA39                 = DOA[39];
  assign     DOA40                 = DOA[40];
  assign     DOA41                 = DOA[41];
  assign     DOA42                 = DOA[42];
  assign     DOA43                 = DOA[43];
  assign     DOA44                 = DOA[44];
  assign     DOA45                 = DOA[45];
  assign     DOA46                 = DOA[46];
  assign     DOA47                 = DOA[47];

  assign     DOB0                  = DOB[0];
  assign     DOB1                  = DOB[1];
  assign     DOB2                  = DOB[2];
  assign     DOB3                  = DOB[3];
  assign     DOB4                  = DOB[4];
  assign     DOB5                  = DOB[5];
  assign     DOB6                  = DOB[6];
  assign     DOB7                  = DOB[7];
  assign     DOB8                  = DOB[8];
  assign     DOB9                  = DOB[9];
  assign     DOB10                 = DOB[10];
  assign     DOB11                 = DOB[11];
  assign     DOB12                 = DOB[12];
  assign     DOB13                 = DOB[13];
  assign     DOB14                 = DOB[14];
  assign     DOB15                 = DOB[15];
  assign     DOB16                 = DOB[16];
  assign     DOB17                 = DOB[17];
  assign     DOB18                 = DOB[18];
  assign     DOB19                 = DOB[19];
  assign     DOB20                 = DOB[20];
  assign     DOB21                 = DOB[21];
  assign     DOB22                 = DOB[22];
  assign     DOB23                 = DOB[23];
  assign     DOB24                 = DOB[24];
  assign     DOB25                 = DOB[25];
  assign     DOB26                 = DOB[26];
  assign     DOB27                 = DOB[27];
  assign     DOB28                 = DOB[28];
  assign     DOB29                 = DOB[29];
  assign     DOB30                 = DOB[30];
  assign     DOB31                 = DOB[31];
  assign     DOB32                 = DOB[32];
  assign     DOB33                 = DOB[33];
  assign     DOB34                 = DOB[34];
  assign     DOB35                 = DOB[35];
  assign     DOB36                 = DOB[36];
  assign     DOB37                 = DOB[37];
  assign     DOB38                 = DOB[38];
  assign     DOB39                 = DOB[39];
  assign     DOB40                 = DOB[40];
  assign     DOB41                 = DOB[41];
  assign     DOB42                 = DOB[42];
  assign     DOB43                 = DOB[43];
  assign     DOB44                 = DOB[44];
  assign     DOB45                 = DOB[45];
  assign     DOB46                 = DOB[46];
  assign     DOB47                 = DOB[47];

  
  
  
  assign     DIA[0]                  = DIA0;
  assign     DIA[1]                  = DIA1;
  assign     DIA[2]                  = DIA2;
  assign     DIA[3]                  = DIA3;
  assign     DIA[4]                  = DIA4;
  assign     DIA[5]                  = DIA5;
  assign     DIA[6]                  = DIA6;
  assign     DIA[7]                  = DIA7;
  assign     DIA[8]                  = DIA8;
  assign     DIA[9]                  = DIA9;
  assign     DIA[10]                 = DIA10;
  assign     DIA[11]                 = DIA11;
  assign     DIA[12]                 = DIA12;
  assign     DIA[13]                 = DIA13;
  assign     DIA[14]                 = DIA14;
  assign     DIA[15]                 = DIA15;
  assign     DIA[16]                 = DIA16;
  assign     DIA[17]                 = DIA17;
  assign     DIA[18]                 = DIA18;
  assign     DIA[19]                 = DIA19;
  assign     DIA[20]                 = DIA20;
  assign     DIA[21]                 = DIA21;
  assign     DIA[22]                 = DIA22;
  assign     DIA[23]                 = DIA23;
  assign     DIA[24]                 = DIA24;
  assign     DIA[25]                 = DIA25;
  assign     DIA[26]                 = DIA26;
  assign     DIA[27]                 = DIA27;
  assign     DIA[28]                 = DIA28;
  assign     DIA[29]                 = DIA29;
  assign     DIA[30]                 = DIA30;
  assign     DIA[31]                 = DIA31;
  assign     DIA[32]                 = DIA32;
  assign     DIA[33]                 = DIA33;
  assign     DIA[34]                 = DIA34;
  assign     DIA[35]                 = DIA35;
  assign     DIA[36]                 = DIA36;
  assign     DIA[37]                 = DIA37;
  assign     DIA[38]                 = DIA38;
  assign     DIA[39]                 = DIA39;
  assign     DIA[40]                 = DIA40;
  assign     DIA[41]                 = DIA41;
  assign     DIA[42]                 = DIA42;
  assign     DIA[43]                 = DIA43;
  assign     DIA[44]                 = DIA44;
  assign     DIA[45]                 = DIA45;
  assign     DIA[46]                 = DIA46;
  assign     DIA[47]                 = DIA47;

  
  assign     DIB[0]                  = DIB0;
  assign     DIB[1]                  = DIB1;
  assign     DIB[2]                  = DIB2;
  assign     DIB[3]                  = DIB3;
  assign     DIB[4]                  = DIB4;
  assign     DIB[5]                  = DIB5;
  assign     DIB[6]                  = DIB6;
  assign     DIB[7]                  = DIB7;
  assign     DIB[8]                  = DIB8;
  assign     DIB[9]                  = DIB9;
  assign     DIB[10]                 = DIB10;
  assign     DIB[11]                 = DIB11;
  assign     DIB[12]                 = DIB12;
  assign     DIB[13]                 = DIB13;
  assign     DIB[14]                 = DIB14;
  assign     DIB[15]                 = DIB15;
  assign     DIB[16]                 = DIB16;
  assign     DIB[17]                 = DIB17;
  assign     DIB[18]                 = DIB18;
  assign     DIB[19]                 = DIB19;
  assign     DIB[20]                 = DIB20;
  assign     DIB[21]                 = DIB21;
  assign     DIB[22]                 = DIB22;
  assign     DIB[23]                 = DIB23;
  assign     DIB[24]                 = DIB24;
  assign     DIB[25]                 = DIB25;
  assign     DIB[26]                 = DIB26;
  assign     DIB[27]                 = DIB27;
  assign     DIB[28]                 = DIB28;
  assign     DIB[29]                 = DIB29;
  assign     DIB[30]                 = DIB30;
  assign     DIB[31]                 = DIB31;
  assign     DIB[32]                 = DIB32;
  assign     DIB[33]                 = DIB33;
  assign     DIB[34]                 = DIB34;
  assign     DIB[35]                 = DIB35;
  assign     DIB[36]                 = DIB36;
  assign     DIB[37]                 = DIB37;
  assign     DIB[38]                 = DIB38;
  assign     DIB[39]                 = DIB39;
  assign     DIB[40]                 = DIB40;
  assign     DIB[41]                 = DIB41;
  assign     DIB[42]                 = DIB42;
  assign     DIB[43]                 = DIB43;
  assign     DIB[44]                 = DIB44;
  assign     DIB[45]                 = DIB45;
  assign     DIB[46]                 = DIB46;
  assign     DIB[47]                 = DIB47;

  assign     A[0]                  = A0;
  assign     A[1]                  = A1;
  assign     A[2]                  = A2;
  assign     A[3]                  = A3;
  assign     A[4]                  = A4;
  assign     A[5]                  = A5;
  assign     A[6]                  = A6;
  assign     A[7]                  = A7;
  assign     A[8]                  = A8;
  assign     A[9]                  = A9;
  assign     B[0]                  = B0;
  assign     B[1]                  = B1;
  assign     B[2]                  = B2;
  assign     B[3]                  = B3;
  assign     B[4]                  = B4;
  assign     B[5]                  = B5;
  assign     B[6]                  = B6;
  assign     B[7]                  = B7;
  assign     B[8]                  = B8;
  assign     B[9]                  = B9;
  
 always_ff @(posedge CKA)
  begin
    if (CSA)
    begin
      if (~WEAN0)
      begin
        Memory_byte0[A] <= DIA[0*Bits+:Bits];
        latched_DOA[0*Bits+:Bits] <= DIA[0*Bits+:Bits];
      end
      else
      begin
        latched_DOA[0*Bits+:Bits] <= Memory_byte0[A];
      end
      if (~WEAN1)
      begin
        Memory_byte1[A] <= DIA[1*Bits+:Bits];
        latched_DOA[1*Bits+:Bits] <= DIA[1*Bits+:Bits];
      end
      else
      begin
        latched_DOA[1*Bits+:Bits] <= Memory_byte1[A];
      end
      if (~WEAN2)
      begin
        Memory_byte2[A] <= DIA[2*Bits+:Bits];
        latched_DOA[2*Bits+:Bits] <= DIA[2*Bits+:Bits];
      end
      else
      begin
        latched_DOA[2*Bits+:Bits] <= Memory_byte2[A];
      end
    end
  end
always_ff @(posedge CKB)
  begin
    if (CSB)
    begin
      if (~WEBN0)
      begin
        Memory_byte0[B] <= DIB[0*Bits+:Bits];
        latched_DOB[0*Bits+:Bits] <= DIB[0*Bits+:Bits];
      end
      else
      begin
        latched_DOB[0*Bits+:Bits] <= Memory_byte0[B];
      end
      if (~WEBN1)
      begin
        Memory_byte1[B] <= DIB[1*Bits+:Bits];
        latched_DOB[1*Bits+:Bits] <= DIB[1*Bits+:Bits];
      end
      else
      begin
        latched_DOB[1*Bits+:Bits] <= Memory_byte1[B];
      end
      if (~WEBN2)
      begin
        Memory_byte2[B] <= DIB[2*Bits+:Bits];
        latched_DOB[2*Bits+:Bits] <= DIB[2*Bits+:Bits];
      end
      else
      begin
        latched_DOB[2*Bits+:Bits] <= Memory_byte2[B];
      end
    end
  end
	always_comb
	begin
		DOA = (OEA)? latched_DOA: {(Bytes*Bits){1'bz}};
		DOB = (OEB)? latched_DOB: {(Bytes*Bits){1'bz}};
	end  
  
  endmodule




  