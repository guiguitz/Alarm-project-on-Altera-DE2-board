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
		reset      : in    std_logic; -- reset input
		clock      : in    std_logic; -- clock input
		horaAlarme : in    unsigned(4 downto 0);
		minAlarme  : in    unsigned(5 downto 0);
		
		--Saídas:
		alarme         : out   std_logic;
		segAtualSaida  : out unsigned(5 downto 0);
	   minAtualSaida  : out unsigned(5 downto 0);
	   horaAtualSaida : out unsigned(4 downto 0);
		
		--Leds de 7 segmentos:
		HEX0       : out   std_logic_vector(6 downto 0);
		HEX1       : out   std_logic_vector(6 downto 0);
		HEX2       : out   std_logic_vector(6 downto 0);
		HEX3       : out   std_logic_vector(6 downto 0);
		HEX4       : out   std_logic_vector(6 downto 0);
		HEX5       : out   std_logic_vector(6 downto 0);
		HEX6       : out   std_logic_vector(6 downto 0);
		HEX7       : out   std_logic_vector(6 downto 0)
		);
end component;

--Sinais para o port map:
signal reset          : std_logic := '0';
signal clock          : std_logic := '0';
signal horaAlarme     : unsigned(4 downto 0) := "00000";
signal minAlarme      : unsigned(5 downto 0) := "000000";
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
signal segAtualAux  : unsigned(5 downto 0) := "000000";
signal minAtualAux  : unsigned(5 downto 0) := "000000";
signal horaAtualAux : unsigned(4 downto 0) := "00000";

--Flags:
signal escritaFlag  : std_logic := '1';
signal leituraFlag  : std_logic := '1';

--Arquivo de saída:
file saidaArq       : text open write_mode is "saida.txt";
file entradasArq    : text open write_mode is "entradas.txt";

--Clock period definitions
constant PERIOD     : time := 2 ns;
constant DUTY_CYCLE : real := 0.5;
constant OFFSET     : time := 30 ns;

begin
instancia_Projeto_3: Projeto_3 port map(

reset=>reset,
clock=>clock,
horaAlarme=>horaAlarme,
minAlarme=>minAlarme,
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
----------------- processo para gerar o sinal de clock 
------------------------------------------------------------------------------------		
	process    
   begin
		clock_loop : loop
			clock <= '0';
         wait for (PERIOD - (PERIOD * DUTY_CYCLE));
         clock <= '1';
         wait for (PERIOD * DUTY_CYCLE);
      end loop clock_loop;
   end process;

------------------------------------------------------------------------------------
------ Processo para escrever os dados de saida no arquivo saidaArq.txt
------------------------------------------------------------------------------------ 
	processo_de_escrita : process
	variable linha : line;
	begin
		wait until clock = '0';
			if (escritaFlag = '1') then
				write(linha, to_integer(signed(horaAlarme)));
				write(linha, ':');
				write(linha, to_integer(signed(minAlarme)));
				writeline(saidaArq, linha);
				escritaFlag <= '0';
			end if;
	end process processo_de_escrita;
	
	
------------------------------------------------------------------------------------
----------------- Processo para ler os dados do arquivo entradasArq.txt
------------------------------------------------------------------------------------

--	processo_de_leitura : process
--		variable linha : line;
--		variable input : std_logic_vector(5 downto 0) := "000111";
--	begin
--		wait until falling_edge(clock);
--		while not endfile(saida) loop
--			if read_data_in = '1' then
--				readline(saida, linea);	--Reading the alarm hour
--				read(linea, input);
--				HoraAlarme <= input;
--				readline(saida, linea);	--Reading the alarm min
--				read(linea, input);
--				MinAlarme <= input;
--			end if;
--			wait for PERIOD;
--		end loop;
--		wait;
--	end process processo_de_leitura;	

end teste;