// Módulo para converter um valor BCD de 4 bits para um display de 7 segmentos
module bcd_7seg (
	input logic  [3:0] bcd_bcd_in, //entrada BCD (0-9)
	output logic [6:0] bcd_display_out // Saída para o display (segmentos g,f,e,d,c,b,a)
);

	//Lógica combinacional para a conversão
	always_comb begin
		case(bcd_bcd_in)
			4'd0: bcd_display_out = 7'b0111111; // 0
			4'd1: bcd_display_out = 7'b0000110; // 1
			4'd2: bcd_display_out = 7'b1011011; // 2
			4'd3: bcd_display_out = 7'b1001111; // 3
			4'd4: bcd_display_out = 7'b1100110; // 4
			4'd5: bcd_display_out = 7'b1101101; // 5
			4'd6: bcd_display_out = 7'b1111101; // 6
			4'd7: bcd_display_out = 7'b0000111; // 7
			4'd8: bcd_display_out = 7'b1111111; // 8
			4'd9: bcd_display_out = 7'b1101111; // 9
			default: bcd_display_out = 7'b0000000; // Desligado
		endcase
	end

endmodule
