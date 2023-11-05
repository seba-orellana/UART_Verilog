`timescale 1ns / 1ps



module contestador_tb();
  reg clk_i;
  reg reset;
  reg dato_listo;
  reg [7:0] dato_recibido;
  wire locked;
  wire clk_64;
  wire  transmitir_o;
  wire [7:0] dato_transmitido;
  reg sw;

contestador2 DUT ( clk_64,  reset,  locked, dato_recibido, dato_listo, sw,  dato_transmitido,  transmitir_o  );
clk_wiz_0 clk_ref (clk_64, reset, locked, clk_i);
   
always #5 clk_i = ~clk_i;

initial begin
    reset = 0;
    clk_i = 0;
    sw = 1;
    dato_listo = 0;
    #5000
    dato_recibido=8'b00000001;
    dato_listo=1;
    #140
    dato_listo=0;
    #20000
    $stop;
end    
endmodule
