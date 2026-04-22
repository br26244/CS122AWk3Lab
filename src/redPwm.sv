module redPwm (
    input  logic        clk,
    input  logic        btnRPress,
    output logic        ledR,
    output logic [3:0]  dutyR
);

logic [3:0] pwmCount = 4'd0;
initial dutyR = 4'd0;

always_ff @(posedge clk) begin
    if (btnRPress) begin
        if (dutyR == 4'd10)
            dutyR <= 4'd0;
        else
            dutyR <= dutyR + 1'b1;
    end
end

always_ff @(posedge clk)
    if (pwmCount == 4'd9)
        pwmCount <= 4'd0;
    else
        pwmCount <= pwmCount + 1'b1;

assign ledR = ~(pwmCount < dutyR);

endmodule
