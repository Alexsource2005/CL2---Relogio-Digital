// Módulo para gerar um pulso de 1Hz a partir de um clock de 50MHz;
// Ele conta 49.999.999 ciclos de clock e gera um pulso no ciclo seguinte
module enable_1hz(
	input logic enable_clock, //clock de entrada
	input logic enable_reset,
	output logic enable_pulseout // Saída de pulso (1Hz)
);
	// Contador para chegar a 50 milhões
	logic [25:0] contador;
	
	//Lógica sequencial para o contador
	always_ff @(posedge enable_clock or posedge enable_reset) begin
		if(enable_reset) begin
			contador <= 26'd0;
		end else if (contador == 26'd4999999) begin
			contador <= 26'd0; // Zera o contador apos atingir o limite
		end else begin
			contador <= contador + 26'd1;
		end
	end

	//Lógica combinacional para gerar o pulso de saída.
	assign enable_pulseout = (contador == 26'd4999999);
endmodule
