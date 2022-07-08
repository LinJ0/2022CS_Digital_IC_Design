module ALU_1bit(result, c_out, set, overflow, a, b, less, Ainvert, Binvert, c_in, op);
input        a;
input        b;
input        less;
input        Ainvert;
input        Binvert;
input        c_in;
input  [1:0] op;
output       result;
output       c_out;
output       set;                 
output       overflow; 

reg result, overflow;
wire a_i, b_i;

assign a_i = Ainvert ? ~a : a;
assign b_i = Binvert ? ~b : b;

always@(*) overflow = c_in ^ c_out;

always@(*) begin
  case(op)
    default: result = a_i & b_i;
    2'b01:   result = a_i | b_i;
    2'b10:   result = set;
    2'b11:   result = less;
  endcase
end

FA FA_1(.s(set), .carry_out(c_out), .x(a_i), .y(b_i), .carry_in(c_in));

endmodule