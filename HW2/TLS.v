module TLS(clk, reset, Set, Stop, Jump, Gin, Yin, Rin, Gout, Yout, Rout);
input           clk;
input           reset;
input           Set;
input           Stop;
input           Jump;
input     [3:0] Gin;
input     [3:0] Yin;
input     [3:0] Rin;
output          Gout;
output          Yout;
output          Rout;

reg Gout, Yout, Rout;
reg [3:0] G_sec, Y_sec, R_sec;
reg [3:0] G_count, Y_count, R_count;

//FSM state name
reg [2:0] state_ns, state_cs;
parameter G = 3'b001;
parameter Y = 3'b010;
parameter R = 3'b100;

//FSM current state register
always@(posedge clk or posedge reset) begin
	if(reset) state_cs <= G;
	else state_cs <= state_ns;
end

//counter
always@(posedge clk or posedge reset) begin
	if(reset) begin
		G_sec <= 0;
		Y_sec <= 0;
		R_sec <= 0;
	end
	else if(Set) begin
		G_sec <= Gin - 1;
		Y_sec <= Yin - 1;
		R_sec <= Rin - 1;
		G_count <= Gin - 1;
		Y_count <= Yin - 1;
		R_count <= Rin - 1;
	end
	else begin
		case (state_cs)
			G: G_count <= (Stop)? G_count : (Jump || !G_count)? G_sec : G_count - 1;
			Y: Y_count <= (Stop)? Y_count : (Jump || !Y_count)? Y_sec : Y_count - 1;
			R: R_count <= (Stop)? R_count : (!R_count)? R_sec : R_count - 1;
		endcase
	end
end    

//FSM next state logic
always@(*) begin
	case(state_cs)
		G: state_ns = (Set)? G : (Jump)? R : (!G_count && !Stop)? Y : G;
		Y: state_ns = (Set)? G : (Jump)? R : (!Y_count && !Stop)? R : Y;
		R: state_ns = (Set)? G : (!R_count && !Stop)? G : R;
	endcase
end

//output logic
always@(*) begin
	case(state_cs)
		G: begin
			Gout = 1'b1;
			Yout = 1'b0;
			Rout = 1'b0;
		end
      
		Y: begin
			Gout = 1'b0;
			Yout = 1'b1;
			Rout = 1'b0;
		end
    
		R: begin
			Gout = 1'b0;
			Yout = 1'b0;
			Rout = 1'b1;
		end
	
		default: begin
			Gout = 1'b0;
			Yout = 1'b0;
			Rout = 1'b0;
		end
	endcase
end
endmodule