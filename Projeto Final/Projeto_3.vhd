library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Projeto_3 is
	generic
	(
		Pulsos1Seg  : integer := 50000000 -- Contidade de pulsos de clock para 1 segundo. Como o clock é de 1ns, precisamos de 1x10^9 pulsos.
	);
	port (
		--Entradas:
		reset      : in    std_logic; -- reset input
		clock      : in    std_logic; -- clock input
		HoraAlarme : in    unsigned(4 downto 0);
		MinAlarme  : in    unsigned(5 downto 0);
		
		--Saídas:
		alarme         : out   std_logic;
		segAtualSaida  : out unsigned(5 downto 0) := "000000";
	   minAtualSaida  : out unsigned(5 downto 0) := "000000";
	   horaAtualSaida : out unsigned(4 downto 0) := "00000";
		
		--Leds de 7 segmentos:
		HEX0       : out   std_logic_vector(6 downto 0) := "1111111";
		HEX1       : out   std_logic_vector(6 downto 0) := "1111111";
		HEX2       : out   std_logic_vector(6 downto 0);
		HEX3       : out   std_logic_vector(6 downto 0);
		HEX4       : out   std_logic_vector(6 downto 0);
		HEX5       : out   std_logic_vector(6 downto 0);
		HEX6       : out   std_logic_vector(6 downto 0);
		HEX7       : out   std_logic_vector(6 downto 0)
		);
end Projeto_3;

architecture arch of Projeto_3 is
	type state_type is (I, P, S, M, H);
	signal state        : state_type;
	signal pulsos       : integer range 0 to 50000000;
	signal segAtualAux  : unsigned(5 downto 0) := "000000";
	signal minAtualAux  : unsigned(5 downto 0) := "000000";
	signal horaAtualAux : unsigned(4 downto 0) := "00000";

begin
	processo_relogio : process (clock, reset)
	begin
		if reset = '1' then
			state <= I;
		elsif (rising_edge(clock)) then
			case state is	
				when I => -- Estado I: Esse estado tem como objetivo zerar segAtualAux, minAtualAux, horaAtualAux
					state <= P;	
					segAtualAux <= "000000";
					minAtualAux <= "000000";
					horaAtualAux <= "00000";
					
				when P => -- Estado P: Esse estado verifica se já se passou um segundo ou não:
				
					--Checagem de estados:
					if (pulsos = Pulsos1Seg) then
						state <= S;
					else
						pulsos <= pulsos + 1;
						state <= P;
					end if;
					
				when S => -- Estado S
				
					--Adicionando 1 segundo e zerando pulsos:
					segAtualAux <= segAtualAux + "000001"; 
					pulsos <= 0;
	
					--Checagem de estados:
					if segAtualAux < "111011" then
						state <= P;
					else
						state <= M;
					end if;
				
				when M => -- Estado M:	
				
					--Adicionando 1 minuto e zerando segundos e pulsos:
					minAtualAux <= minAtualAux + "000001";
					segAtualAux <= "000000";
					pulsos <= 0;
					
					--Checagem de estados:
					if minAtualAux < "111011" then
						state <= P;
					else
						state <= H;
					end if;
					
				when H => -- Estado H
				
					--Adicionando uma hora e zerando minutos e pulsos:
					horaAtualAux <= horaAtualAux + "00001";
					minAtualAux <= "000000";
					pulsos <= 0;
					
					--Checagem de estados:
					if horaAtualAux < "10111" then
						state <= P;
					else
						state <= I;
					end if;		
			end case;
		end if;
	end process processo_relogio;
	
	processo_7_segmentos : process(minAtualAux, horaAtualAux, segAtualAux) 
	variable buffAux : std_logic_vector(6 downto 0);
	begin
	
		case (segAtualAux mod 10) is 
			when "000000" => buffAux := "1000000";
			when "000001" => buffAux := "1111001";
			when "000010" => buffAux := "0100100";
			when "000011" => buffAux := "0110000";
			when "000100" => buffAux := "0011001";
			when "000101" => buffAux := "0010010";		
			when "000110" => buffAux := "0000010";
			when "000111" => buffAux := "1111000";
			when "001000" => buffAux := "0000000";    
			when "001001" => buffAux := "0010000";
			when others => buffAux := "1000000";
		end case;
		HEX2 <= buffAux;

		case (segAtualAux / 10) is 
			when "000000" => buffAux := "1000000";
			when "000001" => buffAux := "1111001";
			when "000010" => buffAux := "0100100";
			when "000011" => buffAux := "0110000";
			when "000100" => buffAux := "0011001";
			when "000101" => buffAux := "0010010";		
			when "000110" => buffAux := "0000010";
			when "000111" => buffAux := "1111000";
			when "001000" => buffAux := "0000000";    
			when "001001" => buffAux := "0010000";
			when others => buffAux := "1000000";
		end case;		
		HEX3 <= buffAux;
		
		case (minAtualAux mod 10) is 
			when "000000" => buffAux := "1000000";
			when "000001" => buffAux := "1111001";
			when "000010" => buffAux := "0100100";
			when "000011" => buffAux := "0110000";
			when "000100" => buffAux := "0011001";
			when "000101" => buffAux := "0010010";		
			when "000110" => buffAux := "0000010";
			when "000111" => buffAux := "1111000";
			when "001000" => buffAux := "0000000";    
			when "001001" => buffAux := "0010000";
			when others => buffAux := "1000000";
		end case;
		HEX4 <= buffAux;

		case (minAtualAux / 10) is 
			when "000000" => buffAux := "1000000";
			when "000001" => buffAux := "1111001";
			when "000010" => buffAux := "0100100";
			when "000011" => buffAux := "0110000";
			when "000100" => buffAux := "0011001";
			when "000101" => buffAux := "0010010";		
			when "000110" => buffAux := "0000010";
			when "000111" => buffAux := "1111000";
			when "001000" => buffAux := "0000000";    
			when "001001" => buffAux := "0010000";
			when others => buffAux := "1000000";
		end case;
		HEX5 <= buffAux;
	
		case (horaAtualAux mod 10) is 
			when "00000" => buffAux := "1000000";
			when "00001" => buffAux := "1111001";
			when "00010" => buffAux := "0100100";
			when "00011" => buffAux := "0110000";
			when "00100" => buffAux := "0011001";
			when "00101" => buffAux := "0010010";		
			when "00110" => buffAux := "0000010";
			when "00111" => buffAux := "1111000";
			when "01000" => buffAux := "0000000";    
			when "01001" => buffAux := "0010000";
			when others => buffAux := "1000000";
		end case;
		HEX6 <= buffAux;

		case (horaAtualAux / 10) is 
			when "00000" => buffAux := "1000000";
			when "00001" => buffAux := "1111001";
			when "00010" => buffAux := "0100100";
			when "00011" => buffAux := "0110000";
			when "00100" => buffAux := "0011001";
			when "00101" => buffAux := "0010010";		
			when "00110" => buffAux := "0000010";
			when "00111" => buffAux := "1111000";
			when "01000" => buffAux := "0000000";    
			when "01001" => buffAux := "0010000";
			when others => buffAux := "1000000";
		end case;
		HEX7 <= buffAux;		
	end process processo_7_segmentos;
	
  --Process do Alarme:	
	processo_alarme : process (minAtualAux, horaAtualAux, minAlarme, horaAlarme)
	begin	
		if(horaAtualAux = HoraAlarme and minAtualAux = MinAlarme) then 
			alarme <= '1';
		else
			alarme <= '0';
		end if;
	end process processo_alarme;
		
	proces_atualiza_horario_saida : process (segAtualAux, minAtualAux, horaAtualAux)
	begin
		segAtualSaida <= segAtualAux;
		minAtualSaida <= minAtualAux;
		horaAtualSaida <= horaAtualAux;
	end process proces_atualiza_horario_saida;
end arch;
