module test;
reg clk, write, reset, atrain, gtrain, goa, gog, g, p, n, gn, on, noi;
reg [7:0] out ;
//int w1[20][8];
//int b1 [8];
//output reg [2:0] g;
int s1[8][8], s2[8][8];
int w1[8][20], w2[8][20];
int itea, iteg;

//wire [12:0] rnd;
//reg flag;


network network1(write, atrain, gtrain, goa, gog, clk, g, p, n, gn, on, noi, reset, out, w1, w2, s1, s2, itea, iteg);
//kk kk1(w1, letter, clk, out1, b1);

initial 
begin
	#1 clk=0;
	forever #20 clk=~clk;
end

initial
begin
#1 reset=0; write=0; atrain=0; gtrain=0; goa=0; gog=0;
#500 write=1;
#500 write=0; atrain=1; gtrain=1;
#500 atrain=0; gtrain=0;
//#20 letter[19:0]=20'b11111001100110011001; 
#20 p=1; 
#500  goa =1;  #500 goa =0; gog=1;
#500 goa =0;  gog=0;
//#20 letter[19:0]=20'b11111000100010001000; 
#20 p=0; g=1;
#500  goa =1;  #500 goa =0; gog=1;
#500 goa =0;  gog=0;
//#20 letter[19:0]=20'b10011001111110011001; 
#20 g=0; n=1;
#500  goa =1;  #500 goa =0; gog=1;
#500 goa =0;  gog=0;
//#20 letter[19:0]=20'b11111001100110011001; 
#20 n=0; gn=1;
#500  goa =1;  #500 goa =0; gog=1;
#500 goa =0;  gog=0;
#20 gn=0; on=1;
#500  goa =1;  #500 goa =0; gog=1;
#500 goa =0;  gog=0;

#20 on=0; noi=1;
#500  goa =1;  #500 goa =0; gog=1;
#500 goa =0;  gog=0;
//#500 letter[19:0]=20'b11101000100010001000; // Gg
//#500 letter[19:0]=20'b10011001111110011001;
//#500 letter[19:0]=20'b11111001100110011111;
//#500 letter[19:0]=20'b11101000111010001110;
//#500 letter[19:0]=20'b11111001100110011001;
//#500 letter[19:0]=20'b01110001011100010111;
//#500 letter[19:0]=20'b10011001111100010111;
end
endmodule
