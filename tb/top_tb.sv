`include "src/decoder.sv"
`include "src/top.sv"
`timescale 1ns/1ps         


module top_tb;

/** declare tb signals below */
logic       clkTb   = 1'b0;   
logic       btnRTb = 1'b1;   
logic       btnBTb = 1'b1;
logic       dipTb   = 1'b0;   
logic [7:0] seg7Tb;
logic       ledRTb;
logic       ledBTb;

/** declare module(s) below */
top #(.DB_THRESH(4)) dut
(
    /** hook up tb signals to dut signals */
    .clk   (clkTb),
    .btnR (btnRTb),
    .btnB (btnBTb),
    .dipSw(dipTb),
    .seg7  (seg7Tb),
    .ledR (ledRTb),
    .ledB (ledBTb)
);

localparam CLK_PERIOD = 83;              // ~12 MHz (83 ns period)
always #(CLK_PERIOD/2) clkTb=~clkTb;  // toggle clkTb every #(CLK_PERIOD/2) ticks

initial begin
    $dumpfile("build/top.vcd"); // intermediate file for waveform generation
    $dumpvars(0, top_tb);       // capture all signals under top_tb
end

task pressR;
    begin
        btnRTb = 1'b0;
        repeat (6) @(posedge clkTb);
        btnRTb = 1'b1;
        repeat (6) @(posedge clkTb);
    end
endtask

task press_b;
    begin
        btnBTb = 1'b0;
        repeat (6) @(posedge clkTb);
        btnBTb = 1'b1;
        repeat (6) @(posedge clkTb);
    end
endtask

initial begin
    /** testbench logic goes below */
    repeat (5) @(posedge clkTb);   

    
    dipTb = 1'b0;
    repeat (3) @(posedge clkTb);
    $display("DIP = 0 INIT  seg7=0x%h (expect 0xfc='0') dp=%b (expect 0)", seg7Tb, seg7Tb[0]);

    pressR();
    pressR();
    $display("DIP = 0 RED x2 seg7=0x%h (expect 0xda='2') dp=%b (expect 0)", seg7Tb, seg7Tb[0]);

    dipTb = 1'b1;
    repeat (3) @(posedge clkTb);
    $display("DIP = 1 INIT  seg7=0x%h (expect 0xfd='0'+dp) dp=%b (expect 1)", seg7Tb, seg7Tb[0]);

    pressB();
    pressB();
    pressB();
    $display("DIP = 1 BLU x3 seg7=0x%h (expect 0xf3='3'+dp) dp=%b (expect 1)", seg7Tb, seg7Tb[0]);

    dipTb = 1'b0;
    repeat (3) @(posedge clkTb);
    $display("DIP = 0 RED    seg7=0x%h (expect 0xda='2') dp=%b (expect 0)", seg7Tb, seg7Tb[0]);

    pressR();
    $display("DIP = 0 RED x3 seg7=0x%h (expect 0xf2='3') dp=%b (expect 0)", seg7Tb, seg7Tb[0]);

    dipTb = 1'b1;
    repeat (3) @(posedge clkTb);
    $display("DIP = 1 BLU    seg7=0x%h (expect 0xf3='3'+dp, BLUE unchanged) dp=%b (expect 1)", seg7Tb, seg7Tb[0]);

    #(CLK_PERIOD*5);
    $finish;
end

endmodule
