`include "decoder.sv"
`include "buttons.sv"
`include "redPwm.sv"
`include "bluepwm.sv"

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

logic dipS0 = 1'b0, dipS1 = 1'b0;

always_ff @(posedge clk) begin
    dipS0 <= dipSw;
    dipS1 <= dipS0;
end

logic btnRPress, btnBPress;
logic [3:0] dutyR, dutyB;

buttons #(.DB_THRESH(DB_THRESH)) btns (
    .clk      (clk),
    .btnR     (btnR),
    .btnB     (btnB),
    .btnRPress(btnRPress),
    .btnBPress(btnBPress)
);

redPwm rp (
    .clk      (clk),
    .btnRPress(btnRPress),
    .ledR     (ledR),
    .dutyR    (dutyR)
);

bluepwm bp (
    .clk      (clk),
    .btnBPress(btnBPress),
    .ledB     (ledB),
    .dutyB    (dutyB)
);

// 7 seg
logic [3:0] dispSeg;
assign dispSeg = dipS1 ? dutyB : dutyR;

decoder dec (
    .bcd    (dispSeg),
    .decimal(dipS1),
    .seg7   (seg7)
);

endmodule
