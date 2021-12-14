library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity muxdec4disp is
Port ( clk : in std_logic;
		 D0 : in std_logic_vector (3 downto 0) := "0001";
		 D1 : in std_logic_vector (3 downto 0) := "0010";
		 D2 : in std_logic_vector (3 downto 0) := "0011";
		 D3 : in std_logic_vector (3 downto 0) := "0100";
		 A : out std_logic_vector (3 downto 0);
		 L : out std_logic_vector (6 downto 0));
end muxdec4disp;

architecture behavioral of muxdec4disp is 
	signal rapido: std_logic;
	signal Qs: std_logic_vector (3 downto 0); 
	signal Qr: std_logic_vector (1 downto 0);

	
begin
	divisor : process (clk)
		variable CUENTA: std_logic_vector(27 downto 0) := X"0000000";
	begin
		if rising_edge (clk) then
			if CUENTA = X"48009E0" then
				CUENTA := X"0000000";
			else
				CUENTA := CUENTA + 1;
			end if;
		end if;
		rapido <= CUENTA(10);
	end process;
	
	CONTRAPID: process(rapido)
		variable CUENTA: std_logic_vector(1 downto 0) := "00";
	begin
		if rising_edge(rapido) then
			CUENTA := CUENTA + 1;
		end if;
		Qr <= CUENTA;
	end process;
	
	MUXY: process(Qr, D0, D1, D2, D3)
	begin
		if Qr = "00" then
			Qs <= D0;
		elsif Qr = "01" then
			Qs <= D1;
		elsif Qr = "10" then
			Qs <= D2;
		elsif Qr = "11" then
			Qs <= D3;
		end if;
	end process;
	
	seledisplay: process (Qr)
	begin
		case Qr is
			when "00" =>
				A<= "1110";
			when "01" =>
				A<="1101";
			when "10" =>
				A<="1011";
			when others =>
				A<="0111";
		end case;
	end process;

	
	with Qs select
		L <= "1000000" when "0000", --0
			  "1111001" when "0001", --1
			  "0100100" when "0010", --2
			  "0110000" when "0011", --3
			  "0011001" when "0100", --4
			  "0010010" when "0101", --5
			  "0000010" when "0110", --6
			  "1111000" when "0111", --7
			  "0000000" when "1000", --8
			  "0010000" when "1001", --9
			  "0001000" when "1010", --A
			  "1100000" when "1011", --b
			  "0000011" when "1100", --C
			  "0100001" when "1101", --d
			  "0000110" when "1110", --E
			  "1000000" when others; --F
end behavioral;