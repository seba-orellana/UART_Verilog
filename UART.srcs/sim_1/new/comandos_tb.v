`timescale 1ns / 1ps


module comandos_tb();

reg pulso;
reg clk;
wire clk_64;
reg reset;
wire locked;
reg switch;
reg [7:0] dato_recibido;
wire valor_led;
wire [7:0] dato_transmitido;
wire pulso_envio;
wire dato_o;

clk_wiz_0 clk_ref (clk_64, reset, locked, clk);

comandos DUT (clk_64,
    reset,
    locked,
    switch,
    dato_recibido,
    pulso,
    valor_led,
    dato_transmitido,
    pulso_envio);

Uart_tx tx (clk_64,
            locked,
            reset,
            dato_transmitido,    //Este modulo solamente envia A al pulsar el boton, no necesito dato de entrada
            pulso_envio,
            dato_o); 
    
always #5 clk=~clk;

initial begin
    clk=0;
    reset = 0;
    switch = 1;
    #3000;
    dato_recibido = 8'h6D;
    pulso = 1;
    #140;
    pulso = 0;
    #1000;
    dato_recibido = 0;
    #30000;
    dato_recibido = 8'h6D;
    #1000;
    dato_recibido = 0;
    #1000000;
    $stop;
end    
   
endmodule
