`timescale 1ns / 1ps

`timescale 1ns / 1ps

module multiplexor(
    input clk_64,
    input reset,
    input locked,
    input pulso_a,      //Pulso que indica que debo sacar una A con el boton
    input [7:0] entrada_echo,   //Caracter que debo replicar
    input pulso_echo,   //Pulso que indica que debo devolver el caracter recibido + 1
    input [7:0] entrada_comandos,   //Letra que ingresa al modulo comandos
    input pulso_comandos,   //Pulso que indica que debo prender/apagar el led o mostrar el mensaje
    input switch,       //Valor del switch SW0
    output pulso_salida,    //dato de salida, resultado de la multiplexacion 
    output [7:0] dato_salida);  //pulso de salida, resultado de la multiplexacion

//REGISTROS GENERALES
reg [7:0] dato_salida_aux;
reg pulso_salida_aux;
reg [3:0] i;

//Primer contestador - Devuelve A al pulsar el boton 1
reg delay;          //Flag para poder esperar entre tramas
reg [7:0] byte;     //Cargo el valor de la A
reg [20:0] contador_delay; //Contador para acomodar el tiempo de espera entre tramas

always @(posedge clk_64) begin
    if (~locked || reset) begin
        delay <= 0; 
        contador_delay <= 0;
        byte <= 8'h41; //Le paso una "A"
    end 
    else begin
        //Boton A 
        if (pulso_a && ~delay) begin
            for (i = 0; i < 8; i = i + 1)
                dato_salida_aux[i] <= byte[i];  //Se carga la A
            delay <= 1;
            pulso_salida_aux <= 1;              //Envio un pulso para mostrar la A
        end    
        if (pulso_salida_aux)
            pulso_salida_aux <= 0;            
        if (delay) begin        //Delay aproximado de 1/4 de [s]
            contador_delay <= contador_delay + 1;
            if (contador_delay == 1843200) begin    //7370000 -> 1s 
                delay <= 0;                         //1843200 -> [1/4]s
                contador_delay <= 0;
            end    
        end
        //Contestador
        if (~switch && pulso_echo) begin
            for (i = 0; i < 8; i = i + 1)
                dato_salida_aux[i] = entrada_echo[i];   //Copio el dato resultado del modulo contestador
            pulso_salida_aux <= 1;    
            if (pulso_salida_aux)                       //Envio un pulso para mostrar el dato replicado
                pulso_salida_aux <= 0;
        end
        //Comandos
        if (switch && pulso_comandos) begin             //Copio cada letra del mensaje
            for (i = 0; i < 8; i = i + 1)
                dato_salida_aux[i] = entrada_comandos[i];
            pulso_salida_aux <= 1;                      //Envio un pulso por cada letra del mensaje
            if (pulso_salida_aux)
                pulso_salida_aux <= 0;
        end                         
    end
end

assign pulso_salida = pulso_salida_aux;
assign dato_salida[0] = dato_salida_aux[0];
assign dato_salida[1] = dato_salida_aux[1];
assign dato_salida[2] = dato_salida_aux[2];
assign dato_salida[3] = dato_salida_aux[3];
assign dato_salida[4] = dato_salida_aux[4];
assign dato_salida[5] = dato_salida_aux[5];
assign dato_salida[6] = dato_salida_aux[6];
assign dato_salida[7] = dato_salida_aux[7];

endmodule