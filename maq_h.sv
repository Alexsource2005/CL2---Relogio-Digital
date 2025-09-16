module maq_h (
	input logic maqh_clock,
	input logic maqh_reset,
	input logic maqh_enable, //habilitação a cada hora
	output logic [3:0] maqh_lsd, //Unidades de horas (0-9)
	output logic [1:0] maqh_msd // Dezenas de horas (0-2)
);

//Lógica sequencial para a contagem
always_ff @(posedge maqh_clock or posedge maqh_reset) begin
	if(maqh_reset) begin
		maqh_lsd <= 4'd0;
		maqh_msd <= 2'd0;
	end else if (maqh_enable) begin // Só atualiza quando habilitado
		if (maqh_msd == 2'd2 && maqh_lsd == 4'd3) begin
			maqh_lsd <= 4'd0;
			maqh_msd <= 2'd0;
		end else if (maqh_lsd == 4'd9) begin
			maqh_lsd <= 4'd0;
			maqh_msd <= maqh_msd + 2'd1;
		end else begin
			maqh_lsd <= maqh_lsd + 4'd1;
		end
	end
end

endmodule
