library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity maquinaEstados is
Port(clk : in std_logic);
end maquinaEstados;

component milanesa is
port
	(
		clk		 : in	std_logic;
		input	 : in	std_logic_vector(5 downto 0); --"543210"
		reset	 : in	std_logic;
		output	 : out	std_logic_vector(5 downto 0)
	);
end component;

component test is
Port( clk : in std_logic;
		AN : out std_logic_vector(3 downto 0);
		displays : out std_logic_vector(6 downto 0);
		data : inout std_logic;
		boton : in std_logic;
		breset : in std_logic;
		fin : out std_logic
		);
end component;



architecture behavioral of maquinaEstados is
begin
	
	
end behavioral;