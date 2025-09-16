// Máquina de estados/Contador para os segundos.
module maq_s (
	input logic maqs_clock,
	input logic maqs_reset,
	input logic maqs_enable, //Habilitação (pulso de 1Hz)
	output logic maqs_incrementaminuto, //Pulso para o contador de minutos
	output logic [3:0] maqs_lsd, //Unidade de segundo (0-9)
	output logic [2:0] maqs_msd //Dezena de segundo (0-5)
);

// Lógica sequencial para a contagem
always_ff @(posedge maqs_clock or posedge maqs_reset) begin
	if(maqs_reset) begin
		maqs_lsd <= 4'd0;
		maqs_msd <= 3'd0;
	end else if (maqs_enable) begin // Só atualiza quando habilitado 
		if(maqs_lsd == 4'd9) begin
			maqs_lsd <= 4'd0;
			if(maqs_msd == 3'd5) begin
				maqs_msd <= 3'd0;
			end else begin
				maqs_msd <= maqs_msd + 3'd1;
			end
		end else begin
			maqs_lsd <= maqs_lsd + 4'd1;
		end
	end
end 

// Lógica combinacional para gerar o pulso de incremento de minutos
// Gera um pulso quando os segundos estão em 59 e o enable está ativo
assign maqs_incrementaminuto = (maqs_lsd == 4'd9) && (maqs_msd == 3'd5) && maqs_enable;

endmodule
