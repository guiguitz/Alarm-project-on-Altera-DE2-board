library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;

entity tb_Projeto_3 is
end tb_Projeto_3;

architecture teste of tb_Projeto_3 is

component Projeto_3 is
port (
		--Entradas:
		reset          : in    std_logic; -- reset input
		clock          : in    std_logic; -- clock input
		HoraAlarme0 	: in    unsigned(4 downto 0);
		MinAlarme0  	: in    unsigned(5 downto 0);
		HoraAlarme1 	: in    unsigned(4 downto 0);
		MinAlarme1  	: in    unsigned(5 downto 0);
		HoraAlarme2 	: in    unsigned(4 downto 0);
		MinAlarme2     : in    unsigned(5 downto 0);
		
		--Saídas:
		alarme         : out std_logic;
		segAtualSaida  : out unsigned(5 downto 0);
	   minAtualSaida  : out unsigned(5 downto 0);
	   horaAtualSaida : out unsigned(4 downto 0);
		
		--Leds de 7 segmentos:
		HEX0      	   : out   std_logic_vector(6 downto 0);
		HEX1       		: out   std_logic_vector(6 downto 0);
		HEX2       		: out   std_logic_vector(6 downto 0);
		HEX3       		: out   std_logic_vector(6 downto 0);
		HEX4       		: out   std_logic_vector(6 downto 0);
		HEX5       		: out   std_logic_vector(6 downto 0);
		HEX6       		: out   std_logic_vector(6 downto 0);
		HEX7       		: out   std_logic_vector(6 downto 0)
		);
end component;

--Sinais para o port map:
signal reset          : std_logic := '0';
signal clock          : std_logic := '0';
signal horaAlarme0    : unsigned(4 downto 0) := "00000";
signal minAlarme0     : unsigned(5 downto 0) := "000000";
signal horaAlarme1    : unsigned(4 downto 0) := "00000";
signal minAlarme1     : unsigned(5 downto 0) := "000000";
signal horaAlarme2    : unsigned(4 downto 0) := "00000";
signal minAlarme2     : unsigned(5 downto 0) := "000000";
signal segAtualSaida  : unsigned(5 downto 0) := "000000";
signal minAtualSaida  : unsigned(5 downto 0) := "000000";
signal horaAtualSaida : unsigned(4 downto 0) := "00000";
signal alarme         : std_logic := '0';
signal HEX0           : std_logic_vector(6 downto 0) := "0000000";
signal HEX1           : std_logic_vector(6 downto 0) := "0000000";
signal HEX2           : std_logic_vector(6 downto 0) := "0000000";
signal HEX3           : std_logic_vector(6 downto 0) := "0000000";
signal HEX4           : std_logic_vector(6 downto 0) := "0000000";
signal HEX5           : std_logic_vector(6 downto 0) := "0000000";
signal HEX6           : std_logic_vector(6 downto 0) := "0000000";
signal HEX7           : std_logic_vector(6 downto 0) := "0000000";

--Sinais internos:

--Flags:
signal escritaFlag  : std_logic := '1';
signal leituraFlag  : std_logic := '1';

--Arquivo de saída:
file saidaArq       : text open write_mode is "saida.txt";
file entradasArq    : text open read_mode is "entradas.txt";

--Deinições para o clock :
constant PERIOD     : time := 40 ns;
constant DUTY_CYCLE : real := 0.5;

begin
instancia_Projeto_3: Projeto_3 port map(
reset=>reset,
clock=>clock,
horaAlarme0=>horaAlarme0,
minAlarme0=>minAlarme0,
horaAlarme1=>horaAlarme1,
minAlarme1=>minAlarme1,
horaAlarme2=>horaAlarme2,
minAlarme2=>minAlarme2,
segAtualSaida=>segAtualSaida,
minAtualSaida=>minAtualSaida,
horaAtualSaida=>horaAtualSaida,
alarme=>alarme,
HEX0=>HEX0,
HEX1=>HEX1,
HEX2=>HEX2,
HEX3=>HEX3,
HEX4=>HEX4,
HEX5=>HEX5,
HEX6=>HEX6,
HEX7=>HEX7

);

------------------------------------------------------------------------------------
------ Processo para escrever os dados de saida no arquivo saidaArq.txt
------------------------------------------------------------------------------------ 

	processo_de_escrita : process
	variable linhaArq : line;
	begin
		while true loop
			wait until rising_edge(alarme);
			write(linhaArq, string'("Alarme tocando: "));
			write(linhaArq, to_integer(horaAtualSaida));
			write(linhaArq, ':');
			write(linhaArq, to_integer(minAtualSaida));
			writeline(saidaArq, linhaArq);
			wait for PERIOD;
		end loop;
	end process processo_de_escrita;
	
	
------------------------------------------------------------------------------------
----------------- Processo para ler os dados do arquivo entradasArq.txt
------------------------------------------------------------------------------------

	processo_leitura_clock : process
		variable linhaArq          : line;
		variable entradaInteiroMin : integer;
		variable entradaInteiroHor : integer;
	begin
		readline(entradasArq, linhaArq);
		read(linhaArq, entradaInteiroHor);
		horaAlarme0 <= to_unsigned(entradaInteiroHor, 5);
		readline(entradasArq, linhaArq);
		read(linhaArq, entradaInteiroMin);
		minAlarme0 <= to_unsigned(entradaInteiroMin, 6);
		
		readline(entradasArq, linhaArq);
		read(linhaArq, entradaInteiroHor);
		horaAlarme1 <= to_unsigned(entradaInteiroHor, 5);
		readline(entradasArq, linhaArq);
		read(linhaArq, entradaInteiroMin);
		minAlarme1 <= to_unsigned(entradaInteiroMin, 6);
		
		readline(entradasArq, linhaArq);
		read(linhaArq, entradaInteiroHor);
		horaAlarme2 <= to_unsigned(entradaInteiroHor, 5);
		readline(entradasArq, linhaArq);
		read(linhaArq, entradaInteiroMin);
		minAlarme2 <= to_unsigned(entradaInteiroMin, 6);
		
		clock_loop : loop
			clock <= '0';
         wait for (PERIOD - (PERIOD * DUTY_CYCLE));
         clock <= '1';
         wait for (PERIOD * DUTY_CYCLE);
      end loop clock_loop;
	end process processo_leitura_clock;	

end teste;