`timescale 1ns / 1ps

module Uart_rx_tb();

//reg  clk_in1; //este es del sistema
reg  rxd_i;
reg  reset; //sale de mi PLL
reg  clk;

wire clk_64;//salida de mi PLL
wire locked; //sale de mi PLL
wire [7:0] datos_recibido_o;
wire dato_listo_o;
wire led_reset;
wire pulso;

clk_wiz_0 clk_ref (clk_64, reset, locked, clk);
Uart_rx DUT (rxd_i, reset, locked, clk_64, datos_recibido_o, dato_listo_o, led_reset, pulso);
//cont_16 clk16 (clk_64, reset, locked, clock16);

always #5 clk=~clk;

initial begin
    clk=0;
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
    
    //////////////////////////////////////////////////////////////
    rxd_i=0;    //Start
    #8680.55
    rxd_i=1;    
    #8680.55    //Numero recibido: 01100010011
    rxd_i=1;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=1;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=1;    //Paridad
    #8680.55
    rxd_i=1;    //Stop
    #20680.55
    ///////////////////////////////////////////////
    /*rxd_i=0;    //Start
    #8680.55
    rxd_i=1;    
    #8680.55    //Numero recibido: 01100010001 (Se descarta por error en paridad)
    rxd_i=1;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=1;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=0;
    #8680.55
    rxd_i=0;    //Paridad
    #8680.55
    rxd_i=1;    //Stop
    #14680.55;*/
    $stop;
end

endmodule
