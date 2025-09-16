module Relogio_digital(
input logic clock, //Sinal de clock de 50MHz
input logic reset, // Sinal de reset assíncrono

// Saídas para os displays de 7 segmentos --- Cada saída é um vetor de 7 bits para controlar um display
output logic [6:0] s_lsd, // Unidades de segundo
output logic [6:0] s_msd, // Dezenas de segundo
output logic [6:0] m_lsd, // Unidades de minuto
output logic [6:0] m_msd, // Dezenas de minuto
output logic [6:0] h_lsd, // Unidades de hora
output logic [6:0] h_msd // Dezenas de hora
);

// 'enable1hz' é um pulso gerado a cada segundo pelo divisor de clock 
logic enable1hz;
logic incrementa_minuto, incrementa_hora;

//saídas BCD (Binary_Coded Decimal) dos contadores
logic [3:0] bcd_s_lsd, bcd_m_lsd, bcd_h_lsd; //dígitos menos significativos (0-9)
logic [2:0] bcd_s_msd, bcd_m_msd; //dígitos mais significativos dos segundos/minutos (0-5)
logic [1:0] bcd_h_msd; //dígito mais significativo das horas (0-2)

// Instância do divisor de clock - este bloco gera um pulso de 1Hz a partir do clock de 50MHz
enable_1hz divisor_clk (
	.enable_clock(clock),
	.enable_reset(reset),
	.enable_pulseout(enable1hz)
);

// instância do contador de segundos (maq_s) --- Conta de 00 a 59 e gera um pulso para incrementar os minutos
maq_s contador_segundos (
	.maqs_clock(clock),
	.maqs_reset(reset),
	.maqs_enable(enable1hz), //habilitado a cada segundo
	.maqs_incrementaminuto(incrementa_minuto),
	.maqs_lsd(bcd_s_lsd),
	.maqs_msd(bcd_s_msd)
);

// instância do contador de minutos (maq_m) --- conta de 00 a 59 quando 'incrementa_minuto' é ativado
maq_m contador_minutos(
	.maqm_clock(clock),
	.maqm_reset(reset),
	.maqm_enable(incrementa_minuto), //habilitado a cada minuto
	.maqm_incrementahora(incrementa_hora),
	.maqm_lsd(bcd_m_lsd),
	.maqm_msd(bcd_m_msd)
);

// instância do contador de horas (maq_h) --- conta de 00 a 23 quando 'incrementa_hora' é ativado.
maq_h contador_horas (
	.maqh_clock(clock),
	.maqh_reset(reset),
	.maqh_enable(incrementa_hora), // Habilitado a cada hora
	.maqh_lsd(bcd_h_lsd),
	.maqh_msd(bcd_h_msd)
);

// instâncias dos conversores BCD para 7 segmentos --- Converte a saída BCD de cada contador para o formato dos displays
bcd_7seg display_s_lsd (.bcd_bcd_in(bcd_s_lsd), .bcd_display_out(s_lsd));
bcd_7seg display_s_msd (.bcd_bcd_in({1'b0, bcd_s_msd}), .bcd_display_out(s_msd)); // Adiciona um bit '0' para completar 4 bits de entrada
bcd_7seg display_m_lsd (.bcd_bcd_in(bcd_m_lsd), .bcd_display_out(m_lsd));
bcd_7seg display_m_msd (.bcd_bcd_in({1'b0, bcd_m_msd}), .bcd_display_out(m_msd));
bcd_7seg display_h_lsd (.bcd_bcd_in(bcd_h_lsd), .bcd_display_out(h_lsd));
bcd_7seg display_h_msd (.bcd_bcd_in({2'b00, bcd_h_msd}), .bcd_display_out(h_msd)); // Adiciona dois bits '0' para completar 4 bits de entrada

endmodule
