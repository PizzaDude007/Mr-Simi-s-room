library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity funcUltrasonicos is 
	Port(clk: in STD_LOGIC;
		comienza: in STD_LOGIC;
		AN: out std_logic_vector (3 downto 0);
		LED: out std_logic_vector (6 downto 0);
		trigger: out std_logic;
		eco: in std_logic);
--			anodos: out STD_LOGIC_VECTOR(3 downto 0);
--			segmentos: out STD_LOGIC_VECTOR (7 downto 0));
end funcUltrasonicos;

architecture behavioral of funcUltrasonicos is 
	component ultrasonico is
		port(clk: in STD_LOGIC;
			inicio: in STD_LOGIC;
			cm: out STD_LOGIC_VECTOR (8 downto 0);
			cent: out STD_LOGIC_VECTOR (3 downto 0);
			dec: out STD_LOGIC_VECTOR (3 downto 0);
			unid: out STD_LOGIC_VECTOR (3 downto 0);
			sensor_disp: out STD_LOGIC;
			sensor_eco: in STD_LOGIC);
	end component;

	component MuxDec4disp is
		Port ( clk : in std_logic;
				D0 : in std_logic_vector (6 downto 0);
				D1 : in std_logic_vector (6 downto 0);
				D2 : in std_logic_vector (6 downto 0);
				D3 : in std_logic_vector (6 downto 0);
				A : out std_logic_vector (3 downto 0);
				L : out std_logic_vector (6 downto 0));
	end component;

	signal display1, display2, display3, display4 : std_logic_vector (6 downto 0);
	signal cm: STD_LOGIC_VECTOR (8 downto 0);
	signal cent, dec, unid : STD_LOGIC_VECTOR (3 downto 0);
	
begin
	sonico : ultrasonico port map(clk, comienza, cm, cent, dec, unid, trigger, eco);
	multiplexada: MuxDec4disp port map (clk, display1, display2, display3, display4, AN, LED);
	
	EvaluaDistancia: process (cm, display1)
	begin
		if cm > "00011110" then
			display1 <= "1000111"; -- L
		elsif cm = "00011110" then
			display1 <= "1000000"; -- 0
		elsif cm < "00011110" then
			display1 <= "1000110"; -- C
		end if;
		
--		if cent = "0000" and dec < "0011" and unid >= "0000" then
--			display1 <= "1000111"; -- L
--		elsif cent = "0000" and dec = "0011" and unid = "0000" then
--			display1 <= "1000000"; -- 0 
--		elsif dec = "0011" and unid > "0000" then
--			display1 <= "1000110"; -- C
--		elsif dec > "0011" and unid >= "0000" then
--			display1 <= "1000110"; -- C
--		end if;
		
	end process;

	with cent select
	display2 <= "1000000" when "0000", --0
		  "1111001" when "0001", --1
		  "0100100" when "0010", --2
		  "0110000" when "0011", --3
		  "0011001" when "0100", --4
		  "0010010" when "0101", --5
		  "0000010" when "0110", --6
		  "1111000" when "0111", --7
		  "0000000" when "1000", --8
		  "0010000" when "1001", --9
		  "1000000" when others; --F
		  
	with dec select
	display3 <= "1000000" when "0000", --0
		  "1111001" when "0001", --1
		  "0100100" when "0010", --2
		  "0110000" when "0011", --3
		  "0011001" when "0100", --4
		  "0010010" when "0101", --5
		  "0000010" when "0110", --6
		  "1111000" when "0111", --7
		  "0000000" when "1000", --8
		  "0010000" when "1001", --9
		  "1000000" when others; --F
		  
	with unid select
	display4 <= "1000000" when "0000", --0
		  "1111001" when "0001", --1
		  "0100100" when "0010", --2
		  "0110000" when "0011", --3
		  "0011001" when "0100", --4
		  "0010010" when "0101", --5
		  "0000010" when "0110", --6
		  "1111000" when "0111", --7
		  "0000000" when "1000", --8
		  "0010000" when "1001", --9
		  "1000000" when others; --F

end behavioral;