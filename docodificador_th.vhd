library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity decodificador_th is
	Port ( temp : in std_logic_vector(7 downto 0);
			rh : in std_logic_vector(7 downto 0);
			NT : out std_logic_vector(1 downto 0);
			TH : out std_logic;
			t_norm : out std_logic;
			h_norm : out std_logic;
			NH : out std_logic);
end decodificador_th;

architecture behavioral of servomotor is
	niveles : process()
		variable temperatura, humedad : integer;
	begin
		temperatura := to_integer(unsigned(temp));
		humedad := to_integer(unsigned(temp));

		if temperatura >= 22 and temperatura =< 26 then 
			th <= '0';
			t_norm <= '1';
			nt <= "00";
		elsif temperatura < 22 then 
			th <= '0';
			t_norm <= '0';
			if temperatura >= 20 then 
				nt <= "01";
			elsif temperatura >= 18 and temperatura < 20 then 
				nt <= "10";
			else
				nt <= "11";
			end if;
		else
			th <= '1';
			t_norm <= '0';
			if temperatura <= 28 then 
				nt <= "01";
			elsif temperatura < 30 and temperatura > 28 then 
				nt <= "10";
			else
				nt <= "11";
			end if;
		end if;

		if humedad >= 40 and humedad =< 60 then 
			NH <= '0';
			h_norm <= '1';
		elsif humedad < 40 then 
			NH <= '0';
			h_norm <= '0';
		else
			NH <= '1';
			h_norm <= '0';
		end if;

	end process;
end behavioral;
		
		
		
		