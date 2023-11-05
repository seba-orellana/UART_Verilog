`timescale 1ns / 1ps

module mux_tb();

wire clk_64;
reg reset;
wire locked;
reg pulso_a;
reg [7:0] entrada_echo;
reg pulso_echo;
wire [7:0] entrada_comandos;
wire pulso_comandos;
reg switch;
wire pulso_salida;
wire [7:0] dato_salida;
wire dato_o;
reg [7:0] salida_rx;
reg transmitir_pulso_tx;

reg clk_i;

multiplexor DUT (clk_64,
    reset,
    locked,
    pulso_a,
    entrada_echo,
    pulso_echo,
    entrada_comandos,
    pulso_comandos,
    switch,
    pulso_salida,
    dato_salida);
    
clk_wiz_0 clk_ref (clk_64, reset, locked, clk_i);
Uart_tx tx (clk_64, locked, reset, dato_salida, pulso_salida, dato_o);
comandos com (clk_64,
              reset,
              locked,
              switch,
              salida_rx,
              transmitir_pulso_tx,
              led_comandos,
              entrada_comandos,
              pulso_comandos
              );

always #5 clk_i = ~clk_i;
initial begin
    reset = 0;
    clk_i = 0;
    transmitir_pulso_tx = 0;
    switch = 1;
    #2000;
    transmitir_pulso_tx = 1;
    salida_rx = 8'h6D;
    #150;
    transmitir_pulso_tx = 0;
    #1500000;
    $stop;
end
    
endmodule
