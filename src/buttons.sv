module buttons #(
    parameter DB_THRESH = 1_200_000
)
(
    input  logic clk,
    input  logic btnR,
    input  logic btnB,
    output logic btnRPress,
    output logic btnBPress
);

logic btnRS0 = 1'b1, btnRS1 = 1'b1;
logic btnBS0 = 1'b1, btnBS1 = 1'b1;

logic [$clog2(DB_THRESH+2)-1:0] dbCounterR = '0;
logic [$clog2(DB_THRESH+2)-1:0] dbCounterB = '0;

always_ff @(posedge clk) begin
    btnRS0 <= btnR;
    btnRS1 <= btnRS0;
    btnBS0 <= btnB;
    btnBS1 <= btnBS0;
end

always_ff @(posedge clk) begin
    btnRPress <= 1'b0;
    if (btnRS1 == 1'b1)
        dbCounterR <= '0;
    else begin
        if (dbCounterR < DB_THRESH)
            dbCounterR <= dbCounterR + 1;
        else if (dbCounterR == DB_THRESH) begin
            btnRPress <= 1'b1;
            dbCounterR <= dbCounterR + 1;
        end
    end
end

always_ff @(posedge clk) begin
    btnBPress <= 1'b0;
    if (btnBS1 == 1'b1)
        dbCounterB <= '0;
    else begin
        if (dbCounterB < DB_THRESH)
            dbCounterB <= dbCounterB + 1;
        else if (dbCounterB == DB_THRESH) begin
            btnBPress <= 1'b1;
            dbCounterB <= dbCounterB + 1;
        end
    end
end

endmodule
