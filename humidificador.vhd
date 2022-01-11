--------------------------------------------------------------------
-- Practica 3. GeneraciÃƒÆ’Ã‚Â³n de Frecuencia, Relojes y Temporizadores.
-- Module Name: timer - Behavioral
-- Project Name: TemporizaciÃƒÆ’Ã‚Â³n.
-- Description:
--				Temporizador con ancho de pulso en ms
--																					* RPM
--------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity humidificador is
	Port (clk : in std_logic;
			start : in std_logic;
			HD : in std_logic; -- 1 Humificador y 0 Deshumificador
			pulsoH : out std_logic;
			pulsoD : out std_logic;
			pausaRH : inout std_logic);
end humidificador;


architecture Behavioral of humidificador is

component timer is
	Port (clk : in std_logic;
			start : in std_logic;
			Tms : in std_logic_vector (19 downto 0);
			P : out std_logic);
end component;

signal salidaTms : std_logic;
signal inicio : std_logic := '0';
	
begin
	tim : timer port map (clk, inicio, "00000000101110111000", salidaTms);
	
	process(start, inicio)
	begin
		if start = '1' then
			inicio <= '1';
		else
			inicio <= '0';
		end if;
	end process;
	
	process (start, inicio, salidaTms)
	begin
		if rising_edge(clk) then		
--			if (salidaTms = '1') then -- negar todos los pulsos si se utilizan leds
			if (start='1')then
				if(HD = '1') then 
					pulsoH <= '0';
					pulsoD <= '1';
				else
					pulsoH <= '1';
					pulsoD <= '0';
				end if;
			else
				pulsoH <= '1';
				pulsoD <= '1';
				pausaRH <= '0';
			end if;
		end if;
	end process;
end Behavioral;