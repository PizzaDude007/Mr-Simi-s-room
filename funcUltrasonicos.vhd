library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;

entity funcUltrasonicos is 
	port(clk: in STD_LOGIC;
		triggerTecho: out STD_LOGIC;
		ecoTecho: in STD_LOGIC;
		triggerEsquina: out STD_LOGIC;
		ecoEsquina: in STD_LOGIC;
		mov : out std_logic
		--movTecho : out std_logic;
		--movEsquina : out STD_LOGIC);
		);
end funcUltrasonicos;

architecture behavioral of funcUltrasonicos is 
	component ultrasonico is
		Port(clk: in STD_LOGIC;
				inicio: in STD_LOGIC;
				cm: out STD_LOGIC_VECTOR (8 downto 0);
				cent: out STD_LOGIC_VECTOR (3 downto 0);
				dec: out STD_LOGIC_VECTOR (3 downto 0);
				unid: out STD_LOGIC_VECTOR (3 downto 0);
				sensor_disp: out STD_LOGIC;
				sensor_eco: in STD_LOGIC);
	end component;

	component relojMS is
		Port(clk: in STD_LOGIC;
			Tms : in std_logic_vector(19 downto 0); 	 
			reloj : out std_logic
			);
	end component;

	signal cmEsquina: STD_LOGIC_VECTOR (8 downto 0);
	signal inicioSonico : std_logic;
	signal centEsquina, decEsquina, unidEsquina : STD_LOGIC_VECTOR (3 downto 0);
	signal cmTecho: STD_LOGIC_VECTOR (8 downto 0);
	signal centTecho, decTecho, unidTecho : STD_LOGIC_VECTOR (3 downto 0);
	
begin
	relojSonicos : relojMs port map (clk, "00000000010111011100", inicioSonico);
	
	sonicoEsquina : ultrasonico port map(clk, inicioSonico, cmEsquina, centEsquina, decEsquina, unidEsquina, triggerEsquina, ecoEsquina);

	sonicoTecho : ultrasonico port map(clk, inicioSonico, cmTecho, centTecho, decTecho, unidTecho, triggerTecho, ecoTecho);

	
	
	EvaluaDistancia: process (cmEsquina, cmTecho)
		variable centimetrosTecho, centimetrosEsquina : integer;
	begin

		if (rising_edge(inicioSonico)) then
			centimetrosEsquina := to_integer(unsigned(cmEsquina));
			
			centimetrosTecho := to_integer(unsigned(cmTecho));
			
			--if centimetrosTecho /= 21 then
			--	mov <= '1';
			--end if;

			if centimetrosEsquina < 31 then
--				movEsquina <= '1';
				mov <= '1';
			else 
--				movEsquina <= '0';	
				mov <= '0';
			end if;

			if centimetrosTecho < 28 then
--				movTecho <= '1';
				mov <= '1';
			else 
--				movTecho <= '0';
				mov <= '0';
			end if;
		end if;
	end process;

	

end behavioral;