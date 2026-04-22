module decoder (
    input logic [3:0] bcd,
    input logic decimal,
    output logic [7:0] seg7
);

always_comb begin
    case (bcd)
        4'd0:  seg7 = 8'b11111100; // 0
        4'd1:  seg7 = 8'b01100000; // 1
        4'd2:  seg7 = 8'b11011010; // 2
        4'd3:  seg7 = 8'b11110010; // 3
        4'd4:  seg7 = 8'b01100110; // 4
        4'd5:  seg7 = 8'b10110110; // 5
        4'd6:  seg7 = 8'b10111110; // 6
        4'd7:  seg7 = 8'b11100000; // 7
        4'd8:  seg7 = 8'b11111110; // 8
        4'd9:  seg7 = 8'b11110110; // 9
        4'd10: seg7 = 8'b11101110; // A
        4'd11: seg7 = 8'b00111110; // b
        4'd12: seg7 = 8'b10011100; // C
        4'd13: seg7 = 8'b01111010; // d
        4'd14: seg7 = 8'b10011110; // E
        4'd15: seg7 = 8'b10001110; // F
        default: seg7 = 8'b00000000; 
    endcase

    if(decimal) begin
        seg7[0] = 1; 
    end else begin
        seg7[0] = 0; 
    end


end

endmodule