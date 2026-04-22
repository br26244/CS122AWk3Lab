`include "decoder.sv"
module top #(
    parameter DB_THRESH = 1_200_000  
)
(
    /** Input Ports */
    input  logic clk,      
    input  logic btnR,    
    input  logic btnB,    
    input  logic dipSw,   

    /** Output Ports */
    output logic [7:0] seg7,  
    output logic       ledR, 
    output logic       ledB  
);

/** Logic */


//button press and unpress
logic btnRS0 = 1'b1, btnRS1 = 1'b1;
logic btnBS0 = 1'b1, btnBS1 = 1'b1;
logic dipS0   = 1'b0, dipS1   = 1'b0;

always_ff @(posedge clk) begin
    btnRS0 <= btnR;  btnRS1 <= btnRS0;
    btnBS0 <= btnB;  btnBS1 <= btnBS0;
    dipS0   <= dipSw; dipS1   <= dipS0;
end

// Red button
logic [$clog2(DB_THRESH+2)-1:0] dbCounter = '0;
logic btnRPress = 1'b0;

always_ff @(posedge clk) begin
    btnRPress <= 1'b0;

    if (btnRS1 == 1'b1) begin
        dbCounter <= '0;

    end else begin
        if (dbCounter < DB_THRESH)
            dbCounter <= dbCounter + 1;

        else if (dbCounter == DB_THRESH) begin
            btnRPress <= 1'b1;
            dbCounter <= dbCounter + 1;
        end
    end
end

// blue button 

logic [$clog2(DB_THRESH+2)-1:0] dbCounter2 = '0;
logic btnBPress = 1'b0;

always_ff @(posedge clk) begin
    btnBPress <= 1'b0;

    if (btnBS1 == 1'b1) begin
        dbCounter2 <= '0;

    end else begin
        if (dbCounter2 < DB_THRESH)
            dbCounter2 <= dbCounter2 + 1;

        else if (dbCounter2 == DB_THRESH) begin
            btnBPress <= 1'b1;
            dbCounter2 <= dbCounter2 + 1;
        end
    end
end

logic [3:0] dutyR = 4'd0;
logic [3:0] dutyB = 4'd0;

always_ff @(posedge clk) begin
    if (btnRPress) begin
        if (dutyR == 4'd10) 
            dutyR <= 4'd0;
        else                
            dutyR <= dutyR + 1'b1;
    end
end

always_ff @(posedge clk) begin
    if (btnBPress) begin
        if (dutyB == 4'd10) 
            dutyB <= 4'd0;
        else                
            dutyB <= dutyB + 1'b1;
    end
end

logic [3:0] pwmCount = 4'd0;

always_ff @(posedge clk)
    if(pwmCount == 4'd9)
        pwmCount <= 4'd0;
    else
        pwmCount <= pwmCount + 1'b1;


assign ledR = ~(pwmCount < dutyR);
assign ledB = ~(pwmCount < dutyB);

// 7 seg 
logic [3:0] dispSeg;
assign dispSeg = dipS1 ? dutyB : dutyR;

decoder dec (
    .bcd    (dispSeg),
    .decimal(dipS1),
    .seg7   (seg7)
);

endmodule
