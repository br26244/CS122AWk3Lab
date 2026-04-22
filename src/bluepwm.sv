module bluepwm (
    input  logic        clk,
    input  logic        btnBPress,
    output logic        ledB,
    output logic [3:0]  dutyB
);

logic [3:0] pwmCount = 4'd0;
initial dutyB = 4'd0;

always_ff @(posedge clk) begin
    if (btnBPress) begin
        if (dutyB == 4'd10)
            dutyB <= 4'd0;
        else
            dutyB <= dutyB + 1'b1;
    end
end

always_ff @(posedge clk)
    if (pwmCount == 4'd9)
        pwmCount <= 4'd0;
    else
        pwmCount <= pwmCount + 1'b1;

assign ledB = ~(pwmCount < dutyB);

endmodule
