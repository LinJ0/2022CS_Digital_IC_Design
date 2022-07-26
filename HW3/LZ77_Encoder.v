module LZ77_Encoder(clk,reset,chardata,valid,encode,finish,offset,match_len,char_nxt);
input 				clk;
input 				reset; //active high
input 		[7:0] 	chardata;
output  			valid;
output  			encode;
output  			finish;
output 		[3:0] 	offset;
output 		[2:0] 	match_len;
output 	 	[7:0] 	char_nxt;

reg [3:0] offset;
reg [2:0] match_len;
reg [7:0] char_nxt;
reg [7:0] input_buf [2047:0];
reg [7:0] l_buf [7:0];
reg [7:0] s_buf [8:0];
reg [1:0] state_ns, state_cs;

parameter S0 = 2'b00; //initial
parameter S1 = 2'b00; //input buffer
parameter S1 = 2'b00; //

//FSM current state register
always@(posedge clk) begin
	if(reset) state_cs <= S0;
	else state_cs <= state_ns;
end

//next state logic
always@(*) begin
	case(state_cs)
		default: state_ns = state_cs;
		S0: state_ns = (chardata)? S1 : S0;
		S1: state_ns = (chardata ^ 8'h24)? S1 : S2;
		
	endcase
end

//buffer shift control
integer i, j, k;
always@(posedge clk) begin
	if(reset) begin
		input_buf <= 0;
		l_buf <= 0;
		s_buf <= 0;
	end
	else begin
		for(i = 0; i < 2047; i = i+1) input_buf[i + 1] <= input_buf[i];
		input_buf[0] <= chardata;
		for(j = 0; j < 8; j = j+1) l_buf[j] <= input_buf[j + 2040];
		for(k = 0; k < 8; i = k+1) s_buf[k + 1] <= s_buf[k];
		s_buf[0] <= l_buf[7];
	end
end

//output logic
always@(*) begin
	case(state_cs)
		default: begin
			offset = 4'h0;
			match_len = 3'h0;
			char_nxt = 8'h0;
		end
		
		S0: begin
			offset = 4'h0;
			match_len = 3'h0;
			char_nxt = 8'h0;
		end
		
		S1: begin
			offset = 4'h0;
			match_len = 3'h0;
			char_nxt = 8'h0;
		end
		
	endcase
end

//
assign valid = ()?  1 : 0;
//finish signal control
assign finish = (char_nxt ^ 8'h24)? 0 : 1;
//encode signal control
assign encode = 1;

endmodule

