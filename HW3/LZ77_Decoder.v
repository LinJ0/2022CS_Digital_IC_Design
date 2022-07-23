module LZ77_Decoder(clk,reset,code_pos,code_len,chardata,encode,finish,char_nxt);
input 				clk;
input 				reset;
input 		[3:0] 	code_pos;
input 		[2:0] 	code_len;
input 		[7:0] 	chardata;
output  			encode;
output  			finish;
output 	 	[7:0] 	char_nxt;

reg [7:0] char_nxt;
reg [7:0] s_buf [9:0];
reg [2:0] stall;
wire encode, finish;

//output reg
always@(*) begin
    if(reset) char_nxt = 8'h0; 
	else char_nxt = s_buf[0];
end

always@(posedge clk or posedge reset) begin
    if(reset) stall <= 3'b0; 
	else begin 
		stall <= (stall)? (stall - 1) : code_len;
	end
end

//s_buf shift
integer i;
always@(posedge clk or posedge reset) begin
	for(i=0; i<9; i=i+1) begin
		s_buf[i + 1] <= s_buf[i];
	end
	s_buf[0] <= (stall)? s_buf[code_pos] : chardata;
end

//finish signal control
assign finish = (char_nxt == 8'h24)? 1 : 0;

//encode signal control
assign encode = 0;
endmodule

