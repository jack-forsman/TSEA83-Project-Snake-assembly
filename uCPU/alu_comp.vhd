library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity alu_comp is
	port (
		clk     : in std_logic;
		clear   : in std_logic;
        A       : in unsigned(3 downto 0);
        B       : in unsigned(3 downto 0);
        op      : in unsigned(3 downto 0);
		AR_out  : out unsigned(7 downto 0)
        );
end alu_comp;


-- architecture
architecture Behavioral of alu_comp is
	
	signal R : unsigned(7 downto 0);

begin
        
    process(clk)
    begin
        if rising_edge(clk) then
            R <= (others => '0');
            case op is
                when "0000" => R <= (others => '0');
                when "0011" => R <= (others => '0');
                when "0100" => R(4 downto 0) <= ('0'&A) + ('0'&B);
                when "0110" => R(4 downto 0) <= ('0'&A) - ('0'&B);
                when "0111" => R(4 downto 0) <= ('0'&A) + ('0'&B);
                when others => null;
            end case;
        end if;
    end process;

    AR_out <= R;

end Behavioral;

