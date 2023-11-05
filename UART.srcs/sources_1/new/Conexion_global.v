`timescale 1ns / 1ps

module Conexion_global(
    input  rxd_i,               //Entrada a mi UART (RX)
    input  mati,                //?????? (Clock principal de 10MHz)
    input reset,                //Boton 0
    input boton_1_i,            //Entrada para enviar una A
    input switch0_i,            //SW0 para intercalar entre ECHO y Mensaje 
    output [7:0] datos_led,     //Datos que recibo del receptor (SW0 apagado)
    output dato_listo_o,        //indica si tengo un dato recibido listo para ser usado
    output txd_o,               //Salida a mi UART (TX)
    output led_comandos         //LED que utilizo para prender y apagar dentro del modulo comandos
    );
      
wire locked;                //Indica que el PLL esta ajustado a la frecuencia deseada
wire clk_64;                //Aproximadamente 7.37 MHz
wire [7:0] salida_rx;       //Dato recibido (ASCII) del receptor
wire trama_tx;              //Trama que sale del transmisor para ser enviada por la UART

wire [7:0] dato_echo;   //Salida del contestador (ECHO + 1)
wire pulso_echo;        //Pulso habilitador del contestador

wire dato_listo;            //Pulso habilitador salido del receptor (dato_listo interno)
wire [7:0] salida_mensaje;  //Programacion logica para ingenieria 2023
wire pulso_comandos;        //Pulso habilitador salido del modulo comandos
wire [7:0] dato_tx;         //Byte a ser enviado por el transmisor     
wire pulso_tx;              //Pulso habilitador para enviar un byte por el transmisor

//Generador de un clock de x64 (64 veces 115200 bps)
clk_wiz_0 clk_ref (clk_64, reset, locked, mati); 

//Modulo receptor  
Uart_rx rx(
    rxd_i,
    reset, 
    locked, 
    clk_64,
    salida_rx,
    salida_flag,
    led_signal_reset,
    dato_listo
  );

//Pruebas Individuales

//Prender un LED cada vez que hay un dato listo
//RGB3 - Azul
assign dato_listo_o = (~led_signal_reset && ~switch0_i)? salida_flag : 0;

//Prender los LEDs de acuerdo al bit recibido por la UART

//Orden de LEDS
//  MSB                               LSB
// LED7 LED6 LED5 LED4 RGB3 RGB2 RGB1 RGB0
assign datos_led[0] = (~led_signal_reset && ~switch0_i)? salida_rx[0] : 0;
assign datos_led[1] = (~led_signal_reset && ~switch0_i)? salida_rx[1] : 0;
assign datos_led[2] = (~led_signal_reset && ~switch0_i)? salida_rx[2] : 0;
assign datos_led[3] = (~led_signal_reset && ~switch0_i)? salida_rx[3] : 0;
assign datos_led[4] = (~led_signal_reset && ~switch0_i)? salida_rx[4] : 0;
assign datos_led[5] = (~led_signal_reset && ~switch0_i)? salida_rx[5] : 0;
assign datos_led[6] = (~led_signal_reset && ~switch0_i)? salida_rx[6] : 0;
assign datos_led[7] = (~led_signal_reset && ~switch0_i)? salida_rx[7] : 0;


//Modulo de transmision
Uart_tx tx(
    clk_64,
    locked,
    reset,
    dato_tx,   
    pulso_tx,   
    trama_tx);  

//Envio la trama (11bits) por el transmisor de la UART
assign txd_o = trama_tx;

//Modulo Contestador (ECHO + 1)
contestador2 contestador(
                    clk_64,
                    reset,
                    locked,
                    salida_rx,          //Recibo de mi UART
                    dato_listo,         //Recibo del receptor
                    dato_echo,          //Saco de mi UART
                    pulso_echo);        //Habilitador para el multiplexador

//Bloque de comandos en el receptor
//A(a) - apago
//P(p) - prendo
//M(m) - mensaje
//Led LD3 Rojo
comandos com (clk_64,
              reset,
              locked,
              salida_rx,
              dato_listo,
              led_comandos,
              salida_mensaje,
              pulso_comandos
              );
              
//Multiplexador de salidas al transmisor para poder enviar una sola salida por la UART              
multiplexor mux (
    clk_64,
    reset,
    locked,
    boton_1_i,
    dato_echo,
    pulso_echo,
    salida_mensaje,
    pulso_comandos,
    switch0_i,
    pulso_tx,
    dato_tx);

endmodule