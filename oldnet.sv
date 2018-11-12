
typedef struct {int weights[8][20], sum[8][8], iteration; reg [19:0] abc [0:7];} neuralnet;
typedef struct {int weights[8][20]; logic [19:0] letter; reg [7:0] out;} sample;

module oldnet(write, train, goa, gog, clk, g, p, n, gn, on, noi, reset, out, w1, w2, s1, s2, itea, iteg);
input clk, write, reset, train, goa, gog, g, p, n, gn, on, noi;
reg [19:0] letter ;
output reg [7:0] out ;
//output reg [2:0] g;
int sum [8][8];
int weights[8][20];
output int itea, iteg;
output int w1[8][20], w2[8][20];
output int s1 [8][8], s2 [8][8];
neuralnet dataa, datag;
sample res;
//wire [12:0] rnd;
//reg flag;
int i,j,m,ite;
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


function neuralnet alpha(input int weights[8][20], sum[8][8], iteration, reg [19:0] abc [0:7]);
	int flag;
	parameter step=100;
	int change;
	flag=0;
	alpha.iteration=iteration;
	for (int i=0; i<8; i=i+1)
	begin
		for (int j=0; j<20; j=j+1)
			alpha.weights[i][j]=weights[i][j];
		for (int m=0; m<8; m=m+1)
			alpha.sum[i][m]=sum[i][m];
	end
	
	for (alpha.iteration=0; alpha.iteration<100 && flag==0; alpha.iteration=alpha.iteration+1)
	begin
		flag=1;
		for (int m=0; m<8; m=m+1)
			for (int i=0; i<8; i=i+1)
			begin
				if (alpha.sum[i][m]>7000 && i!=m)
				begin
					change=0;
					for (int j=0; j<20; j=j+1)
						if (abc[i][j]==1)
						begin
							alpha.weights[m][j]=alpha.weights[m][j]-step;
							flag=0;
						end
				end
				else 
				begin
					if (alpha.sum[i][m]<8999 && i==m)
					begin
						change=0;
						for (int j=0; j<20; j=j+1)
							if (abc[i][j]==1)
							begin
								alpha.weights[m][j]=alpha.weights[m][j]+step;
								flag=0;
							end
					end
				end
			end

		for (int m=0; m<8; m=m+1)
			for (int i=0; i<8; i=i+1)
			begin
				alpha.sum[i][m]=0;
				for (int j=0; j<20; j=j+1)
					alpha.sum[i][m]=alpha.sum[i][m]+alpha.weights[m][j]*abc[i][j];
			end
	end
endfunction

function neuralnet gamma(input int weights[8][20], sum[8][8], iteration, reg [19:0] abc [0:7]);
	int flag;
	parameter step=100;
	int change;
	flag=0;
	gamma.iteration=iteration;
	for (int i=0; i<8; i=i+1)
	begin
		//flag=0;
		for (int j=0; j<20; j=j+1)
			gamma.weights[i][j]=weights[i][j];
		for (int m=0; m<8; m=m+1)
			gamma.sum[i][m]=sum[i][m];
	end
	
	for (gamma.iteration=0; gamma.iteration<100 && flag==0; gamma.iteration=gamma.iteration+1)
	begin
		flag=1;
		for (int m=0; m<8; m=m+1)
			for (int i=0; i<8; i=i+1)
			begin
				if (gamma.sum[i][m]>7000 && i!=m)
				begin
					change=0;
					for (int j=0; j<20; j=j+1)
						if (abc[i][j]==1)
						begin
							gamma.weights[m][j]=gamma.weights[m][j]-step;
							flag=0;
							change=change+step;
						end
					for (int j=0; j<20; j=j+1)
						gamma.weights[m][j]=gamma.weights[m][j]+(change/20);
				end
				else 
				begin
					if (gamma.sum[i][m]<8999 && i==m)
					begin
						change=0;
						for (int j=0; j<20; j=j+1)
							if (abc[i][j]==1)
							begin
								gamma.weights[m][j]=gamma.weights[m][j]+step;
								flag=0;
								change=change+step;
							end
						for (int j=0; j<20; j=j+1)
							gamma.weights[m][j]=gamma.weights[m][j]-(change/20);
					end
				end
			end

		for (int m=0; m<8; m=m+1)
			for (int i=0; i<8; i=i+1)
			begin
				gamma.sum[i][m]=0;
				for (int j=0; j<20; j=j+1)
					gamma.sum[i][m]=gamma.sum[i][m]+gamma.weights[m][j]*abc[i][j];
			end
		if (flag) break;
	end
	//return gamma;
endfunction

function sample check (input int weights[8][20], reg [19:0] letter, reg [7:0] out);
	int temp;
	for ( int i=0; i<8; i=i+1)
	begin
		temp=0;
		for (j=0; j<20; j=j+1)
			temp=temp+weights[i][j]*letter[j];
		check.out[i]=(temp>7001);	
	end
	out=check.out;
endfunction


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

always @(posedge train)
begin
	dataa=alpha(w1, s1, ite, abc);
	w1=dataa.weights;
	s1=dataa.sum;
	itea=dataa.iteration;
	datag=gamma(w2, s2, ite, abc);
	w2=datag.weights;
	s2=datag.sum;
	iteg=datag.iteration;
end

always @(posedge goa)
begin
	res=check(w1, letter, out);	
	out=res.out;
end
 
always @(posedge gog)
begin
	res=check(w2, letter, out);	
	out=res.out;
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

/*always @(posedge comp)
begin 
	for (i=0; i<8; i=i+1)
		for (j=0; j<8; j=j+1)
			sum[i][j]=s1[i][j]-s2[i][j];
end
endmodule*/

/*for (j=0; j<8; j=j+1)
begin
	for (i=0; i<20; i=i+1)
	begin 
		w1[i][j]=0;
		m=alph[j][i];
		b1[j]=b1[j]+w1[i][j]*m;
	end	
	flag=1;
end*/


/*always @(posedge clk && letter)
begin
	for (j=0;  j<8; j=j+1)
		begin
			for (i=0; i<20; i=i+1)
			begin 
				alph[i][j]=letter[i];
			end	
		end
end*/

/*always @(posedge clk && learn)
begin
for (int g=0; g<150&&flag==1; g=g+1)
begin
	flag=0;
	for (i=0;i<8;i=i+1)
	begin
		//if (b1[i]<8000)
		
		for (m=0; m<8; m=m+1)
		begin
			if (b1[m]>8000 && m!=i)
			begin
				for (j=0; j<20; j=j+1)
				begin
					if(alph[m][j]==1)
					begin
						w1[j][m]=w1[j][m]-100;
						flag=1;
					end
				end
			end
			else if (m==i && b1[m]<8000)
			begin
			for (j=0; j<20; j=j+1)
			begin
				if(alph[i][j]==1)
				begin
					w1[j][i]=w1[j][i]+100;
					
					flag=1;
				end
			end
		end
		end
	end
	for (i=0;i<8;i=i+1)
	begin
		b1[i]=0;
		for (j=0; j<20; j=j+1)
		begin
			m1=alph[i][j];
			b1[i]=b1[i]+w1[j][i]*m1;
		end
		
	end
end

end

always @(posedge clk && go)
begin
for (i=0;i<8;i=i+1)
	begin
		b1[i]=0;
		for (j=0; j<20; j=j+1)
		begin
			m1=letter[j];
			b1[i]=b1[i]+w1[j][i]*m1;
		end
	for (j=0; j<8; j=j+1)
	begin
		if (b1[j]>8000)
		out[j]=1; else out[j]=0;
	end
end
end
endmodule
*/

//LFSR randomfunc(clk, reset, rnd);

/*function int rnd;
	input clk;
	input reset;
	reg signed [13:0] random, random_next, random_done;
	reg [3:0] count, count_next; //to keep track of the shifts
	parameter i=0, j=0;

	parameter feedback = random[13] ^ random[4] ^ random[2] ^ random[0]; 
	//begin

	always @ (posedge clk or posedge reset)
	begin
		if (reset)
		begin
 			random <= 10'hF; //An LFSR cannot have an all 0 state, thus reset to FF
			count <= 0;
		end
  
 		else
 		begin
  			random <= random_next;
 			count <= count_next;
		end
	end

	always @ (*)
	begin
 		random_next = random; //default state stays the same
 		count_next = count;
  		random_next = {random[12:0], feedback}; //shift left the xor'd every posedge clock
  		count_next = count + 1;
 		if (count == 14)
 		begin
  			count = 0;
  			random_done = random; //assign the random number to output after 13 shifts
			if (i<9&&(random_done!=1'bx || random_done!=1'bz)) 
			begin
				rnd[i][j]=random_done;
				j=j+1;
				if (j>19)
				begin
					i=i+1;
					j=0;
				end
			end	
 		end
	end
	//end
endfunction*/

/*always @(*)
begin
	rnd(clk,reset);
end*/
			
				