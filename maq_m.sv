module maq_m(
	input logic maqm_clock,
	input logic maqm_reset,
	input logic maqm_enable, //habilitação a cada minuto
	output logic maqm_incrementahora, // Pulso para o contador de horas
	output logic [3:0] maqm_lsd, //Unidade de minuto (0-9)
	output logic [2:0] maqm_msd // Dezena de minuto (0-5)
);

// Lógica sequencial para a contagem
always_ff @(posedge maqm_clock or posedge maqm_reset) begin
	if(maqm_reset) begin
		maqm_lsd <= 4'd0;
		maqm_msd <= 3'd0;
	end else if (maqm_enable) begin //atualiza quando habilitado
		if(maqm_lsd == 4'd9) begin
			maqm_lsd <= 4'd0;
			if(maqm_msd == 3'd5) begin
				maqm_msd <= 3'd0;
			end else begin
				maqm_msd <= maqm_msd + 3'd1;
			end
		end else begin
			maqm_lsd <= maqm_lsd + 4'd1;
		end
	end
end

// Lógica combinacional para gerar o pulso de incremento de horas
// Gera um pulso quando os minutos estão em 59 e o enable está ativo
assign maqm_incrementahora = (maqm_lsd == 4'd9) && (maqm_msd == 3'd5) && (maqm_enable);

endmodule
