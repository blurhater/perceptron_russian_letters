//typedef struct {int weights[8][20], sum[8][8], iteration; reg [19:0] abc [0:7];} neuralnet;
//typedef struct {int weights[8][20]; logic [19:0] letter; reg [7:0] out;} sample;

module network(write, atrain, gtrain, goa, gog, clk, g, p, n, gn, on, noi, reset, out, w1, w2, s1, s2, itea, iteg);
     //  network(write, atrain, gtrain, goa, gog, clk, g, p, n, gn, on, noi, reset, out, w1, w2, s1, s2, itea, iteg);
input clk, write, reset, atrain, gtrain, goa, gog, g, p, n, gn, on, noi;
reg [19:0] letter ;
output reg [7:0] out ;
//output reg [2:0] g;
int sum [8][8];
int weights[8][20];
output int itea, iteg;
output int w1[8][20], w2[8][20];
output int s1 [8][8], s2 [8][8];
//neuralnet dataa, datag;
//sample res;
//wire [12:0] rnd;
//reg flag;
int i,j,m,ite;
int flag;
int temp;
int change;
parameter step=100;
parameter reg [19:0] gnoise = {20'b11111000100010001000};
parameter reg [19:0] onoise = {20'b11111001101110011111};
parameter reg [19:0] noise = { 20'b11111111111111111111};


parameter reg [19:0] abc [0:7] = '{ 20'b11111001100110011001, // Pp
				     20'b11101000100010001000, // Gg
				     20'b10011001111110011001, // H
				     20'b11111001100110011111, //O
				     20'b11101000111010001110, //E
				     20'b11111000111110011111, //Bb
				     20'b01110001011100010111, //Zz
				     20'b10011001111100010111}; //Yy*/


//function neuralnet alpha(input int weights[8][20], sum[8][8], iteration, reg [19:0] abc [0:7]);
always @(posedge atrain)
begin
	flag=0;
	/*for (int i=0; i<8; i=i+1)
	begin
		for (int j=0; j<20; j=j+1)
			w1[i][j]=w1[i][j];
		for (int m=0; m<8; m=m+1)
			s1[i][m]=s1[i][m];
	end*/
	
	for (itea=0; itea<100 && flag==0; itea=itea+1)
	begin
		flag=1;
		for (int m=0; m<8; m=m+1)
			for (int i=0; i<8; i=i+1)
			begin
				if (s1[i][m]>7000 && i!=m)
				begin
					change=0;
					for (int j=0; j<20; j=j+1)
						if (abc[i][j]==1)
						begin
							w1[m][j]=w1[m][j]-step;
							flag=0;
						end
				end
				else 
				begin
					if (s1[i][m]<8999 && i==m)
					begin
						for (int j=0; j<20; j=j+1)
							if (abc[i][j]==1)
							begin
								w1[m][j]=w1[m][j]+step;
								flag=0;
							end
					end
				end
			end

		for (int m=0; m<8; m=m+1)
			for (int i=0; i<8; i=i+1)
			begin
				s1[i][m]=0;
				for (int j=0; j<20; j=j+1)
					s1[i][m]=s1[i][m]+w1[m][j]*abc[i][j];
			end
	end
end

//function neuralnet gamma(input int weights[8][20], sum[8][8], iteration, reg [19:0] abc [0:7]);
always @(posedge gtrain)
begin
	flag=0;
	/*for (int i=0; i<8; i=i+1)
	begin
		//flag=0;
		for (int j=0; j<20; j=j+1)
			gamma.weights[i][j]=weights[i][j];
		for (int m=0; m<8; m=m+1)
			gamma.sum[i][m]=sum[i][m];
	end*/
	
	for (iteg=0; iteg<100 && flag==0; iteg=iteg+1)
	begin
		flag=1;
		for (int m=0; m<8; m=m+1)
			for (int i=0; i<8; i=i+1)
			begin
				if (s2[i][m]>7000 && i!=m)
				begin
					change=0;
					for (int j=0; j<20; j=j+1)
						if (abc[i][j]==1)
						begin
							w2[m][j]=w2[m][j]-step;
							flag=0;
							change=change+step;
						end
					for (int j=0; j<20; j=j+1)
						w2[m][j]=w2[m][j]+(change/20);
				end
				else 
				begin
					if (s2[i][m]<8999 && i==m)
					begin
						change=0;
						for (int j=0; j<20; j=j+1)
							if (abc[i][j]==1)
							begin
								w2[m][j]=w2[m][j]+step;
								flag=0;
								change=change+step;
							end
						for (int j=0; j<20; j=j+1)
							w2[m][j]=w2[m][j]-(change/20);
					end
				end
			end

		for (int m=0; m<8; m=m+1)
			for (int i=0; i<8; i=i+1)
			begin
				s2[i][m]=0;
				for (int j=0; j<20; j=j+1)
					s2[i][m]=s2[i][m]+w2[m][j]*abc[i][j];
			end
		if (flag) break;
	end
	//return gamma;
end


always @(posedge write)
begin
	for (int i=0; i<8; i=i+1)
	begin
		for (int j=0; j<20; j=j+1)
		begin
			/*weights[i][j]=rnd[i][j];
			w1[i][j]=rnd[i][j];
			w2[i][j]=rnd[i][j];
			bias[i]=bias[i]+weights[i][j];
			b1[i]=b1[i]+w1[i][j];
			b2[i]=b2[i]+w2[i][j];*/
			weights[i][j]=0;
			w1[i][j]=0;
			w2[i][j]=0;
		end
		for (int m=0; m<8; m=m+1)
		begin
			sum[i][m]=0;
			s1[i][m]=0;
			s2[i][m]=0;
		end
	end
	
end

/*always @(posedge train)
begin
	dataa=alpha(w1, s1, ite, abc);
	w1=dataa.weights;
	s1=dataa.sum;
	itea=dataa.iteration;
	datag=gamma(w2, s2, ite, abc);
	w2=datag.weights;
	s2=datag.sum;
	iteg=datag.iteration;
end*/

always @(posedge goa)
begin
	for ( int i=0; i<8; i=i+1)
	begin
		temp=0;
		for (j=0; j<20; j=j+1)
			temp=temp+w1[i][j]*letter[j];
		out[i]=(temp>7001);	
	end
end
 
always @(posedge gog)
begin
	for ( int i=0; i<8; i=i+1)
	begin
		temp=0;
		for (j=0; j<20; j=j+1)
			temp=temp+w2[i][j]*letter[j];
		out[i]=(temp>7001);	
	end
end

always @(posedge p)
begin
	letter=abc[0];
end

always @(posedge g)
begin
	letter=abc[1];
end

always @(posedge n)
begin
	letter=abc[2];
end

always @(posedge gn)
begin
	letter=gnoise;
end

always @(posedge on)
begin
	letter=onoise;
end

always @(posedge noi)
begin
	letter=noise;
end

endmodule
