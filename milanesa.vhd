-- Quartus II VHDL Template
-- Four-State Mealy State Machine

-- A Mealy machine has outputs that depend on both the state and
-- the inputs.	When the inputs change, the outputs are updated
-- immediately, without waiting for a clock edge.  The outputs
-- can be written more than once per state or per clock cycle.

library ieee;
use ieee.std_logic_1164.all;

entity milanesa is

	port
	(
		clk		 : in	std_logic;
		input	 : in	std_logic_vector(5 downto 0); --"543210"
		reset	 : in	std_logic;
		output	 : out	std_logic_vector(5 downto 0)
	);

end entity;

architecture rtl of milanesa is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);

	-- Register to hold the current state
	signal state : state_type;

begin

	process (clk, reset)
	begin

		if reset = '1' then
			state <= s0;

		elsif (rising_edge(clk)) then

			-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
				when s0=> -- ESTADO SOLITARIO
					if input(1) = '0' then --Empezando desde 0
						state <= s0;
					else
						state <= s1;
					end if;
				
				when s1=> -- INICIA MEDICIONES
					if input(1) = '0'  then
						state <= s0;
					elsif input = "000010" or input = "000011" then
						state <= s4;
					elsif input(1) = '1' and input(2) = '1' and input(3) = '0' and input(5) = '0' then
						state <= s9;
					elsif input(1) = '1' and input(2) = '0' and input(3) = '1' and input(4) = '0' then
						state <= s6;
					elsif input(1) = '1' and input(2) = '1' and input(3) = '1' then
						state <= s1;
					elsif input = "010010" or input = "010011" then
						state <= s5;
					elsif input(1) = '1' and input(2) = '0' and input(3) = '1' and input(4) = '1' then
						state <= s7;
					elsif input = "100011" or input = "100010" then 
						state <= s2;
					elsif input(1) = '1' and input(2) = '1' and input(3) = '0' and input(5) = '1' then
						state <= s8;
					elsif input = "110011" or input = "110010" then
						state <= s3;
					else
						state <=s0;
					end if;

				when s2=> -- CALIENTE - SECO
					if input(0) = '0' then
						state <= s1;
					else
						state <= s2;
					end if;
					
				when s3=> -- CALIENTE - HUMEDO
					if input(0) = '0' then
						state <= s1;
					else
						state <= s3;
					end if;
				when s4=> -- FRIO - SECO
					if input(0) = '0' then
						state <= s1;
					else
						state <= s4;
					end if;
				when s5=> -- FRIO - HUMEDO
					if input(0) = '0' then
						state <= s1;
					else
						state <= s5;
					end if;
				when s6=> -- NORMAL - SECO
					if input(0) = '0' then
						state <= s1;
					else
						state <= s6;
					end if;
				when s7=> -- NORMAL - HUMEDO
					if input(0) = '0' then
						state <= s1;
					else
						state <= s7;
					end if;
				when s8=> -- CALIENTE - NORMAL
					if input(3) = '0' then
						state <= s8;
					else
						state <= s1;
					end if;	
				when s9=> -- FRIO - NORMAL
					if input(3) = '0' then
						state <= s9;
					else
						state <= s1;
					end if;
			end case;

		end if;
	end process;

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
	process (state, input)
	begin
			case state is
				when s0=> -- ESTADO SOLITARIO
					if input(1) = '0' then --Empezando desde 0
						output <= "000100";
					else
						output <= "000101";
					end if;
				
				when s1=> -- INICIA MEDICIONES
					if input(1) = '0'  then
						output <= "000100";
					elsif input = "000010" or input = "000011" then
						output <= "101010";
					elsif input(1) = '1' and input(2) = '1' and input(3) = '0' and input(5) = '0' then
						output <= "100001";
					elsif input(1) = '1' and input(2) = '0' and input(3) = '1' and input(4) = '0' then
						output <= "001110";
					elsif input(1) = '1' and input(2) = '1' and input(3) = '1' then
						output <= "000101";
					elsif input = "010010" or input = "010011" then
						output <= "101000";
					elsif input(1) = '1' and input(2) = '0' and input(3) = '1' and input(4) = '1' then
						output <= "001100";
					elsif input = "100011" or input = "100010" then 
						output <= "011010";
					elsif input(1) = '1' and input(2) = '1' and input(3) = '0' and input(5) = '1' then
						output <= "010001";
					elsif input = "110011" or input = "110010" then
						output <= "011000";
					else
						output <= "000100";	
					end if;

				when s2=> -- CALIENTE - SECO
					if input(0) = '0' then
						output <= "010011";
					else
						output <= "010010";
					end if;
					
				when s3=> -- CALIENTE - HUMEDO
					if input(0) = '0' then
						output <= "011001";
					else
						output <= "011000";
					end if;
				when s4=> -- FRIO - SECO
					if input(0) = '0' then
						output <= "101011";
					else
						output <= "101010";
					end if;
				when s5=> -- FRIO - HUMEDO
					if input(0) = '0' then
						output <= "101001";
					else
						output <= "101000";
					end if;
				when s6=> -- NORMAL - SECO
					if input(0) = '0' then
						output <= "001111";
					else
						output <= "000110";
					end if;
				when s7=> -- NORMAL - HUMEDO
					if input(0) = '0' then
						output <= "001101";
					else
						output <= "001100";
					end if;
				when s8=> -- CALIENTE - NORMAL
					if input(3) = '0' then
						output <= "010001";
					else
						output <= "010001";
					end if;	
				when s9=> -- FRIO - NORMAL
					if input(3) = '0' then
						output <= "100001";
					else
						output <= "100001";
					end if;
				when others=>  output <= "000100";
			end case;
	end process;

end rtl;
