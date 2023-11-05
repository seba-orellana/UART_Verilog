`timescale 1ns / 1ps

module conexion_global_tb();
reg  rxd_i;
reg  mati;
reg reset; 
wire [7:0] datos_led;
wire dato_listo_o;
wire test;

Conexion_global DUT (rxd_i, mati, reset, datos_led, dato_listo_o, test);

initial begin
    reset = 0;
    rxd_i = 1;
    #20000;
    //clk_64=0;
    //enable = 0;
    rxd_i=0;
    #8680.55
    rxd_i=0;
    #8680.55   //Numero recibido: 00110011001
    rxd_i=1;
    #8680.55
    rxd_i=1;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=1;
    #8680.55
    rxd_i=1;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=0;    //Paridad
    #8680.55
    rxd_i=1;    //Stop
    #15680.55
    $stop;
end    
endmodule
