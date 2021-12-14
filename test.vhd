library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity test is
Port( clk : in std_logic;
		AN : out std_logic_vector(3 downto 0);
		displays : out std_logic_vector(6 downto 0);
		data : inout std_logic;
		boton : in std_logic;
		breset : in std_logic;
		fin : out std_logic
		);
end test;

architecture behavioral of test is

component libreria_dht11_reva is
	PORT( CLK 	 : IN  	STD_LOGIC;							-- Reloj del FPGA.
	   RESET  : IN  	STD_LOGIC;							-- Resetea el proceso de adquisiciï¿½n, el reset es asï¿½ncrono y activo en alto.
	   ENABLE : IN 	STD_LOGIC;							-- Habilitador, inicia el proceso de adquisiciï¿½n cuando se pone a '1'.
	   DATA 	 : INOUT STD_LOGIC;							-- Puerto bidireccional de datos.
	   ERROR  : OUT 	STD_LOGIC;							-- Bit que indica si hubo algï¿½n error al verificar el Checksum.
	   RH 	 : OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- Valor de la humedad relativa.
	   TEMP 	 : OUT 	STD_LOGIC_VECTOR(7 DOWNTO 0); -- Valor de la temperatura.
	   FIN 	 : OUT 	STD_LOGIC							-- Bit que indica fin de adquisiciï¿½n.
	 );
end component;

component muxdec4disp is
Port ( clk : in std_logic;
         D0 : in std_logic_vector (3 downto 0);
         D1 : in std_logic_vector (3 downto 0);
         D2 : in std_logic_vector (3 downto 0);
         D3 : in std_logic_vector (3 downto 0);
         A : out std_logic_vector (3 downto 0);
         L : out std_logic_vector (6 downto 0));
end component;

component divisor is
	Generic (N : integer := 24); --NUEVO
	Port (clk : in std_logic;
			div_clk : out std_logic);
end component;

signal disp1, disp2, disp3, disp4 : std_logic_vector(3 downto 0);
signal reset, enable, error, div_clk, termina : std_logic;
signal rh, temp : std_logic_vector(7 downto 0);
signal decenasT, decenasH : integer range 0 to 9;
signal temperatura, humedad : integer;

begin
	div : divisor generic map(18) port map(clk, div_clk);
	muxy : muxdec4disp port map(clk,disp1,disp2,disp3,disp4,AN,displays);
	sensor :  libreria_dht11_reva port map(clk,reset,div_clk,data,error,rh,temp,termina);
	
	prueba : process(data,temp,rh,disp1,disp2,disp3,disp4,enable,decenasT, decenasH)
	begin
		if rising_edge(div_clk) then
--			disp3 <="0000";
--			disp4 <="0000";
			reset <= not breset;
			enable <= not boton;
			fin <= not termina;
			temperatura <= to_integer(signed(temp));
			humedad <= to_integer(signed(rh));
			
			if(temperatura >= 10 and temperatura < 20)then
				disp1 <= "0001";
				decenasT <= 1;
			elsif(temperatura >= 20 and temperatura < 30) then
				disp1 <= "0010";
				decenasT <= 2;
			elsif(temperatura >= 30 and temperatura < 40) then
				disp1 <= "0011";
				decenasT <= 3;
			elsif(temperatura >= 40 and temperatura < 50) then
				disp1 <= "0100";
				decenasT <= 4;
			elsif(temperatura >= 50 and temperatura < 60) then
				disp1 <= "0101";
				decenasT <= 5;
			else
				disp1 <= "0000";
				decenasT <= 0;
			end if;

			if(humedad >= 10 and humedad < 20)then
				disp4 <= "0001";
				decenasT <= 1;
			elsif(humedad >= 20 and humedad < 30) then
				disp4 <= "0010";
				decenasT <= 2;
			elsif(humedad >= 30 and humedad < 40) then
				disp4 <= "0011";
				decenasT <= 3;
			elsif(humedad >= 40 and humedad < 50) then
				disp4 <= "0100";
				decenasT <= 4;
			elsif(humedad >= 50 and humedad < 60) then
				disp4 <= "0101";
				decenasT <= 5;
			elsif(humedad >= 60 and humedad < 70) then
				disp4 <= "0110";
				decenasT <= 6;
			elsif(humedad >= 70 and humedad < 80) then
				disp4 <= "0111";
				decenasT <= 7;
			elsif(humedad >= 80 and humedad < 90) then
				disp4 <= "1000";
				decenasT <= 8;
			elsif(humedad >= 90 and humedad < 100) then
				disp4 <= "1001";
				decenasT <= 9;
			else
				disp4 <= "0000";
				decenasT <= 0;
			end if;
			
			if temperatura < 22 or temperatura > 26 then 
				disp3 <= "1110";
			elsif humedad < 40 or humedad > 60 then
				disp3 <= "1110";
			else
				disp3 <= "1010";
			end if;
			
		end if;
	end process;
		
	segundoDigitoTemp : process(decenasT, disp2)
	begin
		if rising_edge(div_clk) then
			if(temperatura = (decenasT*10) + 1) then
				disp2 <= "0001";
			elsif(temperatura = (decenasT*10) + 2) then
				disp2 <= "0010";
			elsif(temperatura = (decenasT*10) + 3) then
				disp2 <= "0011";
			elsif(temperatura = (decenasT*10) + 4) then
				disp2 <= "0100";
			elsif(temperatura = (decenasT*10) + 5) then
				disp2 <= "0101";
			elsif(temperatura = (decenasT*10) + 6) then
				disp2 <= "0110";
			elsif(temperatura = (decenasT*10) + 7) then
				disp2 <= "0111";
			elsif(temperatura = (decenasT*10) + 8) then
				disp2 <= "1000";
			elsif(temperatura = (decenasT*10) + 9) then
				disp2 <= "1001";
			else
				disp2 <= "0000";
			end if;
		end if;
	end process;
	
--	segundoDigitoHumedad : process(decenasH, disp4)
--	begin
--		if rising_edge(div_clk) then
--			if(temperatura = (decenasH*10) + 1) then
--				disp4 <= "0001";
--			elsif(temperatura = (decenasH*10) + 2) then
--				disp4 <= "0010";
--			elsif(temperatura = (decenasH*10) + 3) then
--				disp4 <= "0011";
--			elsif(temperatura = (decenasH*10) + 4) then
--				disp4 <= "0100";
--			elsif(temperatura = (decenasH*10) + 5) then
--				disp4 <= "0101";
--			elsif(temperatura = (decenasH*10) + 6) then
--				disp4 <= "0110";
--			elsif(temperatura = (decenasH*10) + 7) then
--				disp4 <= "0111";
--			elsif(temperatura = (decenasH*10) + 8) then
--				disp4 <= "1000";
--			elsif(temperatura = (decenasH*10) + 9) then
--				disp4 <= "1001";
--			else
--				disp4 <= "0000";
--			end if;
--		end if;
--	end process;

end Behavioral;