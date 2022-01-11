library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity maquinaEstados is
	Port(clk : in std_logic;
			AN : out std_logic_vector(3 downto 0);
			displays : out std_logic_vector(6 downto 0);
			triggerEsquina : out std_logic;
			triggerTecho : out std_logic;
			ecoEsquina : in std_logic;
			ecoTecho : in std_logic;
			dataTemp : inout std_logic;
			posicionC : out std_logic;
			posicionF : out std_logic;
			ventiladorF : out std_logic;	--output(1)
			ventiladorC : out std_logic;	--output(0)
			pulsoHumidificador : out std_logic;
			pulsoVentiladorDesH : out std_logic;
			reset : in std_logic
			);
end maquinaEstados;

architecture behavioral of maquinaEstados is

	component milanesa is
	port
		(
			clk		 : in	std_logic;
			input	 : in	std_logic_vector(5 downto 0); --"543210"
			reset	 : in	std_logic;
			output	 : out	std_logic_vector(5 downto 0)
		);
	end component;

	component funcUltrasonicos is 
		port(clk: in STD_LOGIC;
			triggerTecho: out STD_LOGIC;
			ecoTecho: in STD_LOGIC;
			triggerEsquina: out STD_LOGIC;
			ecoEsquina: in STD_LOGIC;
			mov : out std_logic
			--movTecho : out std_logic;
			--movEsquina : out STD_LOGIC);
			);
	end component;

	component temperaturaFunc is
		Port( clk : in std_logic;
				AN : out std_logic_vector(3 downto 0);
				displays : out std_logic_vector(6 downto 0);
				data : inout std_logic;
				enable : in std_logic;
				salidaTemp : out std_logic_vector(7 downto 0);
				salidaRH : out std_logic_vector(7 downto 0)
				);
	end component;

	component humidificador is
		Port (clk : in std_logic;
				start : in std_logic;
				HD : in std_logic; -- 1 Humificador y 0 Deshumificador
				pulsoH : out std_logic;
				pulsoD : out std_logic;
				pausaRH : inout std_logic);
	end component;

	component decodificador_th is
		Port (clk : in std_logic;
				temp : in std_logic_vector(7 downto 0);
				rh : in std_logic_vector(7 downto 0);
				NT : out std_logic_vector(1 downto 0);
				TH : out std_logic;
				t_norm : out std_logic;
				h_norm : out std_logic;
				NH : out std_logic
--				ventiladorF : out std_logic;
--				ventiladorC : out std_logic
				);
	end component;

	component servomotor is
		Port ( clk : in STD_LOGIC;
				ResetPos : in std_logic;
				NT : in std_logic_vector(1 downto 0);
				TH : in std_logic;
				posicionC : out STD_Logic;
				posicionF : out STD_LOGIC
				);
	end component;

	signal input, output : std_logic_vector(5 downto 0) := (others => '0');
	signal temp, rh : std_logic_vector(7 downto 0) := (others => '0');
	signal nt: std_logic_vector(1 downto 0) := (others =>'0');
	
begin
	
	estados : milanesa port map(clk, 
										input, 
										not reset, 
										output);
	ultrasonicos :  funcUltrasonicos port map(clk, 
															triggerTecho, 
															ecoTecho, 
															triggerEsquina, 
															ecoEsquina, 
															mov => input(1));
	temperatura : temperaturaFunc port map(clk, 
														an, 
														displays, 
														dataTemp,
														enable => output(0), 
														salidaTemp => temp, 
														salidaRH => rh);
	humid : humidificador port map(clk, 
											start => output(3), 
											hd => output(1), 
											pulsoH => pulsoHumidificador,
											pulsoD => pulsoVentiladorDesH,
											pausaRH => input(0));
	dec_TempH : decodificador_th port map(clk,
														temp, 
														rh, 
														nt, 
														th => input(5),
														t_norm => input(3), 
														h_norm => input(2), 
														nh => input(4)
--														ventiladorF => ventiladorF,
--														ventiladorC => ventiladorC
														);
	servo : servomotor port map(clk, 
										resetPos => output(2),
										NT => nt,
										TH => input(5),
										posicionC => posicionC,
										posicionF => posicionF);
	
	process(input, output)
	begin
		if rising_edge(clk) then
			ventiladorF <= not output(4);
			ventiladorC <= not output(5);
		end if;
	end process;
	
end behavioral;