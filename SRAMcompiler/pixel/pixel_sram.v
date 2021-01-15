/*******************************************************************************

             Synchronous Dual Port SRAM Compiler 

                   UMC 0.18um Generic Logic Process 
   __________________________________________________________________________


       (C) Copyright 2002-2009 Faraday Technology Corp. All Rights Reserved.

     This source code is an unpublished work belongs to Faraday Technology
     Corp.  It is considered a trade secret and is not to be divulged or
     used by parties who have not received written authorization from
     Faraday Technology Corp.

     Faraday's home page can be found at:
     http://www.faraday-tech.com/
    
________________________________________________________________________________

      Module Name       :  pixel_sram  
      Word              :  1024        
      Bit               :  16          
      Byte              :  3           
      Mux               :  1           
      Power Ring Type   :  port        
      Power Ring Width  :  2 (um)      
      Output Loading    :  0.5 (pf)    
      Input Data Slew   :  2.0 (ns)    
      Input Clock Slew  :  2.0 (ns)    

________________________________________________________________________________

      Library          : FSA0M_A
      Memaker          : 200901.2.1
      Date             : 2021/01/15 13:27:38

________________________________________________________________________________


   Notice on usage: Fixed delay or timing data are given in this model.
                    It supports SDF back-annotation, please generate SDF file
                    by EDA tools to get the accurate timing.

 |-----------------------------------------------------------------------------|

   Warning : If customer's design viloate the set-up time or hold time criteria 
   of synchronous SRAM, it's possible to hit the meta-stable point of 
   latch circuit in the decoder and cause the data loss in the memory bitcell.
   So please follow the memory IP's spec to design your product.

 |-----------------------------------------------------------------------------|

                Library          : FSA0M_A
                Memaker          : 200901.2.1
                Date             : 2021/01/15 13:27:38

 *******************************************************************************/

`resetall
`timescale 10ps/1ps


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

  `define    TRUE                 (1'b1)              
  `define    FALSE                (1'b0)              

  parameter  SYN_CS               = `TRUE;            
  parameter  NO_SER_TOH           = `TRUE;            
  parameter  AddressSize          = 10;               
  parameter  Bits                 = 16;               
  parameter  Words                = 1024;             
  parameter  Bytes                = 3;                
  parameter  AspectRatio          = 1;                
  parameter  Tr2w                 = (184:270:445);    
  parameter  Tw2r                 = (165:237:384);    
  parameter  TOH                  = (61:90:148);      

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

`protect
  reg        [Bits-1:0]           Memory_byte0 [Words-1:0];     
  reg        [Bits-1:0]           Memory_byte1 [Words-1:0];     
  reg        [Bits-1:0]           Memory_byte2 [Words-1:0];     

  wire       [Bytes*Bits-1:0]     DOA_;               
  wire       [Bytes*Bits-1:0]     DOB_;               
  wire       [AddressSize-1:0]    A_;                 
  wire       [AddressSize-1:0]    B_;                 
  wire                            OEA_;               
  wire                            OEB_;               
  wire       [Bits-1:0]           DIA_byte0_;         
  wire       [Bits-1:0]           DIB_byte0_;         
  wire       [Bits-1:0]           DIA_byte1_;         
  wire       [Bits-1:0]           DIB_byte1_;         
  wire       [Bits-1:0]           DIA_byte2_;         
  wire       [Bits-1:0]           DIB_byte2_;         
  wire                            WEBN0_;             
  wire                            WEBN1_;             
  wire                            WEBN2_;             
  wire                            WEAN0_;             
  wire                            WEAN1_;             
  wire                            WEAN2_;             
  wire                            CKA_;               
  wire                            CKB_;               
  wire                            CSA_;               
  wire                            CSB_;               

  wire                            con_A;              
  wire                            con_B;              
  wire                            con_DIA_byte0;      
  wire                            con_DIB_byte0;      
  wire                            con_DIA_byte1;      
  wire                            con_DIB_byte1;      
  wire                            con_DIA_byte2;      
  wire                            con_DIB_byte2;      
  wire                            con_CKA;            
  wire                            con_CKB;            
  wire                            con_WEBN0;          
  wire                            con_WEBN1;          
  wire                            con_WEBN2;          
  wire                            con_WEAN0;          
  wire                            con_WEAN1;          
  wire                            con_WEAN2;          

  reg        [AddressSize-1:0]    Latch_A;            
  reg        [AddressSize-1:0]    Latch_B;            
  reg        [Bits-1:0]           Latch_DIA_byte0;    
  reg        [Bits-1:0]           Latch_DIB_byte0;    
  reg        [Bits-1:0]           Latch_DIA_byte1;    
  reg        [Bits-1:0]           Latch_DIB_byte1;    
  reg        [Bits-1:0]           Latch_DIA_byte2;    
  reg        [Bits-1:0]           Latch_DIB_byte2;    
  reg                             Latch_WEAN0;        
  reg                             Latch_WEAN1;        
  reg                             Latch_WEAN2;        
  reg                             Latch_WEBN0;        
  reg                             Latch_WEBN1;        
  reg                             Latch_WEBN2;        
  reg                             Latch_CSA;          
  reg                             Latch_CSB;          
  reg        [AddressSize-1:0]    LastCycleAAddress;  
  reg        [AddressSize-1:0]    LastCycleBAddress;  

  reg        [AddressSize-1:0]    A_i;                
  reg        [AddressSize-1:0]    B_i;                
  reg        [Bits-1:0]           DIA_byte0_i;        
  reg        [Bits-1:0]           DIB_byte0_i;        
  reg        [Bits-1:0]           DIA_byte1_i;        
  reg        [Bits-1:0]           DIB_byte1_i;        
  reg        [Bits-1:0]           DIA_byte2_i;        
  reg        [Bits-1:0]           DIB_byte2_i;        
  reg                             WEAN0_i;            
  reg                             WEAN1_i;            
  reg                             WEAN2_i;            
  reg                             WEBN0_i;            
  reg                             WEBN1_i;            
  reg                             WEBN2_i;            
  reg                             CSA_i;              
  reg                             CSB_i;              

  reg                             n_flag_A0;          
  reg                             n_flag_A1;          
  reg                             n_flag_A2;          
  reg                             n_flag_A3;          
  reg                             n_flag_A4;          
  reg                             n_flag_A5;          
  reg                             n_flag_A6;          
  reg                             n_flag_A7;          
  reg                             n_flag_A8;          
  reg                             n_flag_A9;          
  reg                             n_flag_B0;          
  reg                             n_flag_B1;          
  reg                             n_flag_B2;          
  reg                             n_flag_B3;          
  reg                             n_flag_B4;          
  reg                             n_flag_B5;          
  reg                             n_flag_B6;          
  reg                             n_flag_B7;          
  reg                             n_flag_B8;          
  reg                             n_flag_B9;          
  reg                             n_flag_DIA0;        
  reg                             n_flag_DIB0;        
  reg                             n_flag_DIA1;        
  reg                             n_flag_DIB1;        
  reg                             n_flag_DIA2;        
  reg                             n_flag_DIB2;        
  reg                             n_flag_DIA3;        
  reg                             n_flag_DIB3;        
  reg                             n_flag_DIA4;        
  reg                             n_flag_DIB4;        
  reg                             n_flag_DIA5;        
  reg                             n_flag_DIB5;        
  reg                             n_flag_DIA6;        
  reg                             n_flag_DIB6;        
  reg                             n_flag_DIA7;        
  reg                             n_flag_DIB7;        
  reg                             n_flag_DIA8;        
  reg                             n_flag_DIB8;        
  reg                             n_flag_DIA9;        
  reg                             n_flag_DIB9;        
  reg                             n_flag_DIA10;       
  reg                             n_flag_DIB10;       
  reg                             n_flag_DIA11;       
  reg                             n_flag_DIB11;       
  reg                             n_flag_DIA12;       
  reg                             n_flag_DIB12;       
  reg                             n_flag_DIA13;       
  reg                             n_flag_DIB13;       
  reg                             n_flag_DIA14;       
  reg                             n_flag_DIB14;       
  reg                             n_flag_DIA15;       
  reg                             n_flag_DIB15;       
  reg                             n_flag_DIA16;       
  reg                             n_flag_DIB16;       
  reg                             n_flag_DIA17;       
  reg                             n_flag_DIB17;       
  reg                             n_flag_DIA18;       
  reg                             n_flag_DIB18;       
  reg                             n_flag_DIA19;       
  reg                             n_flag_DIB19;       
  reg                             n_flag_DIA20;       
  reg                             n_flag_DIB20;       
  reg                             n_flag_DIA21;       
  reg                             n_flag_DIB21;       
  reg                             n_flag_DIA22;       
  reg                             n_flag_DIB22;       
  reg                             n_flag_DIA23;       
  reg                             n_flag_DIB23;       
  reg                             n_flag_DIA24;       
  reg                             n_flag_DIB24;       
  reg                             n_flag_DIA25;       
  reg                             n_flag_DIB25;       
  reg                             n_flag_DIA26;       
  reg                             n_flag_DIB26;       
  reg                             n_flag_DIA27;       
  reg                             n_flag_DIB27;       
  reg                             n_flag_DIA28;       
  reg                             n_flag_DIB28;       
  reg                             n_flag_DIA29;       
  reg                             n_flag_DIB29;       
  reg                             n_flag_DIA30;       
  reg                             n_flag_DIB30;       
  reg                             n_flag_DIA31;       
  reg                             n_flag_DIB31;       
  reg                             n_flag_DIA32;       
  reg                             n_flag_DIB32;       
  reg                             n_flag_DIA33;       
  reg                             n_flag_DIB33;       
  reg                             n_flag_DIA34;       
  reg                             n_flag_DIB34;       
  reg                             n_flag_DIA35;       
  reg                             n_flag_DIB35;       
  reg                             n_flag_DIA36;       
  reg                             n_flag_DIB36;       
  reg                             n_flag_DIA37;       
  reg                             n_flag_DIB37;       
  reg                             n_flag_DIA38;       
  reg                             n_flag_DIB38;       
  reg                             n_flag_DIA39;       
  reg                             n_flag_DIB39;       
  reg                             n_flag_DIA40;       
  reg                             n_flag_DIB40;       
  reg                             n_flag_DIA41;       
  reg                             n_flag_DIB41;       
  reg                             n_flag_DIA42;       
  reg                             n_flag_DIB42;       
  reg                             n_flag_DIA43;       
  reg                             n_flag_DIB43;       
  reg                             n_flag_DIA44;       
  reg                             n_flag_DIB44;       
  reg                             n_flag_DIA45;       
  reg                             n_flag_DIB45;       
  reg                             n_flag_DIA46;       
  reg                             n_flag_DIB46;       
  reg                             n_flag_DIA47;       
  reg                             n_flag_DIB47;       
  reg                             n_flag_WEAN0;       
  reg                             n_flag_WEAN1;       
  reg                             n_flag_WEAN2;       
  reg                             n_flag_WEBN0;       
  reg                             n_flag_WEBN1;       
  reg                             n_flag_WEBN2;       
  reg                             n_flag_CSA;         
  reg                             n_flag_CSB;         
  reg                             n_flag_CKA_PER;     
  reg                             n_flag_CKA_MINH;    
  reg                             n_flag_CKA_MINL;    
  reg                             n_flag_CKB_PER;     
  reg                             n_flag_CKB_MINH;    
  reg                             n_flag_CKB_MINL;    
  reg                             LAST_n_flag_WEAN0;  
  reg                             LAST_n_flag_WEAN1;  
  reg                             LAST_n_flag_WEAN2;  
  reg                             LAST_n_flag_WEBN0;  
  reg                             LAST_n_flag_WEBN1;  
  reg                             LAST_n_flag_WEBN2;  
  reg                             LAST_n_flag_CSA;    
  reg                             LAST_n_flag_CSB;    
  reg                             LAST_n_flag_CKA_PER;
  reg                             LAST_n_flag_CKA_MINH;
  reg                             LAST_n_flag_CKA_MINL;
  reg                             LAST_n_flag_CKB_PER;
  reg                             LAST_n_flag_CKB_MINH;
  reg                             LAST_n_flag_CKB_MINL;
  reg        [AddressSize-1:0]    NOT_BUS_B;          
  reg        [AddressSize-1:0]    LAST_NOT_BUS_B;     
  reg        [AddressSize-1:0]    NOT_BUS_A;          
  reg        [AddressSize-1:0]    LAST_NOT_BUS_A;     
  reg        [Bits-1:0]           NOT_BUS_DIA_byte0;  
  reg        [Bits-1:0]           NOT_BUS_DIB_byte0;  
  reg        [Bits-1:0]           LAST_NOT_BUS_DIA_byte0;
  reg        [Bits-1:0]           LAST_NOT_BUS_DIB_byte0;
  reg        [Bits-1:0]           NOT_BUS_DIA_byte1;  
  reg        [Bits-1:0]           NOT_BUS_DIB_byte1;  
  reg        [Bits-1:0]           LAST_NOT_BUS_DIA_byte1;
  reg        [Bits-1:0]           LAST_NOT_BUS_DIB_byte1;
  reg        [Bits-1:0]           NOT_BUS_DIA_byte2;  
  reg        [Bits-1:0]           NOT_BUS_DIB_byte2;  
  reg        [Bits-1:0]           LAST_NOT_BUS_DIA_byte2;
  reg        [Bits-1:0]           LAST_NOT_BUS_DIB_byte2;

  reg        [AddressSize-1:0]    last_A;             
  reg        [AddressSize-1:0]    latch_last_A;       
  reg        [AddressSize-1:0]    last_B;             
  reg        [AddressSize-1:0]    latch_last_B;       

  reg        [Bits-1:0]           last_DIA_byte0;     
  reg        [Bits-1:0]           latch_last_DIA_byte0;
  reg        [Bits-1:0]           last_DIA_byte1;     
  reg        [Bits-1:0]           latch_last_DIA_byte1;
  reg        [Bits-1:0]           last_DIA_byte2;     
  reg        [Bits-1:0]           latch_last_DIA_byte2;
  reg        [Bits-1:0]           last_DIB_byte0;     
  reg        [Bits-1:0]           latch_last_DIB_byte0;
  reg        [Bits-1:0]           last_DIB_byte1;     
  reg        [Bits-1:0]           latch_last_DIB_byte1;
  reg        [Bits-1:0]           last_DIB_byte2;     
  reg        [Bits-1:0]           latch_last_DIB_byte2;

  reg        [Bits-1:0]           DOA_byte0_i;        
  reg        [Bits-1:0]           DOB_byte0_i;        
  reg        [Bits-1:0]           DOA_byte1_i;        
  reg        [Bits-1:0]           DOB_byte1_i;        
  reg        [Bits-1:0]           DOA_byte2_i;        
  reg        [Bits-1:0]           DOB_byte2_i;        

  reg                             LastClkAEdge;       
  reg                             LastClkBEdge;       

  reg                             Last_WEAN0_i;       
  reg                             Last_WEAN1_i;       
  reg                             Last_WEAN2_i;       
  reg                             Last_WEBN0_i;       
  reg                             Last_WEBN1_i;       
  reg                             Last_WEBN2_i;       

  reg                             flag_A_x;           
  reg                             flag_B_x;           
  reg                             flag_CSA_x;         
  reg                             flag_CSB_x;         
  reg                             NODELAYA0;          
  reg                             NODELAYB0;          
  reg                             NODELAYA1;          
  reg                             NODELAYB1;          
  reg                             NODELAYA2;          
  reg                             NODELAYB2;          
  reg        [Bits-1:0]           DOA_byte0_tmp;      
  reg        [Bits-1:0]           DOB_byte0_tmp;      
  event                           EventTOHDOA_byte0;  
  event                           EventTOHDOB_byte0;  
  reg        [Bits-1:0]           DOA_byte1_tmp;      
  reg        [Bits-1:0]           DOB_byte1_tmp;      
  event                           EventTOHDOA_byte1;  
  event                           EventTOHDOB_byte1;  
  reg        [Bits-1:0]           DOA_byte2_tmp;      
  reg        [Bits-1:0]           DOB_byte2_tmp;      
  event                           EventTOHDOA_byte2;  
  event                           EventTOHDOB_byte2;  

  time                            Last_tc_ClkA_PosEdge;
  time                            Last_tc_ClkB_PosEdge;

  assign     DOA_                 = {DOA_byte2_i,DOA_byte1_i,DOA_byte0_i};
  assign     DOB_                 = {DOB_byte2_i,DOB_byte1_i,DOB_byte0_i};
  assign     con_A                = CSA_;
  assign     con_B                = CSB_;
  assign     con_DIA_byte0        = CSA_ & (!WEAN0_);
  assign     con_DIB_byte0        = CSB_ & (!WEBN0_);
  assign     con_DIA_byte1        = CSA_ & (!WEAN1_);
  assign     con_DIB_byte1        = CSB_ & (!WEBN1_);
  assign     con_DIA_byte2        = CSA_ & (!WEAN2_);
  assign     con_DIB_byte2        = CSB_ & (!WEBN2_);
  assign     con_WEAN0            = CSA_;
  assign     con_WEAN1            = CSA_;
  assign     con_WEAN2            = CSA_;
  assign     con_WEBN0            = CSB_;
  assign     con_WEBN1            = CSB_;
  assign     con_WEBN2            = CSB_;
  assign     con_CKA              = CSA_;
  assign     con_CKB              = CSB_;

  bufif1     idoa0           (DOA0, DOA_[0], OEA_);        
  bufif1     idob0           (DOB0, DOB_[0], OEB_);        
  bufif1     idoa1           (DOA1, DOA_[1], OEA_);        
  bufif1     idob1           (DOB1, DOB_[1], OEB_);        
  bufif1     idoa2           (DOA2, DOA_[2], OEA_);        
  bufif1     idob2           (DOB2, DOB_[2], OEB_);        
  bufif1     idoa3           (DOA3, DOA_[3], OEA_);        
  bufif1     idob3           (DOB3, DOB_[3], OEB_);        
  bufif1     idoa4           (DOA4, DOA_[4], OEA_);        
  bufif1     idob4           (DOB4, DOB_[4], OEB_);        
  bufif1     idoa5           (DOA5, DOA_[5], OEA_);        
  bufif1     idob5           (DOB5, DOB_[5], OEB_);        
  bufif1     idoa6           (DOA6, DOA_[6], OEA_);        
  bufif1     idob6           (DOB6, DOB_[6], OEB_);        
  bufif1     idoa7           (DOA7, DOA_[7], OEA_);        
  bufif1     idob7           (DOB7, DOB_[7], OEB_);        
  bufif1     idoa8           (DOA8, DOA_[8], OEA_);        
  bufif1     idob8           (DOB8, DOB_[8], OEB_);        
  bufif1     idoa9           (DOA9, DOA_[9], OEA_);        
  bufif1     idob9           (DOB9, DOB_[9], OEB_);        
  bufif1     idoa10          (DOA10, DOA_[10], OEA_);      
  bufif1     idob10          (DOB10, DOB_[10], OEB_);      
  bufif1     idoa11          (DOA11, DOA_[11], OEA_);      
  bufif1     idob11          (DOB11, DOB_[11], OEB_);      
  bufif1     idoa12          (DOA12, DOA_[12], OEA_);      
  bufif1     idob12          (DOB12, DOB_[12], OEB_);      
  bufif1     idoa13          (DOA13, DOA_[13], OEA_);      
  bufif1     idob13          (DOB13, DOB_[13], OEB_);      
  bufif1     idoa14          (DOA14, DOA_[14], OEA_);      
  bufif1     idob14          (DOB14, DOB_[14], OEB_);      
  bufif1     idoa15          (DOA15, DOA_[15], OEA_);      
  bufif1     idob15          (DOB15, DOB_[15], OEB_);      
  bufif1     idoa16          (DOA16, DOA_[16], OEA_);      
  bufif1     idob16          (DOB16, DOB_[16], OEB_);      
  bufif1     idoa17          (DOA17, DOA_[17], OEA_);      
  bufif1     idob17          (DOB17, DOB_[17], OEB_);      
  bufif1     idoa18          (DOA18, DOA_[18], OEA_);      
  bufif1     idob18          (DOB18, DOB_[18], OEB_);      
  bufif1     idoa19          (DOA19, DOA_[19], OEA_);      
  bufif1     idob19          (DOB19, DOB_[19], OEB_);      
  bufif1     idoa20          (DOA20, DOA_[20], OEA_);      
  bufif1     idob20          (DOB20, DOB_[20], OEB_);      
  bufif1     idoa21          (DOA21, DOA_[21], OEA_);      
  bufif1     idob21          (DOB21, DOB_[21], OEB_);      
  bufif1     idoa22          (DOA22, DOA_[22], OEA_);      
  bufif1     idob22          (DOB22, DOB_[22], OEB_);      
  bufif1     idoa23          (DOA23, DOA_[23], OEA_);      
  bufif1     idob23          (DOB23, DOB_[23], OEB_);      
  bufif1     idoa24          (DOA24, DOA_[24], OEA_);      
  bufif1     idob24          (DOB24, DOB_[24], OEB_);      
  bufif1     idoa25          (DOA25, DOA_[25], OEA_);      
  bufif1     idob25          (DOB25, DOB_[25], OEB_);      
  bufif1     idoa26          (DOA26, DOA_[26], OEA_);      
  bufif1     idob26          (DOB26, DOB_[26], OEB_);      
  bufif1     idoa27          (DOA27, DOA_[27], OEA_);      
  bufif1     idob27          (DOB27, DOB_[27], OEB_);      
  bufif1     idoa28          (DOA28, DOA_[28], OEA_);      
  bufif1     idob28          (DOB28, DOB_[28], OEB_);      
  bufif1     idoa29          (DOA29, DOA_[29], OEA_);      
  bufif1     idob29          (DOB29, DOB_[29], OEB_);      
  bufif1     idoa30          (DOA30, DOA_[30], OEA_);      
  bufif1     idob30          (DOB30, DOB_[30], OEB_);      
  bufif1     idoa31          (DOA31, DOA_[31], OEA_);      
  bufif1     idob31          (DOB31, DOB_[31], OEB_);      
  bufif1     idoa32          (DOA32, DOA_[32], OEA_);      
  bufif1     idob32          (DOB32, DOB_[32], OEB_);      
  bufif1     idoa33          (DOA33, DOA_[33], OEA_);      
  bufif1     idob33          (DOB33, DOB_[33], OEB_);      
  bufif1     idoa34          (DOA34, DOA_[34], OEA_);      
  bufif1     idob34          (DOB34, DOB_[34], OEB_);      
  bufif1     idoa35          (DOA35, DOA_[35], OEA_);      
  bufif1     idob35          (DOB35, DOB_[35], OEB_);      
  bufif1     idoa36          (DOA36, DOA_[36], OEA_);      
  bufif1     idob36          (DOB36, DOB_[36], OEB_);      
  bufif1     idoa37          (DOA37, DOA_[37], OEA_);      
  bufif1     idob37          (DOB37, DOB_[37], OEB_);      
  bufif1     idoa38          (DOA38, DOA_[38], OEA_);      
  bufif1     idob38          (DOB38, DOB_[38], OEB_);      
  bufif1     idoa39          (DOA39, DOA_[39], OEA_);      
  bufif1     idob39          (DOB39, DOB_[39], OEB_);      
  bufif1     idoa40          (DOA40, DOA_[40], OEA_);      
  bufif1     idob40          (DOB40, DOB_[40], OEB_);      
  bufif1     idoa41          (DOA41, DOA_[41], OEA_);      
  bufif1     idob41          (DOB41, DOB_[41], OEB_);      
  bufif1     idoa42          (DOA42, DOA_[42], OEA_);      
  bufif1     idob42          (DOB42, DOB_[42], OEB_);      
  bufif1     idoa43          (DOA43, DOA_[43], OEA_);      
  bufif1     idob43          (DOB43, DOB_[43], OEB_);      
  bufif1     idoa44          (DOA44, DOA_[44], OEA_);      
  bufif1     idob44          (DOB44, DOB_[44], OEB_);      
  bufif1     idoa45          (DOA45, DOA_[45], OEA_);      
  bufif1     idob45          (DOB45, DOB_[45], OEB_);      
  bufif1     idoa46          (DOA46, DOA_[46], OEA_);      
  bufif1     idob46          (DOB46, DOB_[46], OEB_);      
  bufif1     idoa47          (DOA47, DOA_[47], OEA_);      
  bufif1     idob47          (DOB47, DOB_[47], OEB_);      
  buf        ia0             (A_[0], A0);                  
  buf        ia1             (A_[1], A1);                  
  buf        ia2             (A_[2], A2);                  
  buf        ia3             (A_[3], A3);                  
  buf        ia4             (A_[4], A4);                  
  buf        ia5             (A_[5], A5);                  
  buf        ia6             (A_[6], A6);                  
  buf        ia7             (A_[7], A7);                  
  buf        ia8             (A_[8], A8);                  
  buf        ia9             (A_[9], A9);                  
  buf        ib0             (B_[0], B0);                  
  buf        ib1             (B_[1], B1);                  
  buf        ib2             (B_[2], B2);                  
  buf        ib3             (B_[3], B3);                  
  buf        ib4             (B_[4], B4);                  
  buf        ib5             (B_[5], B5);                  
  buf        ib6             (B_[6], B6);                  
  buf        ib7             (B_[7], B7);                  
  buf        ib8             (B_[8], B8);                  
  buf        ib9             (B_[9], B9);                  
  buf        idia_byte0_0    (DIA_byte0_[0], DIA0);        
  buf        idib_byte0_0    (DIB_byte0_[0], DIB0);        
  buf        idia_byte0_1    (DIA_byte0_[1], DIA1);        
  buf        idib_byte0_1    (DIB_byte0_[1], DIB1);        
  buf        idia_byte0_2    (DIA_byte0_[2], DIA2);        
  buf        idib_byte0_2    (DIB_byte0_[2], DIB2);        
  buf        idia_byte0_3    (DIA_byte0_[3], DIA3);        
  buf        idib_byte0_3    (DIB_byte0_[3], DIB3);        
  buf        idia_byte0_4    (DIA_byte0_[4], DIA4);        
  buf        idib_byte0_4    (DIB_byte0_[4], DIB4);        
  buf        idia_byte0_5    (DIA_byte0_[5], DIA5);        
  buf        idib_byte0_5    (DIB_byte0_[5], DIB5);        
  buf        idia_byte0_6    (DIA_byte0_[6], DIA6);        
  buf        idib_byte0_6    (DIB_byte0_[6], DIB6);        
  buf        idia_byte0_7    (DIA_byte0_[7], DIA7);        
  buf        idib_byte0_7    (DIB_byte0_[7], DIB7);        
  buf        idia_byte0_8    (DIA_byte0_[8], DIA8);        
  buf        idib_byte0_8    (DIB_byte0_[8], DIB8);        
  buf        idia_byte0_9    (DIA_byte0_[9], DIA9);        
  buf        idib_byte0_9    (DIB_byte0_[9], DIB9);        
  buf        idia_byte0_10   (DIA_byte0_[10], DIA10);      
  buf        idib_byte0_10   (DIB_byte0_[10], DIB10);      
  buf        idia_byte0_11   (DIA_byte0_[11], DIA11);      
  buf        idib_byte0_11   (DIB_byte0_[11], DIB11);      
  buf        idia_byte0_12   (DIA_byte0_[12], DIA12);      
  buf        idib_byte0_12   (DIB_byte0_[12], DIB12);      
  buf        idia_byte0_13   (DIA_byte0_[13], DIA13);      
  buf        idib_byte0_13   (DIB_byte0_[13], DIB13);      
  buf        idia_byte0_14   (DIA_byte0_[14], DIA14);      
  buf        idib_byte0_14   (DIB_byte0_[14], DIB14);      
  buf        idia_byte0_15   (DIA_byte0_[15], DIA15);      
  buf        idib_byte0_15   (DIB_byte0_[15], DIB15);      
  buf        idia_byte1_0    (DIA_byte1_[0], DIA16);       
  buf        idib_byte1_0    (DIB_byte1_[0], DIB16);       
  buf        idia_byte1_1    (DIA_byte1_[1], DIA17);       
  buf        idib_byte1_1    (DIB_byte1_[1], DIB17);       
  buf        idia_byte1_2    (DIA_byte1_[2], DIA18);       
  buf        idib_byte1_2    (DIB_byte1_[2], DIB18);       
  buf        idia_byte1_3    (DIA_byte1_[3], DIA19);       
  buf        idib_byte1_3    (DIB_byte1_[3], DIB19);       
  buf        idia_byte1_4    (DIA_byte1_[4], DIA20);       
  buf        idib_byte1_4    (DIB_byte1_[4], DIB20);       
  buf        idia_byte1_5    (DIA_byte1_[5], DIA21);       
  buf        idib_byte1_5    (DIB_byte1_[5], DIB21);       
  buf        idia_byte1_6    (DIA_byte1_[6], DIA22);       
  buf        idib_byte1_6    (DIB_byte1_[6], DIB22);       
  buf        idia_byte1_7    (DIA_byte1_[7], DIA23);       
  buf        idib_byte1_7    (DIB_byte1_[7], DIB23);       
  buf        idia_byte1_8    (DIA_byte1_[8], DIA24);       
  buf        idib_byte1_8    (DIB_byte1_[8], DIB24);       
  buf        idia_byte1_9    (DIA_byte1_[9], DIA25);       
  buf        idib_byte1_9    (DIB_byte1_[9], DIB25);       
  buf        idia_byte1_10   (DIA_byte1_[10], DIA26);      
  buf        idib_byte1_10   (DIB_byte1_[10], DIB26);      
  buf        idia_byte1_11   (DIA_byte1_[11], DIA27);      
  buf        idib_byte1_11   (DIB_byte1_[11], DIB27);      
  buf        idia_byte1_12   (DIA_byte1_[12], DIA28);      
  buf        idib_byte1_12   (DIB_byte1_[12], DIB28);      
  buf        idia_byte1_13   (DIA_byte1_[13], DIA29);      
  buf        idib_byte1_13   (DIB_byte1_[13], DIB29);      
  buf        idia_byte1_14   (DIA_byte1_[14], DIA30);      
  buf        idib_byte1_14   (DIB_byte1_[14], DIB30);      
  buf        idia_byte1_15   (DIA_byte1_[15], DIA31);      
  buf        idib_byte1_15   (DIB_byte1_[15], DIB31);      
  buf        idia_byte2_0    (DIA_byte2_[0], DIA32);       
  buf        idib_byte2_0    (DIB_byte2_[0], DIB32);       
  buf        idia_byte2_1    (DIA_byte2_[1], DIA33);       
  buf        idib_byte2_1    (DIB_byte2_[1], DIB33);       
  buf        idia_byte2_2    (DIA_byte2_[2], DIA34);       
  buf        idib_byte2_2    (DIB_byte2_[2], DIB34);       
  buf        idia_byte2_3    (DIA_byte2_[3], DIA35);       
  buf        idib_byte2_3    (DIB_byte2_[3], DIB35);       
  buf        idia_byte2_4    (DIA_byte2_[4], DIA36);       
  buf        idib_byte2_4    (DIB_byte2_[4], DIB36);       
  buf        idia_byte2_5    (DIA_byte2_[5], DIA37);       
  buf        idib_byte2_5    (DIB_byte2_[5], DIB37);       
  buf        idia_byte2_6    (DIA_byte2_[6], DIA38);       
  buf        idib_byte2_6    (DIB_byte2_[6], DIB38);       
  buf        idia_byte2_7    (DIA_byte2_[7], DIA39);       
  buf        idib_byte2_7    (DIB_byte2_[7], DIB39);       
  buf        idia_byte2_8    (DIA_byte2_[8], DIA40);       
  buf        idib_byte2_8    (DIB_byte2_[8], DIB40);       
  buf        idia_byte2_9    (DIA_byte2_[9], DIA41);       
  buf        idib_byte2_9    (DIB_byte2_[9], DIB41);       
  buf        idia_byte2_10   (DIA_byte2_[10], DIA42);      
  buf        idib_byte2_10   (DIB_byte2_[10], DIB42);      
  buf        idia_byte2_11   (DIA_byte2_[11], DIA43);      
  buf        idib_byte2_11   (DIB_byte2_[11], DIB43);      
  buf        idia_byte2_12   (DIA_byte2_[12], DIA44);      
  buf        idib_byte2_12   (DIB_byte2_[12], DIB44);      
  buf        idia_byte2_13   (DIA_byte2_[13], DIA45);      
  buf        idib_byte2_13   (DIB_byte2_[13], DIB45);      
  buf        idia_byte2_14   (DIA_byte2_[14], DIA46);      
  buf        idib_byte2_14   (DIB_byte2_[14], DIB46);      
  buf        idia_byte2_15   (DIA_byte2_[15], DIA47);      
  buf        idib_byte2_15   (DIB_byte2_[15], DIB47);      
  buf        icka            (CKA_, CKA);                  
  buf        ickb            (CKB_, CKB);                  
  buf        icsa            (CSA_, CSA);                  
  buf        icsb            (CSB_, CSB);                  
  buf        ioea            (OEA_, OEA);                  
  buf        ioeb            (OEB_, OEB);                  
  buf        iwea0           (WEAN0_, WEAN0);              
  buf        iwea1           (WEAN1_, WEAN1);              
  buf        iwea2           (WEAN2_, WEAN2);              
  buf        iweb0           (WEBN0_, WEBN0);              
  buf        iweb1           (WEBN1_, WEBN1);              
  buf        iweb2           (WEBN2_, WEBN2);              

  initial begin
    $timeformat (-12, 0, " ps", 20);
    flag_A_x = `FALSE;
    flag_B_x = `FALSE;
    NODELAYA0 = 1'b0;
    NODELAYB0 = 1'b0;
    NODELAYA1 = 1'b0;
    NODELAYB1 = 1'b0;
    NODELAYA2 = 1'b0;
    NODELAYB2 = 1'b0;
  end


  always @(CKA_) begin
    casez ({LastClkAEdge,CKA_})
      2'b01:
         begin
           last_A = latch_last_A;
           last_DIA_byte0 = latch_last_DIA_byte0;
           last_DIA_byte1 = latch_last_DIA_byte1;
           last_DIA_byte2 = latch_last_DIA_byte2;
           CSA_monitor;
           pre_latch_dataA;
           memory_functionA;
           if (CSA_==1'b1) Last_tc_ClkA_PosEdge = $time;
           latch_last_A = A_;
           latch_last_DIA_byte0 = DIA_byte0_;
           latch_last_DIA_byte1 = DIA_byte1_;
           latch_last_DIA_byte2 = DIA_byte2_;
         end
      2'b?x:
         begin
           ErrorMessage(0);
           if (CSA_ !== 0) begin
              if (WEAN0_ !== 1'b1) begin
                 all_core_xA(0,1);
              end else begin
                 #0 disable TOHDOA_byte0;
                 NODELAYA0 = 1'b1;
                 DOA_byte0_i = {Bits{1'bX}};
              end
              if (WEAN1_ !== 1'b1) begin
                 all_core_xA(1,1);
              end else begin
                 #0 disable TOHDOA_byte1;
                 NODELAYA1 = 1'b1;
                 DOA_byte1_i = {Bits{1'bX}};
              end
              if (WEAN2_ !== 1'b1) begin
                 all_core_xA(2,1);
              end else begin
                 #0 disable TOHDOA_byte2;
                 NODELAYA2 = 1'b1;
                 DOA_byte2_i = {Bits{1'bX}};
              end
           end
         end
    endcase
    LastClkAEdge = CKA_;
  end

  always @(CKB_) begin
    casez ({LastClkBEdge,CKB_})
      2'b01:
         begin
           last_B = latch_last_B;
           last_DIB_byte0 = latch_last_DIB_byte0;
           last_DIB_byte1 = latch_last_DIB_byte1;
           last_DIB_byte2 = latch_last_DIB_byte2;
           CSB_monitor;
           pre_latch_dataB;
           memory_functionB;
           if (CSB_==1'b1) Last_tc_ClkB_PosEdge = $time;
           latch_last_B = B_;
           latch_last_DIB_byte0 = DIB_byte0_;
           latch_last_DIB_byte1 = DIB_byte1_;
           latch_last_DIB_byte2 = DIB_byte2_;
         end
      2'b?x:
         begin
           ErrorMessage(0);
           if (CSB_ !== 0) begin
              if (WEBN0_ !== 1'b1) begin
                 all_core_xB(0,1);
              end else begin
                 #0 disable TOHDOB_byte0;
                 NODELAYB0 = 1'b1;
                 DOB_byte0_i = {Bits{1'bX}};
              end
              if (WEBN1_ !== 1'b1) begin
                 all_core_xB(1,1);
              end else begin
                 #0 disable TOHDOB_byte1;
                 NODELAYB1 = 1'b1;
                 DOB_byte1_i = {Bits{1'bX}};
              end
              if (WEBN2_ !== 1'b1) begin
                 all_core_xB(2,1);
              end else begin
                 #0 disable TOHDOB_byte2;
                 NODELAYB2 = 1'b1;
                 DOB_byte2_i = {Bits{1'bX}};
              end
           end
         end
    endcase
    LastClkBEdge = CKB_;
  end

  always @(
           n_flag_A0 or
           n_flag_A1 or
           n_flag_A2 or
           n_flag_A3 or
           n_flag_A4 or
           n_flag_A5 or
           n_flag_A6 or
           n_flag_A7 or
           n_flag_A8 or
           n_flag_A9 or
           n_flag_DIA0 or
           n_flag_DIA1 or
           n_flag_DIA2 or
           n_flag_DIA3 or
           n_flag_DIA4 or
           n_flag_DIA5 or
           n_flag_DIA6 or
           n_flag_DIA7 or
           n_flag_DIA8 or
           n_flag_DIA9 or
           n_flag_DIA10 or
           n_flag_DIA11 or
           n_flag_DIA12 or
           n_flag_DIA13 or
           n_flag_DIA14 or
           n_flag_DIA15 or
           n_flag_DIA16 or
           n_flag_DIA17 or
           n_flag_DIA18 or
           n_flag_DIA19 or
           n_flag_DIA20 or
           n_flag_DIA21 or
           n_flag_DIA22 or
           n_flag_DIA23 or
           n_flag_DIA24 or
           n_flag_DIA25 or
           n_flag_DIA26 or
           n_flag_DIA27 or
           n_flag_DIA28 or
           n_flag_DIA29 or
           n_flag_DIA30 or
           n_flag_DIA31 or
           n_flag_DIA32 or
           n_flag_DIA33 or
           n_flag_DIA34 or
           n_flag_DIA35 or
           n_flag_DIA36 or
           n_flag_DIA37 or
           n_flag_DIA38 or
           n_flag_DIA39 or
           n_flag_DIA40 or
           n_flag_DIA41 or
           n_flag_DIA42 or
           n_flag_DIA43 or
           n_flag_DIA44 or
           n_flag_DIA45 or
           n_flag_DIA46 or
           n_flag_DIA47 or
           n_flag_WEAN0 or
           n_flag_WEAN1 or
           n_flag_WEAN2 or
           n_flag_CSA or
           n_flag_CKA_PER or
           n_flag_CKA_MINH or
           n_flag_CKA_MINL
          )
     begin
       timingcheck_violationA;
     end

  always @(
           n_flag_B0 or
           n_flag_B1 or
           n_flag_B2 or
           n_flag_B3 or
           n_flag_B4 or
           n_flag_B5 or
           n_flag_B6 or
           n_flag_B7 or
           n_flag_B8 or
           n_flag_B9 or
           n_flag_DIB0 or
           n_flag_DIB1 or
           n_flag_DIB2 or
           n_flag_DIB3 or
           n_flag_DIB4 or
           n_flag_DIB5 or
           n_flag_DIB6 or
           n_flag_DIB7 or
           n_flag_DIB8 or
           n_flag_DIB9 or
           n_flag_DIB10 or
           n_flag_DIB11 or
           n_flag_DIB12 or
           n_flag_DIB13 or
           n_flag_DIB14 or
           n_flag_DIB15 or
           n_flag_DIB16 or
           n_flag_DIB17 or
           n_flag_DIB18 or
           n_flag_DIB19 or
           n_flag_DIB20 or
           n_flag_DIB21 or
           n_flag_DIB22 or
           n_flag_DIB23 or
           n_flag_DIB24 or
           n_flag_DIB25 or
           n_flag_DIB26 or
           n_flag_DIB27 or
           n_flag_DIB28 or
           n_flag_DIB29 or
           n_flag_DIB30 or
           n_flag_DIB31 or
           n_flag_DIB32 or
           n_flag_DIB33 or
           n_flag_DIB34 or
           n_flag_DIB35 or
           n_flag_DIB36 or
           n_flag_DIB37 or
           n_flag_DIB38 or
           n_flag_DIB39 or
           n_flag_DIB40 or
           n_flag_DIB41 or
           n_flag_DIB42 or
           n_flag_DIB43 or
           n_flag_DIB44 or
           n_flag_DIB45 or
           n_flag_DIB46 or
           n_flag_DIB47 or
           n_flag_WEBN0 or
           n_flag_WEBN1 or
           n_flag_WEBN2 or
           n_flag_CSB or
           n_flag_CKB_PER or
           n_flag_CKB_MINH or
           n_flag_CKB_MINL
          )
     begin
       timingcheck_violationB;
     end


  always @(EventTOHDOA_byte0) 
    begin:TOHDOA_byte0 
      #TOH 
      NODELAYA0 <= 1'b0; 
      DOA_byte0_i              =  {Bits{1'bX}}; 
      DOA_byte0_i              <= DOA_byte0_tmp; 
  end 

  always @(EventTOHDOB_byte0) 
    begin:TOHDOB_byte0 
      #TOH 
      NODELAYB0 <= 1'b0; 
      DOB_byte0_i              =  {Bits{1'bX}}; 
      DOB_byte0_i              <= DOB_byte0_tmp; 
  end 

  always @(EventTOHDOA_byte1) 
    begin:TOHDOA_byte1 
      #TOH 
      NODELAYA1 <= 1'b0; 
      DOA_byte1_i              =  {Bits{1'bX}}; 
      DOA_byte1_i              <= DOA_byte1_tmp; 
  end 

  always @(EventTOHDOB_byte1) 
    begin:TOHDOB_byte1 
      #TOH 
      NODELAYB1 <= 1'b0; 
      DOB_byte1_i              =  {Bits{1'bX}}; 
      DOB_byte1_i              <= DOB_byte1_tmp; 
  end 

  always @(EventTOHDOA_byte2) 
    begin:TOHDOA_byte2 
      #TOH 
      NODELAYA2 <= 1'b0; 
      DOA_byte2_i              =  {Bits{1'bX}}; 
      DOA_byte2_i              <= DOA_byte2_tmp; 
  end 

  always @(EventTOHDOB_byte2) 
    begin:TOHDOB_byte2 
      #TOH 
      NODELAYB2 <= 1'b0; 
      DOB_byte2_i              =  {Bits{1'bX}}; 
      DOB_byte2_i              <= DOB_byte2_tmp; 
  end 


  task timingcheck_violationA;
    integer i;
    begin
      // PORT A
      if ((n_flag_CKA_PER  !== LAST_n_flag_CKA_PER)  ||
          (n_flag_CKA_MINH !== LAST_n_flag_CKA_MINH) ||
          (n_flag_CKA_MINL !== LAST_n_flag_CKA_MINL)) begin
          if (CSA_ !== 1'b0) begin
             if (WEAN0_ !== 1'b1) begin
                all_core_xA(0,1);
             end
             else begin
                #0 disable TOHDOA_byte0;
                NODELAYA0 = 1'b1;
                DOA_byte0_i = {Bits{1'bX}};
             end
             if (WEAN1_ !== 1'b1) begin
                all_core_xA(1,1);
             end
             else begin
                #0 disable TOHDOA_byte1;
                NODELAYA1 = 1'b1;
                DOA_byte1_i = {Bits{1'bX}};
             end
             if (WEAN2_ !== 1'b1) begin
                all_core_xA(2,1);
             end
             else begin
                #0 disable TOHDOA_byte2;
                NODELAYA2 = 1'b1;
                DOA_byte2_i = {Bits{1'bX}};
             end
          end
      end
      else begin
          NOT_BUS_A  = {
                         n_flag_A9,
                         n_flag_A8,
                         n_flag_A7,
                         n_flag_A6,
                         n_flag_A5,
                         n_flag_A4,
                         n_flag_A3,
                         n_flag_A2,
                         n_flag_A1,
                         n_flag_A0};

          NOT_BUS_DIA_byte0  = {
                         n_flag_DIA15,
                         n_flag_DIA14,
                         n_flag_DIA13,
                         n_flag_DIA12,
                         n_flag_DIA11,
                         n_flag_DIA10,
                         n_flag_DIA9,
                         n_flag_DIA8,
                         n_flag_DIA7,
                         n_flag_DIA6,
                         n_flag_DIA5,
                         n_flag_DIA4,
                         n_flag_DIA3,
                         n_flag_DIA2,
                         n_flag_DIA1,
                         n_flag_DIA0};

          NOT_BUS_DIA_byte1  = {
                         n_flag_DIA31,
                         n_flag_DIA30,
                         n_flag_DIA29,
                         n_flag_DIA28,
                         n_flag_DIA27,
                         n_flag_DIA26,
                         n_flag_DIA25,
                         n_flag_DIA24,
                         n_flag_DIA23,
                         n_flag_DIA22,
                         n_flag_DIA21,
                         n_flag_DIA20,
                         n_flag_DIA19,
                         n_flag_DIA18,
                         n_flag_DIA17,
                         n_flag_DIA16};

          NOT_BUS_DIA_byte2  = {
                         n_flag_DIA47,
                         n_flag_DIA46,
                         n_flag_DIA45,
                         n_flag_DIA44,
                         n_flag_DIA43,
                         n_flag_DIA42,
                         n_flag_DIA41,
                         n_flag_DIA40,
                         n_flag_DIA39,
                         n_flag_DIA38,
                         n_flag_DIA37,
                         n_flag_DIA36,
                         n_flag_DIA35,
                         n_flag_DIA34,
                         n_flag_DIA33,
                         n_flag_DIA32};

          for (i=0; i<AddressSize; i=i+1) begin
             Latch_A[i] = (NOT_BUS_A[i] !== LAST_NOT_BUS_A[i]) ? 1'bx : Latch_A[i];
          end
          for (i=0; i<Bits; i=i+1) begin
             Latch_DIA_byte0[i] = (NOT_BUS_DIA_byte0[i] !== LAST_NOT_BUS_DIA_byte0[i]) ? 1'bx : Latch_DIA_byte0[i];
             Latch_DIA_byte1[i] = (NOT_BUS_DIA_byte1[i] !== LAST_NOT_BUS_DIA_byte1[i]) ? 1'bx : Latch_DIA_byte1[i];
             Latch_DIA_byte2[i] = (NOT_BUS_DIA_byte2[i] !== LAST_NOT_BUS_DIA_byte2[i]) ? 1'bx : Latch_DIA_byte2[i];
          end
          Latch_CSA  =  (n_flag_CSA  !== LAST_n_flag_CSA)  ? 1'bx : Latch_CSA;
          Latch_WEAN0 = (n_flag_WEAN0 !== LAST_n_flag_WEAN0)  ? 1'bx : Latch_WEAN0;
          Latch_WEAN1 = (n_flag_WEAN1 !== LAST_n_flag_WEAN1)  ? 1'bx : Latch_WEAN1;
          Latch_WEAN2 = (n_flag_WEAN2 !== LAST_n_flag_WEAN2)  ? 1'bx : Latch_WEAN2;
          memory_functionA;
      end

      LAST_NOT_BUS_A                 = NOT_BUS_A;
      LAST_NOT_BUS_DIA_byte0         = NOT_BUS_DIA_byte0;
      LAST_NOT_BUS_DIA_byte1         = NOT_BUS_DIA_byte1;
      LAST_NOT_BUS_DIA_byte2         = NOT_BUS_DIA_byte2;
      LAST_n_flag_WEAN0              = n_flag_WEAN0;
      LAST_n_flag_WEAN1              = n_flag_WEAN1;
      LAST_n_flag_WEAN2              = n_flag_WEAN2;
      LAST_n_flag_CSA                = n_flag_CSA;
      LAST_n_flag_CKA_PER            = n_flag_CKA_PER;
      LAST_n_flag_CKA_MINH           = n_flag_CKA_MINH;
      LAST_n_flag_CKA_MINL           = n_flag_CKA_MINL;
    end
  endtask // end timingcheck_violationA;

  task timingcheck_violationB;
    integer i;
    begin
      // PORT B
      if ((n_flag_CKB_PER  !== LAST_n_flag_CKB_PER)  ||
          (n_flag_CKB_MINH !== LAST_n_flag_CKB_MINH) ||
          (n_flag_CKB_MINL !== LAST_n_flag_CKB_MINL)) begin
          if (CSB_ !== 1'b0) begin
             if (WEBN0_ !== 1'b1) begin
                all_core_xB(0,1);
             end
             else begin
                #0 disable TOHDOB_byte0;
                NODELAYB0 = 1'b1;
                DOB_byte0_i = {Bits{1'bX}};
             end
             if (WEBN1_ !== 1'b1) begin
                all_core_xB(1,1);
             end
             else begin
                #0 disable TOHDOB_byte1;
                NODELAYB1 = 1'b1;
                DOB_byte1_i = {Bits{1'bX}};
             end
             if (WEBN2_ !== 1'b1) begin
                all_core_xB(2,1);
             end
             else begin
                #0 disable TOHDOB_byte2;
                NODELAYB2 = 1'b1;
                DOB_byte2_i = {Bits{1'bX}};
             end
          end
      end
      else begin
          NOT_BUS_B  = {
                         n_flag_B9,
                         n_flag_B8,
                         n_flag_B7,
                         n_flag_B6,
                         n_flag_B5,
                         n_flag_B4,
                         n_flag_B3,
                         n_flag_B2,
                         n_flag_B1,
                         n_flag_B0};

          NOT_BUS_DIB_byte0  = {
                         n_flag_DIB15,
                         n_flag_DIB14,
                         n_flag_DIB13,
                         n_flag_DIB12,
                         n_flag_DIB11,
                         n_flag_DIB10,
                         n_flag_DIB9,
                         n_flag_DIB8,
                         n_flag_DIB7,
                         n_flag_DIB6,
                         n_flag_DIB5,
                         n_flag_DIB4,
                         n_flag_DIB3,
                         n_flag_DIB2,
                         n_flag_DIB1,
                         n_flag_DIB0};

          NOT_BUS_DIB_byte1  = {
                         n_flag_DIB31,
                         n_flag_DIB30,
                         n_flag_DIB29,
                         n_flag_DIB28,
                         n_flag_DIB27,
                         n_flag_DIB26,
                         n_flag_DIB25,
                         n_flag_DIB24,
                         n_flag_DIB23,
                         n_flag_DIB22,
                         n_flag_DIB21,
                         n_flag_DIB20,
                         n_flag_DIB19,
                         n_flag_DIB18,
                         n_flag_DIB17,
                         n_flag_DIB16};

          NOT_BUS_DIB_byte2  = {
                         n_flag_DIB47,
                         n_flag_DIB46,
                         n_flag_DIB45,
                         n_flag_DIB44,
                         n_flag_DIB43,
                         n_flag_DIB42,
                         n_flag_DIB41,
                         n_flag_DIB40,
                         n_flag_DIB39,
                         n_flag_DIB38,
                         n_flag_DIB37,
                         n_flag_DIB36,
                         n_flag_DIB35,
                         n_flag_DIB34,
                         n_flag_DIB33,
                         n_flag_DIB32};

          for (i=0; i<AddressSize; i=i+1) begin
             Latch_B[i] = (NOT_BUS_B[i] !== LAST_NOT_BUS_B[i]) ? 1'bx : Latch_B[i];
          end
          for (i=0; i<Bits; i=i+1) begin
             Latch_DIB_byte0[i] = (NOT_BUS_DIB_byte0[i] !== LAST_NOT_BUS_DIB_byte0[i]) ? 1'bx : Latch_DIB_byte0[i];
             Latch_DIB_byte1[i] = (NOT_BUS_DIB_byte1[i] !== LAST_NOT_BUS_DIB_byte1[i]) ? 1'bx : Latch_DIB_byte1[i];
             Latch_DIB_byte2[i] = (NOT_BUS_DIB_byte2[i] !== LAST_NOT_BUS_DIB_byte2[i]) ? 1'bx : Latch_DIB_byte2[i];
          end
          Latch_CSB  =  (n_flag_CSB  !== LAST_n_flag_CSB)  ? 1'bx : Latch_CSB;
          Latch_WEBN0 = (n_flag_WEBN0 !== LAST_n_flag_WEBN0)  ? 1'bx : Latch_WEBN0;
          Latch_WEBN1 = (n_flag_WEBN1 !== LAST_n_flag_WEBN1)  ? 1'bx : Latch_WEBN1;
          Latch_WEBN2 = (n_flag_WEBN2 !== LAST_n_flag_WEBN2)  ? 1'bx : Latch_WEBN2;
          memory_functionB;
      end

      LAST_NOT_BUS_B                 = NOT_BUS_B;
      LAST_NOT_BUS_DIB_byte0         = NOT_BUS_DIB_byte0;
      LAST_NOT_BUS_DIB_byte1         = NOT_BUS_DIB_byte1;
      LAST_NOT_BUS_DIB_byte2         = NOT_BUS_DIB_byte2;
      LAST_n_flag_WEBN0              = n_flag_WEBN0;
      LAST_n_flag_WEBN1              = n_flag_WEBN1;
      LAST_n_flag_WEBN2              = n_flag_WEBN2;
      LAST_n_flag_CSB                = n_flag_CSB;
      LAST_n_flag_CKB_PER            = n_flag_CKB_PER;
      LAST_n_flag_CKB_MINH           = n_flag_CKB_MINH;
      LAST_n_flag_CKB_MINL           = n_flag_CKB_MINL;
    end
  endtask // end timingcheck_violationB;

  task pre_latch_dataA;
    begin
      Latch_A                        = A_;
      Latch_DIA_byte0                = DIA_byte0_;
      Latch_DIA_byte1                = DIA_byte1_;
      Latch_DIA_byte2                = DIA_byte2_;
      Latch_CSA                      = CSA_;
      Latch_WEAN0                    = WEAN0_;
      Latch_WEAN1                    = WEAN1_;
      Latch_WEAN2                    = WEAN2_;
    end
  endtask //end pre_latch_dataA

  task pre_latch_dataB;
    begin
      Latch_B                        = B_;
      Latch_DIB_byte0                = DIB_byte0_;
      Latch_DIB_byte1                = DIB_byte1_;
      Latch_DIB_byte2                = DIB_byte2_;
      Latch_CSB                      = CSB_;
      Latch_WEBN0                    = WEBN0_;
      Latch_WEBN1                    = WEBN1_;
      Latch_WEBN2                    = WEBN2_;
    end
  endtask //end pre_latch_dataB

  task memory_functionA;
    begin
      A_i                            = Latch_A;
      DIA_byte0_i                    = Latch_DIA_byte0;
      DIA_byte1_i                    = Latch_DIA_byte1;
      DIA_byte2_i                    = Latch_DIA_byte2;
      WEAN0_i                        = Latch_WEAN0;
      WEAN1_i                        = Latch_WEAN1;
      WEAN2_i                        = Latch_WEAN2;
      CSA_i                          = Latch_CSA;

      if (CSA_ == 1'b1) A_monitor;


      casez({WEAN0_i,CSA_i})
        2'b11: begin
           if (AddressRangeCheck(A_i)) begin
              if ((A_i == LastCycleBAddress)&&
                  (Last_WEBN0_i == 1'b0) &&
                  ($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOA_byte0;
                  NODELAYA0 = 1'b1;
                  DOA_byte0_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                     if (A_i !== last_A) begin
                        NODELAYA0 = 1'b1;
                        DOA_byte0_tmp = Memory_byte0[A_i];
                        ->EventTOHDOA_byte0;
                     end else begin
                        NODELAYA0 = 1'b0;
                        DOA_byte0_tmp = Memory_byte0[A_i];
                        DOA_byte0_i = DOA_byte0_tmp;
                     end
                  end else begin
                     NODELAYA0 = 1'b1;
                     DOA_byte0_tmp = Memory_byte0[A_i];
                     ->EventTOHDOA_byte0;
                  end
              end
           end
           else begin
                #0 disable TOHDOA_byte0;
                NODELAYA0 = 1'b1;
                DOA_byte0_i = {Bits{1'bX}};
           end
           LastCycleAAddress = A_i;
        end
        2'b01: begin
           if (AddressRangeCheck(A_i)) begin
              if (A_i == LastCycleBAddress) begin
                 if ((Last_WEBN0_i == 1'b1)&&($time-Last_tc_ClkB_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    #0 disable TOHDOB_byte0;
                    NODELAYB0 = 1'b1;
                    DOB_byte0_i = {Bits{1'bX}};
                    Memory_byte0[A_i] = DIA_byte0_i;
                 end else if ((Last_WEBN0_i == 1'b0)&&($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory_byte0[A_i] = {Bits{1'bX}};
                 end else begin
                    Memory_byte0[A_i] = DIA_byte0_i;
                 end
              end else begin
                 Memory_byte0[A_i] = DIA_byte0_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (A_i !== last_A) begin
                    NODELAYA0 = 1'b1;
                    DOA_byte0_tmp = Memory_byte0[A_i];
                    ->EventTOHDOA_byte0;
                 end else begin
                    if (DIA_byte0_i !== last_DIA_byte0) begin
                       NODELAYA0 = 1'b1;
                       DOA_byte0_tmp = Memory_byte0[A_i];
                       ->EventTOHDOA_byte0;
                    end else begin
                      NODELAYA0 = 1'b0;
                      DOA_byte0_tmp = Memory_byte0[A_i];
                      DOA_byte0_i = DOA_byte0_tmp;
                    end
                 end
              end else begin
                 NODELAYA0 = 1'b1;
                 DOA_byte0_tmp = Memory_byte0[A_i];
                 ->EventTOHDOA_byte0;
              end
           end else begin
                all_core_xA(0,1);
           end
           LastCycleAAddress = A_i;
        end
        2'b1x: begin
           #0 disable TOHDOA_byte0;
           NODELAYA0 = 1'b1;
           DOA_byte0_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(A_i)) begin
                Memory_byte0[A_i] = {Bits{1'bX}};
                #0 disable TOHDOA_byte0;
                NODELAYA0 = 1'b1;
                DOA_byte0_i = {Bits{1'bX}};
           end else begin
                all_core_xA(0,1);
           end
        end
      endcase
      Last_WEAN0_i = WEAN0_i;

      casez({WEAN1_i,CSA_i})
        2'b11: begin
           if (AddressRangeCheck(A_i)) begin
              if ((A_i == LastCycleBAddress)&&
                  (Last_WEBN1_i == 1'b0) &&
                  ($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOA_byte1;
                  NODELAYA1 = 1'b1;
                  DOA_byte1_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                     if (A_i !== last_A) begin
                        NODELAYA1 = 1'b1;
                        DOA_byte1_tmp = Memory_byte1[A_i];
                        ->EventTOHDOA_byte1;
                     end else begin
                        NODELAYA1 = 1'b0;
                        DOA_byte1_tmp = Memory_byte1[A_i];
                        DOA_byte1_i = DOA_byte1_tmp;
                     end
                  end else begin
                     NODELAYA1 = 1'b1;
                     DOA_byte1_tmp = Memory_byte1[A_i];
                     ->EventTOHDOA_byte1;
                  end
              end
           end
           else begin
                #0 disable TOHDOA_byte1;
                NODELAYA1 = 1'b1;
                DOA_byte1_i = {Bits{1'bX}};
           end
           LastCycleAAddress = A_i;
        end
        2'b01: begin
           if (AddressRangeCheck(A_i)) begin
              if (A_i == LastCycleBAddress) begin
                 if ((Last_WEBN1_i == 1'b1)&&($time-Last_tc_ClkB_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    #0 disable TOHDOB_byte1;
                    NODELAYB1 = 1'b1;
                    DOB_byte1_i = {Bits{1'bX}};
                    Memory_byte1[A_i] = DIA_byte1_i;
                 end else if ((Last_WEBN1_i == 1'b0)&&($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory_byte1[A_i] = {Bits{1'bX}};
                 end else begin
                    Memory_byte1[A_i] = DIA_byte1_i;
                 end
              end else begin
                 Memory_byte1[A_i] = DIA_byte1_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (A_i !== last_A) begin
                    NODELAYA1 = 1'b1;
                    DOA_byte1_tmp = Memory_byte1[A_i];
                    ->EventTOHDOA_byte1;
                 end else begin
                    if (DIA_byte1_i !== last_DIA_byte1) begin
                       NODELAYA1 = 1'b1;
                       DOA_byte1_tmp = Memory_byte1[A_i];
                       ->EventTOHDOA_byte1;
                    end else begin
                      NODELAYA1 = 1'b0;
                      DOA_byte1_tmp = Memory_byte1[A_i];
                      DOA_byte1_i = DOA_byte1_tmp;
                    end
                 end
              end else begin
                 NODELAYA1 = 1'b1;
                 DOA_byte1_tmp = Memory_byte1[A_i];
                 ->EventTOHDOA_byte1;
              end
           end else begin
                all_core_xA(1,1);
           end
           LastCycleAAddress = A_i;
        end
        2'b1x: begin
           #0 disable TOHDOA_byte1;
           NODELAYA1 = 1'b1;
           DOA_byte1_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(A_i)) begin
                Memory_byte1[A_i] = {Bits{1'bX}};
                #0 disable TOHDOA_byte1;
                NODELAYA1 = 1'b1;
                DOA_byte1_i = {Bits{1'bX}};
           end else begin
                all_core_xA(1,1);
           end
        end
      endcase
      Last_WEAN1_i = WEAN1_i;

      casez({WEAN2_i,CSA_i})
        2'b11: begin
           if (AddressRangeCheck(A_i)) begin
              if ((A_i == LastCycleBAddress)&&
                  (Last_WEBN2_i == 1'b0) &&
                  ($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOA_byte2;
                  NODELAYA2 = 1'b1;
                  DOA_byte2_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                     if (A_i !== last_A) begin
                        NODELAYA2 = 1'b1;
                        DOA_byte2_tmp = Memory_byte2[A_i];
                        ->EventTOHDOA_byte2;
                     end else begin
                        NODELAYA2 = 1'b0;
                        DOA_byte2_tmp = Memory_byte2[A_i];
                        DOA_byte2_i = DOA_byte2_tmp;
                     end
                  end else begin
                     NODELAYA2 = 1'b1;
                     DOA_byte2_tmp = Memory_byte2[A_i];
                     ->EventTOHDOA_byte2;
                  end
              end
           end
           else begin
                #0 disable TOHDOA_byte2;
                NODELAYA2 = 1'b1;
                DOA_byte2_i = {Bits{1'bX}};
           end
           LastCycleAAddress = A_i;
        end
        2'b01: begin
           if (AddressRangeCheck(A_i)) begin
              if (A_i == LastCycleBAddress) begin
                 if ((Last_WEBN2_i == 1'b1)&&($time-Last_tc_ClkB_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    #0 disable TOHDOB_byte2;
                    NODELAYB2 = 1'b1;
                    DOB_byte2_i = {Bits{1'bX}};
                    Memory_byte2[A_i] = DIA_byte2_i;
                 end else if ((Last_WEBN2_i == 1'b0)&&($time-Last_tc_ClkB_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory_byte2[A_i] = {Bits{1'bX}};
                 end else begin
                    Memory_byte2[A_i] = DIA_byte2_i;
                 end
              end else begin
                 Memory_byte2[A_i] = DIA_byte2_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (A_i !== last_A) begin
                    NODELAYA2 = 1'b1;
                    DOA_byte2_tmp = Memory_byte2[A_i];
                    ->EventTOHDOA_byte2;
                 end else begin
                    if (DIA_byte2_i !== last_DIA_byte2) begin
                       NODELAYA2 = 1'b1;
                       DOA_byte2_tmp = Memory_byte2[A_i];
                       ->EventTOHDOA_byte2;
                    end else begin
                      NODELAYA2 = 1'b0;
                      DOA_byte2_tmp = Memory_byte2[A_i];
                      DOA_byte2_i = DOA_byte2_tmp;
                    end
                 end
              end else begin
                 NODELAYA2 = 1'b1;
                 DOA_byte2_tmp = Memory_byte2[A_i];
                 ->EventTOHDOA_byte2;
              end
           end else begin
                all_core_xA(2,1);
           end
           LastCycleAAddress = A_i;
        end
        2'b1x: begin
           #0 disable TOHDOA_byte2;
           NODELAYA2 = 1'b1;
           DOA_byte2_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(A_i)) begin
                Memory_byte2[A_i] = {Bits{1'bX}};
                #0 disable TOHDOA_byte2;
                NODELAYA2 = 1'b1;
                DOA_byte2_i = {Bits{1'bX}};
           end else begin
                all_core_xA(2,1);
           end
        end
      endcase
      Last_WEAN2_i = WEAN2_i;
  end
  endtask //memory_functionA;

  task memory_functionB;
    begin
      B_i                            = Latch_B;
      DIB_byte0_i                    = Latch_DIB_byte0;
      DIB_byte1_i                    = Latch_DIB_byte1;
      DIB_byte2_i                    = Latch_DIB_byte2;
      WEBN0_i                        = Latch_WEBN0;
      WEBN1_i                        = Latch_WEBN1;
      WEBN2_i                        = Latch_WEBN2;
      CSB_i                          = Latch_CSB;

      if (CSB_ == 1'b1) B_monitor;


      casez({WEBN0_i,CSB_i})
        2'b11: begin
           if (AddressRangeCheck(B_i)) begin
              if ((B_i == LastCycleAAddress)&&
                  (Last_WEAN0_i == 1'b0) &&
                  ($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOB_byte0;
                  NODELAYB0 = 1'b1;
                  DOB_byte0_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                     if (B_i !== last_B) begin
                        NODELAYB0 = 1'b1;
                        DOB_byte0_tmp = Memory_byte0[B_i];
                        ->EventTOHDOB_byte0;
                     end else begin
                        NODELAYB0 = 1'b0;
                        DOB_byte0_tmp = Memory_byte0[B_i];
                        DOB_byte0_i = DOB_byte0_tmp;
                     end
                  end else begin
                     NODELAYB0 = 1'b1;
                     DOB_byte0_tmp = Memory_byte0[B_i];
                     ->EventTOHDOB_byte0;
                  end
              end
           end
           else begin
                #0 disable TOHDOB_byte0;
                NODELAYB0 = 1'b1;
                DOB_byte0_i = {Bits{1'bX}};
           end
           LastCycleBAddress = B_i;
        end
        2'b01: begin
           if (AddressRangeCheck(B_i)) begin
              if (B_i == LastCycleAAddress) begin
                 if ((Last_WEAN0_i == 1'b1)&&($time-Last_tc_ClkA_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    #0 disable TOHDOA_byte0;
                    NODELAYA0 = 1'b1;
                    DOA_byte0_i = {Bits{1'bX}};
                    Memory_byte0[B_i] = DIB_byte0_i;
                 end else if ((Last_WEAN0_i == 1'b0)&&($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory_byte0[B_i] = {Bits{1'bX}};
                 end else begin
                    Memory_byte0[B_i] = DIB_byte0_i;
                 end
              end else begin
                 Memory_byte0[B_i] = DIB_byte0_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (B_i !== last_B) begin
                    NODELAYB0 = 1'b1;
                    DOB_byte0_tmp = Memory_byte0[B_i];
                    ->EventTOHDOB_byte0;
                 end else begin
                    if (DIB_byte0_i !== last_DIB_byte0) begin
                       NODELAYB0 = 1'b1;
                       DOB_byte0_tmp = Memory_byte0[B_i];
                       ->EventTOHDOB_byte0;
                    end else begin
                      NODELAYB0 = 1'b0;
                      DOB_byte0_tmp = Memory_byte0[B_i];
                      DOB_byte0_i = DOB_byte0_tmp;
                    end
                 end
              end else begin
                 NODELAYB0 = 1'b1;
                 DOB_byte0_tmp = Memory_byte0[B_i];
                 ->EventTOHDOB_byte0;
              end
           end else begin
                all_core_xB(0,1);
           end
           LastCycleBAddress = B_i;
        end
        2'b1x: begin
           #0 disable TOHDOB_byte0;
           NODELAYB0 = 1'b1;
           DOB_byte0_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(B_i)) begin
                Memory_byte0[B_i] = {Bits{1'bX}};
                #0 disable TOHDOB_byte0;
                NODELAYB0 = 1'b1;
                DOB_byte0_i = {Bits{1'bX}};
           end else begin
                all_core_xB(0,1);
           end
        end
      endcase
      Last_WEBN0_i = WEBN0_i;

      casez({WEBN1_i,CSB_i})
        2'b11: begin
           if (AddressRangeCheck(B_i)) begin
              if ((B_i == LastCycleAAddress)&&
                  (Last_WEAN1_i == 1'b0) &&
                  ($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOB_byte1;
                  NODELAYB1 = 1'b1;
                  DOB_byte1_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                     if (B_i !== last_B) begin
                        NODELAYB1 = 1'b1;
                        DOB_byte1_tmp = Memory_byte1[B_i];
                        ->EventTOHDOB_byte1;
                     end else begin
                        NODELAYB1 = 1'b0;
                        DOB_byte1_tmp = Memory_byte1[B_i];
                        DOB_byte1_i = DOB_byte1_tmp;
                     end
                  end else begin
                     NODELAYB1 = 1'b1;
                     DOB_byte1_tmp = Memory_byte1[B_i];
                     ->EventTOHDOB_byte1;
                  end
              end
           end
           else begin
                #0 disable TOHDOB_byte1;
                NODELAYB1 = 1'b1;
                DOB_byte1_i = {Bits{1'bX}};
           end
           LastCycleBAddress = B_i;
        end
        2'b01: begin
           if (AddressRangeCheck(B_i)) begin
              if (B_i == LastCycleAAddress) begin
                 if ((Last_WEAN1_i == 1'b1)&&($time-Last_tc_ClkA_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    #0 disable TOHDOA_byte1;
                    NODELAYA1 = 1'b1;
                    DOA_byte1_i = {Bits{1'bX}};
                    Memory_byte1[B_i] = DIB_byte1_i;
                 end else if ((Last_WEAN1_i == 1'b0)&&($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory_byte1[B_i] = {Bits{1'bX}};
                 end else begin
                    Memory_byte1[B_i] = DIB_byte1_i;
                 end
              end else begin
                 Memory_byte1[B_i] = DIB_byte1_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (B_i !== last_B) begin
                    NODELAYB1 = 1'b1;
                    DOB_byte1_tmp = Memory_byte1[B_i];
                    ->EventTOHDOB_byte1;
                 end else begin
                    if (DIB_byte1_i !== last_DIB_byte1) begin
                       NODELAYB1 = 1'b1;
                       DOB_byte1_tmp = Memory_byte1[B_i];
                       ->EventTOHDOB_byte1;
                    end else begin
                      NODELAYB1 = 1'b0;
                      DOB_byte1_tmp = Memory_byte1[B_i];
                      DOB_byte1_i = DOB_byte1_tmp;
                    end
                 end
              end else begin
                 NODELAYB1 = 1'b1;
                 DOB_byte1_tmp = Memory_byte1[B_i];
                 ->EventTOHDOB_byte1;
              end
           end else begin
                all_core_xB(1,1);
           end
           LastCycleBAddress = B_i;
        end
        2'b1x: begin
           #0 disable TOHDOB_byte1;
           NODELAYB1 = 1'b1;
           DOB_byte1_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(B_i)) begin
                Memory_byte1[B_i] = {Bits{1'bX}};
                #0 disable TOHDOB_byte1;
                NODELAYB1 = 1'b1;
                DOB_byte1_i = {Bits{1'bX}};
           end else begin
                all_core_xB(1,1);
           end
        end
      endcase
      Last_WEBN1_i = WEBN1_i;

      casez({WEBN2_i,CSB_i})
        2'b11: begin
           if (AddressRangeCheck(B_i)) begin
              if ((B_i == LastCycleAAddress)&&
                  (Last_WEAN2_i == 1'b0) &&
                  ($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                  ErrorMessage(1);
                  #0 disable TOHDOB_byte2;
                  NODELAYB2 = 1'b1;
                  DOB_byte2_i = {Bits{1'bX}};
              end else begin
                  if (NO_SER_TOH == `TRUE) begin
                     if (B_i !== last_B) begin
                        NODELAYB2 = 1'b1;
                        DOB_byte2_tmp = Memory_byte2[B_i];
                        ->EventTOHDOB_byte2;
                     end else begin
                        NODELAYB2 = 1'b0;
                        DOB_byte2_tmp = Memory_byte2[B_i];
                        DOB_byte2_i = DOB_byte2_tmp;
                     end
                  end else begin
                     NODELAYB2 = 1'b1;
                     DOB_byte2_tmp = Memory_byte2[B_i];
                     ->EventTOHDOB_byte2;
                  end
              end
           end
           else begin
                #0 disable TOHDOB_byte2;
                NODELAYB2 = 1'b1;
                DOB_byte2_i = {Bits{1'bX}};
           end
           LastCycleBAddress = B_i;
        end
        2'b01: begin
           if (AddressRangeCheck(B_i)) begin
              if (B_i == LastCycleAAddress) begin
                 if ((Last_WEAN2_i == 1'b1)&&($time-Last_tc_ClkA_PosEdge<Tr2w)) begin
                    ErrorMessage(1);
                    #0 disable TOHDOA_byte2;
                    NODELAYA2 = 1'b1;
                    DOA_byte2_i = {Bits{1'bX}};
                    Memory_byte2[B_i] = DIB_byte2_i;
                 end else if ((Last_WEAN2_i == 1'b0)&&($time-Last_tc_ClkA_PosEdge<Tw2r)) begin
                    ErrorMessage(4);
                    Memory_byte2[B_i] = {Bits{1'bX}};
                 end else begin
                    Memory_byte2[B_i] = DIB_byte2_i;
                 end
              end else begin
                 Memory_byte2[B_i] = DIB_byte2_i;
              end
              if (NO_SER_TOH == `TRUE) begin
                 if (B_i !== last_B) begin
                    NODELAYB2 = 1'b1;
                    DOB_byte2_tmp = Memory_byte2[B_i];
                    ->EventTOHDOB_byte2;
                 end else begin
                    if (DIB_byte2_i !== last_DIB_byte2) begin
                       NODELAYB2 = 1'b1;
                       DOB_byte2_tmp = Memory_byte2[B_i];
                       ->EventTOHDOB_byte2;
                    end else begin
                      NODELAYB2 = 1'b0;
                      DOB_byte2_tmp = Memory_byte2[B_i];
                      DOB_byte2_i = DOB_byte2_tmp;
                    end
                 end
              end else begin
                 NODELAYB2 = 1'b1;
                 DOB_byte2_tmp = Memory_byte2[B_i];
                 ->EventTOHDOB_byte2;
              end
           end else begin
                all_core_xB(2,1);
           end
           LastCycleBAddress = B_i;
        end
        2'b1x: begin
           #0 disable TOHDOB_byte2;
           NODELAYB2 = 1'b1;
           DOB_byte2_i = {Bits{1'bX}};
        end
        2'b0x,
        2'bx1,
        2'bxx: begin
           if (AddressRangeCheck(B_i)) begin
                Memory_byte2[B_i] = {Bits{1'bX}};
                #0 disable TOHDOB_byte2;
                NODELAYB2 = 1'b1;
                DOB_byte2_i = {Bits{1'bX}};
           end else begin
                all_core_xB(2,1);
           end
        end
      endcase
      Last_WEBN2_i = WEBN2_i;
  end
  endtask //memory_functionB;

  task all_core_xA;
     input byte_num;
     input do_x;

     integer byte_num;
     integer do_x;
     integer LoopCount_Address;
     begin
       LoopCount_Address=Words-1;
       while(LoopCount_Address >=0) begin
          case (byte_num)
             0       : begin
                         Memory_byte0[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOA_byte0;
                            NODELAYA0 = 1'b1;
                            DOA_byte0_i = {Bits{1'bX}};
                         end
                       end
             1       : begin
                         Memory_byte1[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOA_byte1;
                            NODELAYA1 = 1'b1;
                            DOA_byte1_i = {Bits{1'bX}};
                         end
                       end
             2       : begin
                         Memory_byte2[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOA_byte2;
                            NODELAYA2 = 1'b1;
                            DOA_byte2_i = {Bits{1'bX}};
                         end
                       end
             default : begin
                         Memory_byte0[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOA_byte0;
                            NODELAYA0 = 1'b1;
                            DOA_byte0_i = {Bits{1'bX}};
                         end
                         Memory_byte1[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOA_byte1;
                            NODELAYA1 = 1'b1;
                            DOA_byte1_i = {Bits{1'bX}};
                         end
                         Memory_byte2[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOA_byte2;
                            NODELAYA2 = 1'b1;
                            DOA_byte2_i = {Bits{1'bX}};
                         end
                       end
         endcase
         LoopCount_Address=LoopCount_Address-1;
      end
    end
  endtask //end all_core_xA;

  task all_core_xB;
     input byte_num;
     input do_x;

     integer byte_num;
     integer do_x;
     integer LoopCount_Address;
     begin
       LoopCount_Address=Words-1;
       while(LoopCount_Address >=0) begin
          case (byte_num)
             0       : begin
                         Memory_byte0[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOB_byte0;
                            NODELAYB0 = 1'b1;
                            DOB_byte0_i = {Bits{1'bX}};
                         end
                       end
             1       : begin
                         Memory_byte1[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOB_byte1;
                            NODELAYB1 = 1'b1;
                            DOB_byte1_i = {Bits{1'bX}};
                         end
                       end
             2       : begin
                         Memory_byte2[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOB_byte2;
                            NODELAYB2 = 1'b1;
                            DOB_byte2_i = {Bits{1'bX}};
                         end
                       end
             default : begin
                         Memory_byte0[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOB_byte0;
                            NODELAYB0 = 1'b1;
                            DOB_byte0_i = {Bits{1'bX}};
                         end
                         Memory_byte1[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOB_byte1;
                            NODELAYB1 = 1'b1;
                            DOB_byte1_i = {Bits{1'bX}};
                         end
                         Memory_byte2[LoopCount_Address]={Bits{1'bX}};
                         if (do_x == 1) begin
                            #0 disable TOHDOB_byte2;
                            NODELAYB2 = 1'b1;
                            DOB_byte2_i = {Bits{1'bX}};
                         end
                       end
         endcase
         LoopCount_Address=LoopCount_Address-1;
      end
    end
  endtask //end all_core_xB;

  task A_monitor;
     begin
       if (^(A_) !== 1'bX) begin
          flag_A_x = `FALSE;
       end
       else begin
          if (flag_A_x == `FALSE) begin
              flag_A_x = `TRUE;
              ErrorMessage(2);
          end
       end
     end
  endtask //end A_monitor;

  task B_monitor;
     begin
       if (^(B_) !== 1'bX) begin
          flag_B_x = `FALSE;
       end
       else begin
          if (flag_B_x == `FALSE) begin
              flag_B_x = `TRUE;
              ErrorMessage(2);
          end
       end
     end
  endtask //end B_monitor;

  task CSA_monitor;
     begin
       if (^(CSA_) !== 1'bX) begin
          flag_CSA_x = `FALSE;
       end
       else begin
          if (flag_CSA_x == `FALSE) begin
              flag_CSA_x = `TRUE;
              ErrorMessage(3);
          end
       end
     end
  endtask //end CSA_monitor;

  task CSB_monitor;
     begin
       if (^(CSB_) !== 1'bX) begin
          flag_CSB_x = `FALSE;
       end
       else begin
          if (flag_CSB_x == `FALSE) begin
              flag_CSB_x = `TRUE;
              ErrorMessage(3);
          end
       end
     end
  endtask //end CSB_monitor;

  task ErrorMessage;
     input error_type;
     integer error_type;

     begin
       case (error_type)
         0: $display("** MEM_Error: Abnormal transition occurred (%t) in Clock of %m",$time);
         1: $display("** MEM_Warning: Read and Write the same Address, DO is unknown (%t) in clock of %m",$time);
         2: $display("** MEM_Error: Unknown value occurred (%t) in Address of %m",$time);
         3: $display("** MEM_Error: Unknown value occurred (%t) in ChipSelect of %m",$time);
         4: $display("** MEM_Error: Port A and B write the same Address, core is unknown (%t) in clock of %m",$time);
         5: $display("** MEM_Error: Clear all memory core to unknown (%t) in clock of %m",$time);
       endcase
     end
  endtask

  function AddressRangeCheck;
      input  [AddressSize-1:0] AddressItem;
      reg    UnaryResult;
      begin
        UnaryResult = ^AddressItem;
        if(UnaryResult!==1'bX) begin
           if (AddressItem >= Words) begin
              $display("** MEM_Error: Out of range occurred (%t) in Address of %m",$time);
              AddressRangeCheck = `FALSE;
           end else begin
              AddressRangeCheck = `TRUE;
           end
        end
        else begin
           AddressRangeCheck = `FALSE;
        end
      end
  endfunction //end AddressRangeCheck;

   specify
      specparam TAA  = (140:207:350);
      specparam TRC  = (184:270:445);
      specparam THPW = (61:90:148);
      specparam TLPW = (61:90:148);
      specparam TAS  = (72:89:127);
      specparam TAH  = (11:14:19);
      specparam TWS  = (45:51:69);
      specparam TWH  = (12:16:26);
      specparam TDS  = (43:42:46);
      specparam TDH  = (16:14:8);
      specparam TCSS = (89:116:174);
      specparam TCSH = (0:0:0);
      specparam TOE  = (80:122:202);
      specparam TOZ  = (82:102:144);


      $setuphold ( posedge CKA &&& con_A,         posedge A0, TAS,     TAH,     n_flag_A0      );
      $setuphold ( posedge CKA &&& con_A,         negedge A0, TAS,     TAH,     n_flag_A0      );
      $setuphold ( posedge CKA &&& con_A,         posedge A1, TAS,     TAH,     n_flag_A1      );
      $setuphold ( posedge CKA &&& con_A,         negedge A1, TAS,     TAH,     n_flag_A1      );
      $setuphold ( posedge CKA &&& con_A,         posedge A2, TAS,     TAH,     n_flag_A2      );
      $setuphold ( posedge CKA &&& con_A,         negedge A2, TAS,     TAH,     n_flag_A2      );
      $setuphold ( posedge CKA &&& con_A,         posedge A3, TAS,     TAH,     n_flag_A3      );
      $setuphold ( posedge CKA &&& con_A,         negedge A3, TAS,     TAH,     n_flag_A3      );
      $setuphold ( posedge CKA &&& con_A,         posedge A4, TAS,     TAH,     n_flag_A4      );
      $setuphold ( posedge CKA &&& con_A,         negedge A4, TAS,     TAH,     n_flag_A4      );
      $setuphold ( posedge CKA &&& con_A,         posedge A5, TAS,     TAH,     n_flag_A5      );
      $setuphold ( posedge CKA &&& con_A,         negedge A5, TAS,     TAH,     n_flag_A5      );
      $setuphold ( posedge CKA &&& con_A,         posedge A6, TAS,     TAH,     n_flag_A6      );
      $setuphold ( posedge CKA &&& con_A,         negedge A6, TAS,     TAH,     n_flag_A6      );
      $setuphold ( posedge CKA &&& con_A,         posedge A7, TAS,     TAH,     n_flag_A7      );
      $setuphold ( posedge CKA &&& con_A,         negedge A7, TAS,     TAH,     n_flag_A7      );
      $setuphold ( posedge CKA &&& con_A,         posedge A8, TAS,     TAH,     n_flag_A8      );
      $setuphold ( posedge CKA &&& con_A,         negedge A8, TAS,     TAH,     n_flag_A8      );
      $setuphold ( posedge CKA &&& con_A,         posedge A9, TAS,     TAH,     n_flag_A9      );
      $setuphold ( posedge CKA &&& con_A,         negedge A9, TAS,     TAH,     n_flag_A9      );
      $setuphold ( posedge CKB &&& con_B,         posedge B0, TAS,     TAH,     n_flag_B0      );
      $setuphold ( posedge CKB &&& con_B,         negedge B0, TAS,     TAH,     n_flag_B0      );
      $setuphold ( posedge CKB &&& con_B,         posedge B1, TAS,     TAH,     n_flag_B1      );
      $setuphold ( posedge CKB &&& con_B,         negedge B1, TAS,     TAH,     n_flag_B1      );
      $setuphold ( posedge CKB &&& con_B,         posedge B2, TAS,     TAH,     n_flag_B2      );
      $setuphold ( posedge CKB &&& con_B,         negedge B2, TAS,     TAH,     n_flag_B2      );
      $setuphold ( posedge CKB &&& con_B,         posedge B3, TAS,     TAH,     n_flag_B3      );
      $setuphold ( posedge CKB &&& con_B,         negedge B3, TAS,     TAH,     n_flag_B3      );
      $setuphold ( posedge CKB &&& con_B,         posedge B4, TAS,     TAH,     n_flag_B4      );
      $setuphold ( posedge CKB &&& con_B,         negedge B4, TAS,     TAH,     n_flag_B4      );
      $setuphold ( posedge CKB &&& con_B,         posedge B5, TAS,     TAH,     n_flag_B5      );
      $setuphold ( posedge CKB &&& con_B,         negedge B5, TAS,     TAH,     n_flag_B5      );
      $setuphold ( posedge CKB &&& con_B,         posedge B6, TAS,     TAH,     n_flag_B6      );
      $setuphold ( posedge CKB &&& con_B,         negedge B6, TAS,     TAH,     n_flag_B6      );
      $setuphold ( posedge CKB &&& con_B,         posedge B7, TAS,     TAH,     n_flag_B7      );
      $setuphold ( posedge CKB &&& con_B,         negedge B7, TAS,     TAH,     n_flag_B7      );
      $setuphold ( posedge CKB &&& con_B,         posedge B8, TAS,     TAH,     n_flag_B8      );
      $setuphold ( posedge CKB &&& con_B,         negedge B8, TAS,     TAH,     n_flag_B8      );
      $setuphold ( posedge CKB &&& con_B,         posedge B9, TAS,     TAH,     n_flag_B9      );
      $setuphold ( posedge CKB &&& con_B,         negedge B9, TAS,     TAH,     n_flag_B9      );

      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA0, TDS,     TDH,     n_flag_DIA0    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA0, TDS,     TDH,     n_flag_DIA0    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB0, TDS,     TDH,     n_flag_DIB0    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB0, TDS,     TDH,     n_flag_DIB0    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA1, TDS,     TDH,     n_flag_DIA1    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA1, TDS,     TDH,     n_flag_DIA1    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB1, TDS,     TDH,     n_flag_DIB1    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB1, TDS,     TDH,     n_flag_DIB1    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA2, TDS,     TDH,     n_flag_DIA2    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA2, TDS,     TDH,     n_flag_DIA2    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB2, TDS,     TDH,     n_flag_DIB2    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB2, TDS,     TDH,     n_flag_DIB2    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA3, TDS,     TDH,     n_flag_DIA3    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA3, TDS,     TDH,     n_flag_DIA3    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB3, TDS,     TDH,     n_flag_DIB3    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB3, TDS,     TDH,     n_flag_DIB3    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA4, TDS,     TDH,     n_flag_DIA4    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA4, TDS,     TDH,     n_flag_DIA4    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB4, TDS,     TDH,     n_flag_DIB4    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB4, TDS,     TDH,     n_flag_DIB4    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA5, TDS,     TDH,     n_flag_DIA5    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA5, TDS,     TDH,     n_flag_DIA5    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB5, TDS,     TDH,     n_flag_DIB5    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB5, TDS,     TDH,     n_flag_DIB5    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA6, TDS,     TDH,     n_flag_DIA6    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA6, TDS,     TDH,     n_flag_DIA6    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB6, TDS,     TDH,     n_flag_DIB6    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB6, TDS,     TDH,     n_flag_DIB6    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA7, TDS,     TDH,     n_flag_DIA7    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA7, TDS,     TDH,     n_flag_DIA7    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB7, TDS,     TDH,     n_flag_DIB7    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB7, TDS,     TDH,     n_flag_DIB7    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA8, TDS,     TDH,     n_flag_DIA8    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA8, TDS,     TDH,     n_flag_DIA8    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB8, TDS,     TDH,     n_flag_DIB8    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB8, TDS,     TDH,     n_flag_DIB8    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA9, TDS,     TDH,     n_flag_DIA9    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA9, TDS,     TDH,     n_flag_DIA9    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB9, TDS,     TDH,     n_flag_DIB9    );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB9, TDS,     TDH,     n_flag_DIB9    );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA10, TDS,     TDH,     n_flag_DIA10   );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA10, TDS,     TDH,     n_flag_DIA10   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB10, TDS,     TDH,     n_flag_DIB10   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB10, TDS,     TDH,     n_flag_DIB10   );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA11, TDS,     TDH,     n_flag_DIA11   );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA11, TDS,     TDH,     n_flag_DIA11   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB11, TDS,     TDH,     n_flag_DIB11   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB11, TDS,     TDH,     n_flag_DIB11   );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA12, TDS,     TDH,     n_flag_DIA12   );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA12, TDS,     TDH,     n_flag_DIA12   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB12, TDS,     TDH,     n_flag_DIB12   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB12, TDS,     TDH,     n_flag_DIB12   );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA13, TDS,     TDH,     n_flag_DIA13   );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA13, TDS,     TDH,     n_flag_DIA13   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB13, TDS,     TDH,     n_flag_DIB13   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB13, TDS,     TDH,     n_flag_DIB13   );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA14, TDS,     TDH,     n_flag_DIA14   );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA14, TDS,     TDH,     n_flag_DIA14   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB14, TDS,     TDH,     n_flag_DIB14   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB14, TDS,     TDH,     n_flag_DIB14   );
      $setuphold ( posedge CKA &&& con_DIA_byte0, posedge DIA15, TDS,     TDH,     n_flag_DIA15   );
      $setuphold ( posedge CKA &&& con_DIA_byte0, negedge DIA15, TDS,     TDH,     n_flag_DIA15   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, posedge DIB15, TDS,     TDH,     n_flag_DIB15   );
      $setuphold ( posedge CKB &&& con_DIB_byte0, negedge DIB15, TDS,     TDH,     n_flag_DIB15   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA16, TDS,     TDH,     n_flag_DIA16   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA16, TDS,     TDH,     n_flag_DIA16   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB16, TDS,     TDH,     n_flag_DIB16   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB16, TDS,     TDH,     n_flag_DIB16   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA17, TDS,     TDH,     n_flag_DIA17   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA17, TDS,     TDH,     n_flag_DIA17   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB17, TDS,     TDH,     n_flag_DIB17   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB17, TDS,     TDH,     n_flag_DIB17   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA18, TDS,     TDH,     n_flag_DIA18   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA18, TDS,     TDH,     n_flag_DIA18   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB18, TDS,     TDH,     n_flag_DIB18   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB18, TDS,     TDH,     n_flag_DIB18   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA19, TDS,     TDH,     n_flag_DIA19   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA19, TDS,     TDH,     n_flag_DIA19   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB19, TDS,     TDH,     n_flag_DIB19   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB19, TDS,     TDH,     n_flag_DIB19   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA20, TDS,     TDH,     n_flag_DIA20   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA20, TDS,     TDH,     n_flag_DIA20   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB20, TDS,     TDH,     n_flag_DIB20   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB20, TDS,     TDH,     n_flag_DIB20   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA21, TDS,     TDH,     n_flag_DIA21   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA21, TDS,     TDH,     n_flag_DIA21   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB21, TDS,     TDH,     n_flag_DIB21   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB21, TDS,     TDH,     n_flag_DIB21   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA22, TDS,     TDH,     n_flag_DIA22   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA22, TDS,     TDH,     n_flag_DIA22   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB22, TDS,     TDH,     n_flag_DIB22   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB22, TDS,     TDH,     n_flag_DIB22   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA23, TDS,     TDH,     n_flag_DIA23   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA23, TDS,     TDH,     n_flag_DIA23   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB23, TDS,     TDH,     n_flag_DIB23   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB23, TDS,     TDH,     n_flag_DIB23   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA24, TDS,     TDH,     n_flag_DIA24   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA24, TDS,     TDH,     n_flag_DIA24   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB24, TDS,     TDH,     n_flag_DIB24   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB24, TDS,     TDH,     n_flag_DIB24   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA25, TDS,     TDH,     n_flag_DIA25   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA25, TDS,     TDH,     n_flag_DIA25   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB25, TDS,     TDH,     n_flag_DIB25   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB25, TDS,     TDH,     n_flag_DIB25   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA26, TDS,     TDH,     n_flag_DIA26   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA26, TDS,     TDH,     n_flag_DIA26   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB26, TDS,     TDH,     n_flag_DIB26   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB26, TDS,     TDH,     n_flag_DIB26   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA27, TDS,     TDH,     n_flag_DIA27   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA27, TDS,     TDH,     n_flag_DIA27   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB27, TDS,     TDH,     n_flag_DIB27   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB27, TDS,     TDH,     n_flag_DIB27   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA28, TDS,     TDH,     n_flag_DIA28   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA28, TDS,     TDH,     n_flag_DIA28   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB28, TDS,     TDH,     n_flag_DIB28   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB28, TDS,     TDH,     n_flag_DIB28   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA29, TDS,     TDH,     n_flag_DIA29   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA29, TDS,     TDH,     n_flag_DIA29   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB29, TDS,     TDH,     n_flag_DIB29   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB29, TDS,     TDH,     n_flag_DIB29   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA30, TDS,     TDH,     n_flag_DIA30   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA30, TDS,     TDH,     n_flag_DIA30   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB30, TDS,     TDH,     n_flag_DIB30   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB30, TDS,     TDH,     n_flag_DIB30   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, posedge DIA31, TDS,     TDH,     n_flag_DIA31   );
      $setuphold ( posedge CKA &&& con_DIA_byte1, negedge DIA31, TDS,     TDH,     n_flag_DIA31   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, posedge DIB31, TDS,     TDH,     n_flag_DIB31   );
      $setuphold ( posedge CKB &&& con_DIB_byte1, negedge DIB31, TDS,     TDH,     n_flag_DIB31   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA32, TDS,     TDH,     n_flag_DIA32   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA32, TDS,     TDH,     n_flag_DIA32   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB32, TDS,     TDH,     n_flag_DIB32   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB32, TDS,     TDH,     n_flag_DIB32   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA33, TDS,     TDH,     n_flag_DIA33   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA33, TDS,     TDH,     n_flag_DIA33   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB33, TDS,     TDH,     n_flag_DIB33   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB33, TDS,     TDH,     n_flag_DIB33   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA34, TDS,     TDH,     n_flag_DIA34   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA34, TDS,     TDH,     n_flag_DIA34   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB34, TDS,     TDH,     n_flag_DIB34   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB34, TDS,     TDH,     n_flag_DIB34   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA35, TDS,     TDH,     n_flag_DIA35   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA35, TDS,     TDH,     n_flag_DIA35   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB35, TDS,     TDH,     n_flag_DIB35   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB35, TDS,     TDH,     n_flag_DIB35   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA36, TDS,     TDH,     n_flag_DIA36   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA36, TDS,     TDH,     n_flag_DIA36   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB36, TDS,     TDH,     n_flag_DIB36   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB36, TDS,     TDH,     n_flag_DIB36   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA37, TDS,     TDH,     n_flag_DIA37   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA37, TDS,     TDH,     n_flag_DIA37   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB37, TDS,     TDH,     n_flag_DIB37   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB37, TDS,     TDH,     n_flag_DIB37   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA38, TDS,     TDH,     n_flag_DIA38   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA38, TDS,     TDH,     n_flag_DIA38   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB38, TDS,     TDH,     n_flag_DIB38   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB38, TDS,     TDH,     n_flag_DIB38   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA39, TDS,     TDH,     n_flag_DIA39   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA39, TDS,     TDH,     n_flag_DIA39   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB39, TDS,     TDH,     n_flag_DIB39   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB39, TDS,     TDH,     n_flag_DIB39   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA40, TDS,     TDH,     n_flag_DIA40   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA40, TDS,     TDH,     n_flag_DIA40   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB40, TDS,     TDH,     n_flag_DIB40   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB40, TDS,     TDH,     n_flag_DIB40   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA41, TDS,     TDH,     n_flag_DIA41   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA41, TDS,     TDH,     n_flag_DIA41   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB41, TDS,     TDH,     n_flag_DIB41   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB41, TDS,     TDH,     n_flag_DIB41   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA42, TDS,     TDH,     n_flag_DIA42   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA42, TDS,     TDH,     n_flag_DIA42   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB42, TDS,     TDH,     n_flag_DIB42   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB42, TDS,     TDH,     n_flag_DIB42   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA43, TDS,     TDH,     n_flag_DIA43   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA43, TDS,     TDH,     n_flag_DIA43   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB43, TDS,     TDH,     n_flag_DIB43   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB43, TDS,     TDH,     n_flag_DIB43   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA44, TDS,     TDH,     n_flag_DIA44   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA44, TDS,     TDH,     n_flag_DIA44   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB44, TDS,     TDH,     n_flag_DIB44   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB44, TDS,     TDH,     n_flag_DIB44   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA45, TDS,     TDH,     n_flag_DIA45   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA45, TDS,     TDH,     n_flag_DIA45   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB45, TDS,     TDH,     n_flag_DIB45   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB45, TDS,     TDH,     n_flag_DIB45   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA46, TDS,     TDH,     n_flag_DIA46   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA46, TDS,     TDH,     n_flag_DIA46   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB46, TDS,     TDH,     n_flag_DIB46   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB46, TDS,     TDH,     n_flag_DIB46   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, posedge DIA47, TDS,     TDH,     n_flag_DIA47   );
      $setuphold ( posedge CKA &&& con_DIA_byte2, negedge DIA47, TDS,     TDH,     n_flag_DIA47   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, posedge DIB47, TDS,     TDH,     n_flag_DIB47   );
      $setuphold ( posedge CKB &&& con_DIB_byte2, negedge DIB47, TDS,     TDH,     n_flag_DIB47   );

      $setuphold ( posedge CKA &&& con_WEAN0,     posedge WEAN0, TWS,     TWH,     n_flag_WEAN0   );
      $setuphold ( posedge CKA &&& con_WEAN0,     negedge WEAN0, TWS,     TWH,     n_flag_WEAN0   );
      $setuphold ( posedge CKA &&& con_WEAN1,     posedge WEAN1, TWS,     TWH,     n_flag_WEAN1   );
      $setuphold ( posedge CKA &&& con_WEAN1,     negedge WEAN1, TWS,     TWH,     n_flag_WEAN1   );
      $setuphold ( posedge CKA &&& con_WEAN2,     posedge WEAN2, TWS,     TWH,     n_flag_WEAN2   );
      $setuphold ( posedge CKA &&& con_WEAN2,     negedge WEAN2, TWS,     TWH,     n_flag_WEAN2   );
      $setuphold ( posedge CKB &&& con_WEBN0,     posedge WEBN0, TWS,     TWH,     n_flag_WEBN0   );
      $setuphold ( posedge CKB &&& con_WEBN0,     negedge WEBN0, TWS,     TWH,     n_flag_WEBN0   );
      $setuphold ( posedge CKB &&& con_WEBN1,     posedge WEBN1, TWS,     TWH,     n_flag_WEBN1   );
      $setuphold ( posedge CKB &&& con_WEBN1,     negedge WEBN1, TWS,     TWH,     n_flag_WEBN1   );
      $setuphold ( posedge CKB &&& con_WEBN2,     posedge WEBN2, TWS,     TWH,     n_flag_WEBN2   );
      $setuphold ( posedge CKB &&& con_WEBN2,     negedge WEBN2, TWS,     TWH,     n_flag_WEBN2   );
      $setuphold ( posedge CKA,                   posedge CSA, TCSS,    TCSH,    n_flag_CSA     );
      $setuphold ( posedge CKA,                   negedge CSA, TCSS,    TCSH,    n_flag_CSA     );
      $setuphold ( posedge CKB,                   posedge CSB, TCSS,    TCSH,    n_flag_CSB     );
      $setuphold ( posedge CKB,                   negedge CSB, TCSS,    TCSH,    n_flag_CSB     );
      $period    ( posedge CKA &&& con_CKA,       TRC,                       n_flag_CKA_PER );
      $width     ( posedge CKA &&& con_CKA,       THPW,    0,                n_flag_CKA_MINH);
      $width     ( negedge CKA &&& con_CKA,       TLPW,    0,                n_flag_CKA_MINL);
      $period    ( posedge CKB &&& con_CKB,       TRC,                       n_flag_CKB_PER );
      $width     ( posedge CKB &&& con_CKB,       THPW,    0,                n_flag_CKB_MINH);
      $width     ( negedge CKB &&& con_CKB,       TLPW,    0,                n_flag_CKB_MINL);

      if (NODELAYA0 == 0)  (posedge CKA => (DOA0 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB0 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA1 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB1 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA2 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB2 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA3 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB3 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA4 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB4 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA5 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB5 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA6 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB6 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA7 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB7 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA8 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB8 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA9 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB9 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA10 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB10 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA11 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB11 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA12 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB12 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA13 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB13 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA14 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB14 :1'bx)) = TAA  ;
      if (NODELAYA0 == 0)  (posedge CKA => (DOA15 :1'bx)) = TAA  ;
      if (NODELAYB0 == 0)  (posedge CKB => (DOB15 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA16 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB16 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA17 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB17 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA18 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB18 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA19 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB19 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA20 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB20 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA21 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB21 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA22 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB22 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA23 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB23 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA24 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB24 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA25 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB25 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA26 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB26 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA27 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB27 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA28 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB28 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA29 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB29 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA30 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB30 :1'bx)) = TAA  ;
      if (NODELAYA1 == 0)  (posedge CKA => (DOA31 :1'bx)) = TAA  ;
      if (NODELAYB1 == 0)  (posedge CKB => (DOB31 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA32 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB32 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA33 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB33 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA34 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB34 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA35 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB35 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA36 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB36 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA37 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB37 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA38 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB38 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA39 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB39 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA40 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB40 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA41 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB41 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA42 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB42 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA43 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB43 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA44 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB44 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA45 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB45 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA46 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB46 :1'bx)) = TAA  ;
      if (NODELAYA2 == 0)  (posedge CKA => (DOA47 :1'bx)) = TAA  ;
      if (NODELAYB2 == 0)  (posedge CKB => (DOB47 :1'bx)) = TAA  ;


      (OEA => DOA0) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB0) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA1) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB1) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA2) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB2) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA3) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB3) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA4) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB4) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA5) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB5) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA6) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB6) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA7) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB7) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA8) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB8) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA9) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB9) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA10) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB10) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA11) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB11) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA12) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB12) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA13) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB13) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA14) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB14) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA15) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB15) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA16) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB16) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA17) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB17) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA18) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB18) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA19) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB19) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA20) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB20) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA21) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB21) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA22) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB22) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA23) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB23) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA24) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB24) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA25) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB25) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA26) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB26) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA27) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB27) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA28) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB28) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA29) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB29) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA30) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB30) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA31) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB31) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA32) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB32) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA33) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB33) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA34) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB34) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA35) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB35) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA36) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB36) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA37) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB37) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA38) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB38) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA39) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB39) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA40) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB40) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA41) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB41) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA42) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB42) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA43) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB43) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA44) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB44) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA45) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB45) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA46) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB46) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEA => DOA47) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
      (OEB => DOB47) = (TOE,  TOE,  TOZ,  TOE,  TOZ,  TOE  );
   endspecify

`endprotect
endmodule
