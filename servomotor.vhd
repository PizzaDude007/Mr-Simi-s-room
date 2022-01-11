library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity servomotor is
	Port ( clk : in STD_LOGIC;
            ResetPos : in std_logic;
            NT : in std_logic_vector(1 downto 0);
            TH : in std_logic;
		    --activo : out STD_LOGIC;
            posicionC : out STD_Logic;
            posicionF : out STD_LOGIC
--				boton : in std_logic);
				);
end servomotor;

architecture behavioral of servomotor is
	component divisor is 
		generic (N : integer := 24);
		Port ( clk : in STD_LOGIC;
				 div_clk : out STD_LOGIC);
	end component;

    component pwm is
        port (reloj : in STD_LOGIC;
                D : in STD_LOGIC_VECTOR (15 downto 0);
                S : out STD_LOGIC);
    end component;
			
	signal reloj : STD_LOGIC;
	signal anchoF, anchoC : STD_LOGIC_VECTOR (15 downto 0) := X"1333"; 
	signal segundo : STD_LOGIC_VECTOR (19 downto 0) :="00000000001111101000"; -- 1 segundo
	signal q : STD_LOGIC;
	
	begin
	div : divisor generic map (3) port map (clk, reloj);
	Caliente : pwm port map (reloj, anchoC, posicionC);
    Frio : pwm port map (reloj, anchoF, posicionF);
	
	process (nt)
		variable valor : STD_LOGIC_VECTOR (15 downto 0) := X"1333";
		--variable turno : integer range 0 to 5;
		begin
			if rising_edge(clk) then
            case NT is
                when "00" =>
                    valor := X"1063";
                when "01" =>
                    valor := X"0D79";
                when "10" =>
                    valor := X"0A8F";
                when "11" =>
                    valor := X"07AF";
                when others => 
--                    valor := X"1063";
            end case;
            if ResetPos = '0' then 
                valor := X"1063";
            end if;
        
            if th = '0' then
                anchoF <= valor;
            else
                anchoC <= valor;
            end if;
			end if;
	end process;
end behavioral;
		
		
		
		