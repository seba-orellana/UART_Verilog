`timescale 1ns / 1ps

module comandos(
    input clk_64,
    input reset,
    input locked,
    input [7:0] dato_recibido,  //Dato que entro de la UART
    input pulso_rx,             //Pulso que indica que recibi algo
    output valor_led,           //Salida para utilizar con las letras A y P
    output [7:0] dato_transmitido,  //Bytes del mensaje
    output pulso_envio              //Pulso individual para enviar cada letra del mensaje
    );

reg led_status;     //Registro interno para manipular el LED
reg [7:0] array [39:0]; //cada array tiene 8 elementos, hay 40 arrays para poder alamcenar los caracteres de "Programacion Logica para ingenieria"
reg [5:0] indice;   //Recorre cada letra de la frase
reg [7:0] dato_salida;  //Registro interno para enviar cada letra
reg [3:0] i;        //Variable de control para el for
reg pulso;          //Registro interno para ajustar un pulso por cada letra
reg flag_mensaje;   //Flag que indica que recibi una M y tengo que mostrar el mensaje
reg [9:0] delay;    //Agregar un delay entre caracteres
reg bit_enviado;    //Indica que se envio un bit

always @(posedge clk_64) begin
    if (~locked || reset) begin
        led_status <= 0;
        indice <= 0;
        dato_salida <= 0;
        i <= 0;
        pulso <= 0;
        flag_mensaje <= 0;
        delay <= 0;
        bit_enviado <= 0;
        array[0] <= 8'h50; // 'P'
        array[1] <= 8'h72; // 'r'
        array[2] <= 8'h6F; // 'o'
        array[3] <= 8'h67; // 'g'
        array[4] <= 8'h72; // 'r'
        array[5] <= 8'h61; // 'a'
        array[6] <= 8'h6D; // 'm'
        array[7] <= 8'h61; // 'a'
        array[8] <= 8'h63; // 'c'
        array[9] <= 8'h69; // 'i'
        array[10] <= 8'h6F; // 'o'
        array[11] <= 8'h6E; // 'n'
        array[12] <= 8'h20; // espacio
        array[13] <= 8'h4C; // 'L'
        array[14] <= 8'h6F; // 'o'
        array[15] <= 8'h67; // 'g'
        array[16] <= 8'h69; // 'i'
        array[17] <= 8'h63; // 'c'
        array[18] <= 8'h61; // 'a'
        array[19] <= 8'h20; // espacio
        array[20] <= 8'h70; // 'p'
        array[21] <= 8'h61; // 'a'
        array[22] <= 8'h72; // 'r'
        array[23] <= 8'h61; // 'a'
        array[24] <= 8'h20; // espacio
        array[25] <= 8'h49; // 'I'
        array[26] <= 8'h6E; // 'n'
        array[27] <= 8'h67; // 'g'
        array[28] <= 8'h65; // 'e'
        array[29] <= 8'h6E; // 'n'
        array[30] <= 8'h69; // 'i'
        array[31] <= 8'h65; // 'e'
        array[32] <= 8'h72; // 'r'
        array[33] <= 8'h69; // 'i'
        array[34] <= 8'h61; // 'a'
        array[35] <= 8'h20; // espacio
        array[36] <= 8'h32; // '2'
        array[37] <= 8'h30; // '0'
        array[38] <= 8'h32; // '2'
        array[39] <= 8'h33; // '3'
    end
    else begin
        if (pulso_rx) begin    
            if (dato_recibido == 8'h50 || dato_recibido == 8'h70)//P
                led_status <= 1;
            if (dato_recibido == 8'h61 || dato_recibido == 8'h41)//A
                led_status <= 0;
            if (dato_recibido == 8'h6D || dato_recibido == 8'h4D)//M
                flag_mensaje <= 1;
        end        
        if (flag_mensaje) begin
            delay <= delay + 1;        
            if (indice < 40 && ~bit_enviado) begin
                bit_enviado <= 1;
                for (i = 0; i <= 7; i = i+1)
                    dato_salida[i] <= array[indice][i]; //voy cargando cada uno de los array en dato de salida aux
                pulso <= 1;
                bit_enviado <= 1; //optimi
            end
            if (bit_enviado)
                pulso <= 0;       
            if (delay == 1000) begin //Agregamos mas de 704 de delay para que no se pisen los datos
                                     // 64 [pulsos/bits] * 11 [bits] = 704 [pulsos] de delay 
                indice <= indice + 1;
                delay <= 0;
                bit_enviado <= 0;
            end    
            if (indice == 40) begin
                flag_mensaje <= 0;
                indice <= 0;
                pulso <= 0;
            end        
        end                    
    end
end            

assign dato_transmitido[0]= dato_salida[0];
assign dato_transmitido[1]= dato_salida[1];
assign dato_transmitido[2]= dato_salida[2];
assign dato_transmitido[3]= dato_salida[3];
assign dato_transmitido[4]= dato_salida[4];
assign dato_transmitido[5]= dato_salida[5];
assign dato_transmitido[6]= dato_salida[6];
assign dato_transmitido[7]= dato_salida[7];
assign pulso_envio = pulso;
assign valor_led = led_status;

endmodule    