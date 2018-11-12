module kk(w1, letter, clk, out1, b1);
input clk;
input [19:0] letter ;
output reg out1 [7:0];
output int b1 [8];
input int w1[20][8];
int i, j, m;
//int b1[8];
//input int w1[20][8];
//letter[19:0]=20'b11111001100110011001;

//network network1(letter, wr, learn, clk, reset, w1, b1, out1);
always @(posedge clk)
begin
	for (j=0; j<8; j=j+1)
	b1[j]=0;
	begin
	for (i=0; i<20; i=i+1)
	begin 
		m=letter[i];
		b1[j]=b1[j]+w1[i][j]*m;
	end	
	for (j=0; j<8; j=j+1)
	begin
		if (b1[j]>8000)
		out1[j]=1; else out1[j]=0;
	end
end
end

	

endmodule

