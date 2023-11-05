`timescale 1ns / 1ps

module Uart_tx_tb();
    reg clk_i;
    wire locked;
    reg reset;
    reg [7:0] dato_i;
    reg start_i;
    wire dato_o;
    wire clk_64;

Uart_tx DUT (clk_64, locked, reset, dato_i, start_i, dato_o);
clk_wiz_0 clk_ref (clk_64, reset, locked, clk_i);

always #5 clk_i = ~clk_i;

initial begin
    reset = 0;
    clk_i = 0;
    start_i = 0;
    dato_i = 8'b00110010;
    #5000;
    start_i = 1;
    #5000;
    start_i = 0;
    #110000;
    start_i = 1;
    #2000;
    start_i = 0;
    #90000;
    $stop;
end    
endmodule