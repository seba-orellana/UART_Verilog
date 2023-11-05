`timescale 1ns / 1ps

module contestador2(
    input clk_64,
    input reset,
    input locked,
    input [7:0] dato_recibido,  //Recibo de mi UART
    input dato_listo,           //Pulso que indica que recibi algo
    output [7:0] dato_transmitido, //Saco de mi UART
    output transmitir_o            //Pulso habilitador para el multiplexador
    );

//---------------------------------------------------------------------------------------------- ORIGINAL
reg [7:0] dato;   
reg transmitir;
//----------------------------------------------------------------------------------------------

always @(posedge clk_64) begin
    if (~locked || reset) begin
        transmitir = 0;
        dato = 0;
    end
    else begin 
        if (dato_listo) begin         
            dato[0] = dato_recibido[0];
            dato[1] = dato_recibido[1];
            dato[2] = dato_recibido[2];
            dato[3] = dato_recibido[3];
            dato[4] = dato_recibido[4];
            dato[5] = dato_recibido[5];
            dato[6] = dato_recibido[6];
            dato[7] = dato_recibido[7];
            dato = dato + 1;
            transmitir = 1;
        end else
            transmitir = 0;
    end   
end

assign dato_transmitido[0] = dato[0];
assign dato_transmitido[1] = dato[1];
assign dato_transmitido[2] = dato[2];
assign dato_transmitido[3] = dato[3];
assign dato_transmitido[4] = dato[4];
assign dato_transmitido[5] = dato[5];
assign dato_transmitido[6] = dato[6];
assign dato_transmitido[7] = dato[7]; 
assign transmitir_o = transmitir;

endmodule