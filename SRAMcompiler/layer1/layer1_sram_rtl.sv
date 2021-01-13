module layer1_sram (A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,B0,B1,B2,B3,B4,B5,
                    B6,B7,B8,B9,DOA0,DOA1,DOA2,DOA3,DOA4,DOA5,DOA6,
                    DOA7,DOA8,DOA9,DOA10,DOA11,DOA12,DOA13,
                    DOA14,DOA15,DOA16,DOA17,DOA18,DOA19,DOA20,
                    DOA21,DOA22,DOA23,DOA24,DOA25,DOA26,DOA27,
                    DOA28,DOA29,DOA30,DOA31,DOA32,DOA33,DOA34,
                    DOA35,DOA36,DOA37,DOA38,DOA39,DOA40,DOA41,
                    DOA42,DOA43,DOA44,DOA45,DOA46,DOA47,DOA48,
                    DOA49,DOA50,DOA51,DOA52,DOA53,DOA54,DOA55,
                    DOA56,DOA57,DOA58,DOA59,DOA60,DOA61,DOA62,
                    DOA63,DOA64,DOA65,DOA66,DOA67,DOA68,DOA69,
                    DOA70,DOA71,DOA72,DOA73,DOA74,DOA75,DOA76,
                    DOA77,DOA78,DOA79,DOA80,DOA81,DOA82,DOA83,
                    DOA84,DOA85,DOA86,DOA87,DOA88,DOA89,DOA90,
                    DOA91,DOA92,DOA93,DOA94,DOA95,DOA96,DOA97,
                    DOA98,DOA99,DOA100,DOA101,DOA102,DOA103,
                    DOA104,DOA105,DOA106,DOA107,DOA108,DOA109,
                    DOA110,DOA111,DOA112,DOA113,DOA114,DOA115,
                    DOA116,DOA117,DOA118,DOA119,DOA120,DOA121,
                    DOA122,DOA123,DOA124,DOA125,DOA126,DOA127,
                    DOB0,DOB1,DOB2,DOB3,DOB4,DOB5,DOB6,DOB7,
                    DOB8,DOB9,DOB10,DOB11,DOB12,DOB13,DOB14,
                    DOB15,DOB16,DOB17,DOB18,DOB19,DOB20,DOB21,
                    DOB22,DOB23,DOB24,DOB25,DOB26,DOB27,DOB28,
                    DOB29,DOB30,DOB31,DOB32,DOB33,DOB34,DOB35,
                    DOB36,DOB37,DOB38,DOB39,DOB40,DOB41,DOB42,
                    DOB43,DOB44,DOB45,DOB46,DOB47,DOB48,DOB49,
                    DOB50,DOB51,DOB52,DOB53,DOB54,DOB55,DOB56,
                    DOB57,DOB58,DOB59,DOB60,DOB61,DOB62,DOB63,
                    DOB64,DOB65,DOB66,DOB67,DOB68,DOB69,DOB70,
                    DOB71,DOB72,DOB73,DOB74,DOB75,DOB76,DOB77,
                    DOB78,DOB79,DOB80,DOB81,DOB82,DOB83,DOB84,
                    DOB85,DOB86,DOB87,DOB88,DOB89,DOB90,DOB91,
                    DOB92,DOB93,DOB94,DOB95,DOB96,DOB97,DOB98,
                    DOB99,DOB100,DOB101,DOB102,DOB103,DOB104,
                    DOB105,DOB106,DOB107,DOB108,DOB109,DOB110,
                    DOB111,DOB112,DOB113,DOB114,DOB115,DOB116,
                    DOB117,DOB118,DOB119,DOB120,DOB121,DOB122,
                    DOB123,DOB124,DOB125,DOB126,DOB127,DIA0,
                    DIA1,DIA2,DIA3,DIA4,DIA5,DIA6,DIA7,DIA8,
                    DIA9,DIA10,DIA11,DIA12,DIA13,DIA14,DIA15,
                    DIA16,DIA17,DIA18,DIA19,DIA20,DIA21,DIA22,
                    DIA23,DIA24,DIA25,DIA26,DIA27,DIA28,DIA29,
                    DIA30,DIA31,DIA32,DIA33,DIA34,DIA35,DIA36,
                    DIA37,DIA38,DIA39,DIA40,DIA41,DIA42,DIA43,
                    DIA44,DIA45,DIA46,DIA47,DIA48,DIA49,DIA50,
                    DIA51,DIA52,DIA53,DIA54,DIA55,DIA56,DIA57,
                    DIA58,DIA59,DIA60,DIA61,DIA62,DIA63,DIA64,
                    DIA65,DIA66,DIA67,DIA68,DIA69,DIA70,DIA71,
                    DIA72,DIA73,DIA74,DIA75,DIA76,DIA77,DIA78,
                    DIA79,DIA80,DIA81,DIA82,DIA83,DIA84,DIA85,
                    DIA86,DIA87,DIA88,DIA89,DIA90,DIA91,DIA92,
                    DIA93,DIA94,DIA95,DIA96,DIA97,DIA98,DIA99,
                    DIA100,DIA101,DIA102,DIA103,DIA104,DIA105,
                    DIA106,DIA107,DIA108,DIA109,DIA110,DIA111,
                    DIA112,DIA113,DIA114,DIA115,DIA116,DIA117,
                    DIA118,DIA119,DIA120,DIA121,DIA122,DIA123,
                    DIA124,DIA125,DIA126,DIA127,DIB0,DIB1,
                    DIB2,DIB3,DIB4,DIB5,DIB6,DIB7,DIB8,DIB9,
                    DIB10,DIB11,DIB12,DIB13,DIB14,DIB15,DIB16,
                    DIB17,DIB18,DIB19,DIB20,DIB21,DIB22,DIB23,
                    DIB24,DIB25,DIB26,DIB27,DIB28,DIB29,DIB30,
                    DIB31,DIB32,DIB33,DIB34,DIB35,DIB36,DIB37,
                    DIB38,DIB39,DIB40,DIB41,DIB42,DIB43,DIB44,
                    DIB45,DIB46,DIB47,DIB48,DIB49,DIB50,DIB51,
                    DIB52,DIB53,DIB54,DIB55,DIB56,DIB57,DIB58,
                    DIB59,DIB60,DIB61,DIB62,DIB63,DIB64,DIB65,
                    DIB66,DIB67,DIB68,DIB69,DIB70,DIB71,DIB72,
                    DIB73,DIB74,DIB75,DIB76,DIB77,DIB78,DIB79,
                    DIB80,DIB81,DIB82,DIB83,DIB84,DIB85,DIB86,
                    DIB87,DIB88,DIB89,DIB90,DIB91,DIB92,DIB93,
                    DIB94,DIB95,DIB96,DIB97,DIB98,DIB99,DIB100,
                    DIB101,DIB102,DIB103,DIB104,DIB105,DIB106,
                    DIB107,DIB108,DIB109,DIB110,DIB111,DIB112,
                    DIB113,DIB114,DIB115,DIB116,DIB117,DIB118,
                    DIB119,DIB120,DIB121,DIB122,DIB123,DIB124,
                    DIB125,DIB126,DIB127,WEAN,WEBN,CKA,CKB,CSA,CSB,OEA,OEB);
		 output     DOA0,DOA1,DOA2,DOA3,DOA4,DOA5,DOA6,DOA7,DOA8,
             DOA9,DOA10,DOA11,DOA12,DOA13,DOA14,DOA15,DOA16,DOA17,DOA18,
             DOA19,DOA20,DOA21,DOA22,DOA23,DOA24,DOA25,DOA26,DOA27,DOA28,
             DOA29,DOA30,DOA31,DOA32,DOA33,DOA34,DOA35,DOA36,DOA37,DOA38,
             DOA39,DOA40,DOA41,DOA42,DOA43,DOA44,DOA45,DOA46,DOA47,DOA48,
             DOA49,DOA50,DOA51,DOA52,DOA53,DOA54,DOA55,DOA56,DOA57,DOA58,
             DOA59,DOA60,DOA61,DOA62,DOA63,DOA64,DOA65,DOA66,DOA67,DOA68,
             DOA69,DOA70,DOA71,DOA72,DOA73,DOA74,DOA75,DOA76,DOA77,DOA78,
             DOA79,DOA80,DOA81,DOA82,DOA83,DOA84,DOA85,DOA86,DOA87,DOA88,
             DOA89,DOA90,DOA91,DOA92,DOA93,DOA94,DOA95,DOA96,DOA97,DOA98,
             DOA99,DOA100,DOA101,DOA102,DOA103,DOA104,DOA105,DOA106,DOA107,DOA108,
             DOA109,DOA110,DOA111,DOA112,DOA113,DOA114,DOA115,DOA116,DOA117,DOA118,
             DOA119,DOA120,DOA121,DOA122,DOA123,DOA124,DOA125,DOA126,DOA127;
  output     DOB0,DOB1,DOB2,DOB3,DOB4,DOB5,DOB6,DOB7,DOB8,
             DOB9,DOB10,DOB11,DOB12,DOB13,DOB14,DOB15,DOB16,DOB17,DOB18,
             DOB19,DOB20,DOB21,DOB22,DOB23,DOB24,DOB25,DOB26,DOB27,DOB28,
             DOB29,DOB30,DOB31,DOB32,DOB33,DOB34,DOB35,DOB36,DOB37,DOB38,
             DOB39,DOB40,DOB41,DOB42,DOB43,DOB44,DOB45,DOB46,DOB47,DOB48,
             DOB49,DOB50,DOB51,DOB52,DOB53,DOB54,DOB55,DOB56,DOB57,DOB58,
             DOB59,DOB60,DOB61,DOB62,DOB63,DOB64,DOB65,DOB66,DOB67,DOB68,
             DOB69,DOB70,DOB71,DOB72,DOB73,DOB74,DOB75,DOB76,DOB77,DOB78,
             DOB79,DOB80,DOB81,DOB82,DOB83,DOB84,DOB85,DOB86,DOB87,DOB88,
             DOB89,DOB90,DOB91,DOB92,DOB93,DOB94,DOB95,DOB96,DOB97,DOB98,
             DOB99,DOB100,DOB101,DOB102,DOB103,DOB104,DOB105,DOB106,DOB107,DOB108,
             DOB109,DOB110,DOB111,DOB112,DOB113,DOB114,DOB115,DOB116,DOB117,DOB118,
             DOB119,DOB120,DOB121,DOB122,DOB123,DOB124,DOB125,DOB126,DOB127;
  input      DIA0,DIA1,DIA2,DIA3,DIA4,DIA5,DIA6,DIA7,DIA8,
             DIA9,DIA10,DIA11,DIA12,DIA13,DIA14,DIA15,DIA16,DIA17,DIA18,
             DIA19,DIA20,DIA21,DIA22,DIA23,DIA24,DIA25,DIA26,DIA27,DIA28,
             DIA29,DIA30,DIA31,DIA32,DIA33,DIA34,DIA35,DIA36,DIA37,DIA38,
             DIA39,DIA40,DIA41,DIA42,DIA43,DIA44,DIA45,DIA46,DIA47,DIA48,
             DIA49,DIA50,DIA51,DIA52,DIA53,DIA54,DIA55,DIA56,DIA57,DIA58,
             DIA59,DIA60,DIA61,DIA62,DIA63,DIA64,DIA65,DIA66,DIA67,DIA68,
             DIA69,DIA70,DIA71,DIA72,DIA73,DIA74,DIA75,DIA76,DIA77,DIA78,
             DIA79,DIA80,DIA81,DIA82,DIA83,DIA84,DIA85,DIA86,DIA87,DIA88,
             DIA89,DIA90,DIA91,DIA92,DIA93,DIA94,DIA95,DIA96,DIA97,DIA98,
             DIA99,DIA100,DIA101,DIA102,DIA103,DIA104,DIA105,DIA106,DIA107,DIA108,
             DIA109,DIA110,DIA111,DIA112,DIA113,DIA114,DIA115,DIA116,DIA117,DIA118,
             DIA119,DIA120,DIA121,DIA122,DIA123,DIA124,DIA125,DIA126,DIA127;
  input      DIB0,DIB1,DIB2,DIB3,DIB4,DIB5,DIB6,DIB7,DIB8,
             DIB9,DIB10,DIB11,DIB12,DIB13,DIB14,DIB15,DIB16,DIB17,DIB18,
             DIB19,DIB20,DIB21,DIB22,DIB23,DIB24,DIB25,DIB26,DIB27,DIB28,
             DIB29,DIB30,DIB31,DIB32,DIB33,DIB34,DIB35,DIB36,DIB37,DIB38,
             DIB39,DIB40,DIB41,DIB42,DIB43,DIB44,DIB45,DIB46,DIB47,DIB48,
             DIB49,DIB50,DIB51,DIB52,DIB53,DIB54,DIB55,DIB56,DIB57,DIB58,
             DIB59,DIB60,DIB61,DIB62,DIB63,DIB64,DIB65,DIB66,DIB67,DIB68,
             DIB69,DIB70,DIB71,DIB72,DIB73,DIB74,DIB75,DIB76,DIB77,DIB78,
             DIB79,DIB80,DIB81,DIB82,DIB83,DIB84,DIB85,DIB86,DIB87,DIB88,
             DIB89,DIB90,DIB91,DIB92,DIB93,DIB94,DIB95,DIB96,DIB97,DIB98,
             DIB99,DIB100,DIB101,DIB102,DIB103,DIB104,DIB105,DIB106,DIB107,DIB108,
             DIB109,DIB110,DIB111,DIB112,DIB113,DIB114,DIB115,DIB116,DIB117,DIB118,
             DIB119,DIB120,DIB121,DIB122,DIB123,DIB124,DIB125,DIB126,DIB127;
  input      A0,A1,A2,A3,A4,A5,A6,A7,A8,
             A9;
  input      B0,B1,B2,B3,B4,B5,B6,B7,B8,
             B9;
  input      OEA;                                     
  input      OEB;                                     
  input      WEAN;                                    
  input      WEBN;                                    
  input      CKA;                                     
  input      CKB;                                     
  input      CSA;                                     
  input      CSB; 
  parameter  AddressSize          = 10;               
  parameter  Bits                 = 128;              
  parameter  Words                = 912;              
  parameter  Bytes                = 1;
  logic      [Bits-1:0]           Memory [Words-1:0]; 
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
  assign     DOA48                 = DOA[48];
  assign     DOA49                 = DOA[49];
  assign     DOA50                 = DOA[50];
  assign     DOA51                 = DOA[51];
  assign     DOA52                 = DOA[52];
  assign     DOA53                 = DOA[53];
  assign     DOA54                 = DOA[54];
  assign     DOA55                 = DOA[55];
  assign     DOA56                 = DOA[56];
  assign     DOA57                 = DOA[57];
  assign     DOA58                 = DOA[58];
  assign     DOA59                 = DOA[59];
  assign     DOA60                 = DOA[60];
  assign     DOA61                 = DOA[61];
  assign     DOA62                 = DOA[62];
  assign     DOA63                 = DOA[63];
  assign     DOA64                 = DOA[64];
  assign     DOA65                 = DOA[65];
  assign     DOA66                 = DOA[66];
  assign     DOA67                 = DOA[67];
  assign     DOA68                 = DOA[68];
  assign     DOA69                 = DOA[69];
  assign     DOA70                 = DOA[70];
  assign     DOA71                 = DOA[71];
  assign     DOA72                 = DOA[72];
  assign     DOA73                 = DOA[73];
  assign     DOA74                 = DOA[74];
  assign     DOA75                 = DOA[75];
  assign     DOA76                 = DOA[76];
  assign     DOA77                 = DOA[77];
  assign     DOA78                 = DOA[78];
  assign     DOA79                 = DOA[79];
  assign     DOA80                 = DOA[80];
  assign     DOA81                 = DOA[81];
  assign     DOA82                 = DOA[82];
  assign     DOA83                 = DOA[83];
  assign     DOA84                 = DOA[84];
  assign     DOA85                 = DOA[85];
  assign     DOA86                 = DOA[86];
  assign     DOA87                 = DOA[87];
  assign     DOA88                 = DOA[88];
  assign     DOA89                 = DOA[89];
  assign     DOA90                 = DOA[90];
  assign     DOA91                 = DOA[91];
  assign     DOA92                 = DOA[92];
  assign     DOA93                 = DOA[93];
  assign     DOA94                 = DOA[94];
  assign     DOA95                 = DOA[95];
  assign     DOA96                 = DOA[96];
  assign     DOA97                 = DOA[97];
  assign     DOA98                 = DOA[98];
  assign     DOA99                 = DOA[99];
  assign     DOA100                 = DOA[100];
  assign     DOA101                 = DOA[101];
  assign     DOA102                 = DOA[102];
  assign     DOA103                 = DOA[103];
  assign     DOA104                 = DOA[104];
  assign     DOA105                 = DOA[105];
  assign     DOA106                 = DOA[106];
  assign     DOA107                 = DOA[107];
  assign     DOA108                 = DOA[108];
  assign     DOA109                 = DOA[109];
  assign     DOA110                 = DOA[110];
  assign     DOA111                 = DOA[111];
  assign     DOA112                 = DOA[112];
  assign     DOA113                 = DOA[113];
  assign     DOA114                 = DOA[114];
  assign     DOA115                 = DOA[115];
  assign     DOA116                 = DOA[116];
  assign     DOA117                 = DOA[117];
  assign     DOA118                 = DOA[118];
  assign     DOA119                 = DOA[119];
  assign     DOA120                 = DOA[120];
  assign     DOA121                 = DOA[121];
  assign     DOA122                 = DOA[122];
  assign     DOA123                 = DOA[123];
  assign     DOA124                 = DOA[124];
  assign     DOA125                 = DOA[125];
  assign     DOA126                 = DOA[126];
  assign     DOA127                 = DOA[127];
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
  assign     DOB48                 = DOB[48];
  assign     DOB49                 = DOB[49];
  assign     DOB50                 = DOB[50];
  assign     DOB51                 = DOB[51];
  assign     DOB52                 = DOB[52];
  assign     DOB53                 = DOB[53];
  assign     DOB54                 = DOB[54];
  assign     DOB55                 = DOB[55];
  assign     DOB56                 = DOB[56];
  assign     DOB57                 = DOB[57];
  assign     DOB58                 = DOB[58];
  assign     DOB59                 = DOB[59];
  assign     DOB60                 = DOB[60];
  assign     DOB61                 = DOB[61];
  assign     DOB62                 = DOB[62];
  assign     DOB63                 = DOB[63];
  assign     DOB64                 = DOB[64];
  assign     DOB65                 = DOB[65];
  assign     DOB66                 = DOB[66];
  assign     DOB67                 = DOB[67];
  assign     DOB68                 = DOB[68];
  assign     DOB69                 = DOB[69];
  assign     DOB70                 = DOB[70];
  assign     DOB71                 = DOB[71];
  assign     DOB72                 = DOB[72];
  assign     DOB73                 = DOB[73];
  assign     DOB74                 = DOB[74];
  assign     DOB75                 = DOB[75];
  assign     DOB76                 = DOB[76];
  assign     DOB77                 = DOB[77];
  assign     DOB78                 = DOB[78];
  assign     DOB79                 = DOB[79];
  assign     DOB80                 = DOB[80];
  assign     DOB81                 = DOB[81];
  assign     DOB82                 = DOB[82];
  assign     DOB83                 = DOB[83];
  assign     DOB84                 = DOB[84];
  assign     DOB85                 = DOB[85];
  assign     DOB86                 = DOB[86];
  assign     DOB87                 = DOB[87];
  assign     DOB88                 = DOB[88];
  assign     DOB89                 = DOB[89];
  assign     DOB90                 = DOB[90];
  assign     DOB91                 = DOB[91];
  assign     DOB92                 = DOB[92];
  assign     DOB93                 = DOB[93];
  assign     DOB94                 = DOB[94];
  assign     DOB95                 = DOB[95];
  assign     DOB96                 = DOB[96];
  assign     DOB97                 = DOB[97];
  assign     DOB98                 = DOB[98];
  assign     DOB99                 = DOB[99];
  assign     DOB100                 = DOB[100];
  assign     DOB101                 = DOB[101];
  assign     DOB102                 = DOB[102];
  assign     DOB103                 = DOB[103];
  assign     DOB104                 = DOB[104];
  assign     DOB105                 = DOB[105];
  assign     DOB106                 = DOB[106];
  assign     DOB107                 = DOB[107];
  assign     DOB108                 = DOB[108];
  assign     DOB109                 = DOB[109];
  assign     DOB110                 = DOB[110];
  assign     DOB111                 = DOB[111];
  assign     DOB112                 = DOB[112];
  assign     DOB113                 = DOB[113];
  assign     DOB114                 = DOB[114];
  assign     DOB115                 = DOB[115];
  assign     DOB116                 = DOB[116];
  assign     DOB117                 = DOB[117];
  assign     DOB118                 = DOB[118];
  assign     DOB119                 = DOB[119];
  assign     DOB120                 = DOB[120];
  assign     DOB121                 = DOB[121];
  assign     DOB122                 = DOB[122];
  assign     DOB123                 = DOB[123];
  assign     DOB124                 = DOB[124];
  assign     DOB125                 = DOB[125];
  assign     DOB126                 = DOB[126];
  assign     DOB127                 = DOB[127];
  
  
  
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
  assign     DIA[48]                 = DIA48;
  assign     DIA[49]                 = DIA49;
  assign     DIA[50]                 = DIA50;
  assign     DIA[51]                 = DIA51;
  assign     DIA[52]                 = DIA52;
  assign     DIA[53]                 = DIA53;
  assign     DIA[54]                 = DIA54;
  assign     DIA[55]                 = DIA55;
  assign     DIA[56]                 = DIA56;
  assign     DIA[57]                 = DIA57;
  assign     DIA[58]                 = DIA58;
  assign     DIA[59]                 = DIA59;
  assign     DIA[60]                 = DIA60;
  assign     DIA[61]                 = DIA61;
  assign     DIA[62]                 = DIA62;
  assign     DIA[63]                 = DIA63;
  assign     DIA[64]                 = DIA64;
  assign     DIA[65]                 = DIA65;
  assign     DIA[66]                 = DIA66;
  assign     DIA[67]                 = DIA67;
  assign     DIA[68]                 = DIA68;
  assign     DIA[69]                 = DIA69;
  assign     DIA[70]                 = DIA70;
  assign     DIA[71]                 = DIA71;
  assign     DIA[72]                 = DIA72;
  assign     DIA[73]                 = DIA73;
  assign     DIA[74]                 = DIA74;
  assign     DIA[75]                 = DIA75;
  assign     DIA[76]                 = DIA76;
  assign     DIA[77]                 = DIA77;
  assign     DIA[78]                 = DIA78;
  assign     DIA[79]                 = DIA79;
  assign     DIA[80]                 = DIA80;
  assign     DIA[81]                 = DIA81;
  assign     DIA[82]                 = DIA82;
  assign     DIA[83]                 = DIA83;
  assign     DIA[84]                 = DIA84;
  assign     DIA[85]                 = DIA85;
  assign     DIA[86]                 = DIA86;
  assign     DIA[87]                 = DIA87;
  assign     DIA[88]                 = DIA88;
  assign     DIA[89]                 = DIA89;
  assign     DIA[90]                 = DIA90;
  assign     DIA[91]                 = DIA91;
  assign     DIA[92]                 = DIA92;
  assign     DIA[93]                 = DIA93;
  assign     DIA[94]                 = DIA94;
  assign     DIA[95]                 = DIA95;
  assign     DIA[96]                 = DIA96;
  assign     DIA[97]                 = DIA97;
  assign     DIA[98]                 = DIA98;
  assign     DIA[99]                 = DIA99;
  assign     DIA[100]                 = DIA100;
  assign     DIA[101]                 = DIA101;
  assign     DIA[102]                 = DIA102;
  assign     DIA[103]                 = DIA103;
  assign     DIA[104]                 = DIA104;
  assign     DIA[105]                 = DIA105;
  assign     DIA[106]                 = DIA106;
  assign     DIA[107]                 = DIA107;
  assign     DIA[108]                 = DIA108;
  assign     DIA[109]                 = DIA109;
  assign     DIA[110]                 = DIA110;
  assign     DIA[111]                 = DIA111;
  assign     DIA[112]                 = DIA112;
  assign     DIA[113]                 = DIA113;
  assign     DIA[114]                 = DIA114;
  assign     DIA[115]                 = DIA115;
  assign     DIA[116]                 = DIA116;
  assign     DIA[117]                 = DIA117;
  assign     DIA[118]                 = DIA118;
  assign     DIA[119]                 = DIA119;
  assign     DIA[120]                 = DIA120;
  assign     DIA[121]                 = DIA121;
  assign     DIA[122]                 = DIA122;
  assign     DIA[123]                 = DIA123;
  assign     DIA[124]                 = DIA124;
  assign     DIA[125]                 = DIA125;
  assign     DIA[126]                 = DIA126;
  assign     DIA[127]                 = DIA127;
  
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
  assign     DIB[48]                 = DIB48;
  assign     DIB[49]                 = DIB49;
  assign     DIB[50]                 = DIB50;
  assign     DIB[51]                 = DIB51;
  assign     DIB[52]                 = DIB52;
  assign     DIB[53]                 = DIB53;
  assign     DIB[54]                 = DIB54;
  assign     DIB[55]                 = DIB55;
  assign     DIB[56]                 = DIB56;
  assign     DIB[57]                 = DIB57;
  assign     DIB[58]                 = DIB58;
  assign     DIB[59]                 = DIB59;
  assign     DIB[60]                 = DIB60;
  assign     DIB[61]                 = DIB61;
  assign     DIB[62]                 = DIB62;
  assign     DIB[63]                 = DIB63;
  assign     DIB[64]                 = DIB64;
  assign     DIB[65]                 = DIB65;
  assign     DIB[66]                 = DIB66;
  assign     DIB[67]                 = DIB67;
  assign     DIB[68]                 = DIB68;
  assign     DIB[69]                 = DIB69;
  assign     DIB[70]                 = DIB70;
  assign     DIB[71]                 = DIB71;
  assign     DIB[72]                 = DIB72;
  assign     DIB[73]                 = DIB73;
  assign     DIB[74]                 = DIB74;
  assign     DIB[75]                 = DIB75;
  assign     DIB[76]                 = DIB76;
  assign     DIB[77]                 = DIB77;
  assign     DIB[78]                 = DIB78;
  assign     DIB[79]                 = DIB79;
  assign     DIB[80]                 = DIB80;
  assign     DIB[81]                 = DIB81;
  assign     DIB[82]                 = DIB82;
  assign     DIB[83]                 = DIB83;
  assign     DIB[84]                 = DIB84;
  assign     DIB[85]                 = DIB85;
  assign     DIB[86]                 = DIB86;
  assign     DIB[87]                 = DIB87;
  assign     DIB[88]                 = DIB88;
  assign     DIB[89]                 = DIB89;
  assign     DIB[90]                 = DIB90;
  assign     DIB[91]                 = DIB91;
  assign     DIB[92]                 = DIB92;
  assign     DIB[93]                 = DIB93;
  assign     DIB[94]                 = DIB94;
  assign     DIB[95]                 = DIB95;
  assign     DIB[96]                 = DIB96;
  assign     DIB[97]                 = DIB97;
  assign     DIB[98]                 = DIB98;
  assign     DIB[99]                 = DIB99;
  assign     DIB[100]                 = DIB100;
  assign     DIB[101]                 = DIB101;
  assign     DIB[102]                 = DIB102;
  assign     DIB[103]                 = DIB103;
  assign     DIB[104]                 = DIB104;
  assign     DIB[105]                 = DIB105;
  assign     DIB[106]                 = DIB106;
  assign     DIB[107]                 = DIB107;
  assign     DIB[108]                 = DIB108;
  assign     DIB[109]                 = DIB109;
  assign     DIB[110]                 = DIB110;
  assign     DIB[111]                 = DIB111;
  assign     DIB[112]                 = DIB112;
  assign     DIB[113]                 = DIB113;
  assign     DIB[114]                 = DIB114;
  assign     DIB[115]                 = DIB115;
  assign     DIB[116]                 = DIB116;
  assign     DIB[117]                 = DIB117;
  assign     DIB[118]                 = DIB118;
  assign     DIB[119]                 = DIB119;
  assign     DIB[120]                 = DIB120;
  assign     DIB[121]                 = DIB121;
  assign     DIB[122]                 = DIB122;
  assign     DIB[123]                 = DIB123;
  assign     DIB[124]                 = DIB124;
  assign     DIB[125]                 = DIB125;
  assign     DIB[126]                 = DIB126;
  assign     DIB[127]                 = DIB127;
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
		  if (~WEAN)
		  begin
			Memory[A] <= DIA;
			latched_DOA<= DIA;
		  end
		  else
		  begin
			latched_DOA <= Memory[A];
		  end
		end
	end
	always_ff @(posedge CKA)
	begin
	  if(CSB)
	  begin
		if (~WEBN)
		  begin
			Memory[B] <= DIB;
			latched_DOB<= DIB;
		  end
		  else
		  begin
			latched_DOB <= Memory[B];
		  end
	  end
	end
	always_comb
	begin
		DOA = (OEA)? latched_DOA: {(Bytes*Bits){1'bz}};
		DOB = (OEB)? latched_DOB: {(Bytes*Bits){1'bz}};
	end
  /*
  always_ff @(posedge CK)
  begin
    if (CS)
    begin
      if (~WEB0)
      begin
        Memory_byte0[A] <= DI[0*Bits+:Bits];
        latched_DO[0*Bits+:Bits] <= DI[0*Bits+:Bits];
      end
      else
      begin
        latched_DO[0*Bits+:Bits] <= Memory_byte0[A];
      end
      if (~WEB1)
      begin
        Memory_byte1[A] <= DI[1*Bits+:Bits];
        latched_DO[1*Bits+:Bits] <= DI[1*Bits+:Bits];
      end
      else
      begin
        latched_DO[1*Bits+:Bits] <= Memory_byte1[A];
      end
      if (~WEB2)
      begin
        Memory_byte2[A] <= DI[2*Bits+:Bits];
        latched_DO[2*Bits+:Bits] <= DI[2*Bits+:Bits];
      end
      else
      begin
        latched_DO[2*Bits+:Bits] <= Memory_byte2[A];
      end
      if (~WEB3)
      begin
        Memory_byte3[A] <= DI[3*Bits+:Bits];
        latched_DO[3*Bits+:Bits] <= DI[3*Bits+:Bits];
      end
      else
      begin
        latched_DO[3*Bits+:Bits] <= Memory_byte3[A];
      end
    end
  end
  
  */

  endmodule
  
  
  
  
  
  
  
  
  
  
  
  