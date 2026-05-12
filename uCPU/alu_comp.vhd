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
	signal Y : unsigned(7 downto 0);
    signal Zc, Nc, Cc, Vc : std_logic;
    signal Z, N, C, V : std_logic;

begin
        
    process(A, B, op)
    begin
        R <= (others => '0');
        case op is
            when "0100" => R(4 downto 0) <= ('0'&A) + ('0'&B); -- add
            when "0101" => R(4 downto 0) <= ('0'&A) - ('0'&B); -- sub
            -- when "0110" => R(4 downto 0) <= ('0'&A) and ('0'&B);
            -- when "0111" => R(4 downto 0) <= ('0'&A) or ('0'&B);
            -- when "1000" => R(4 downto 0) <= ('0'&A) + ('0'&B);
            when others => null;
        end case;
    end process;

    -- process(clk, clear)
    -- begin
    --    if (clear='1') then
    --        R <= (others => '0');
    --    elsif rising_edge(clk) then
    --        R <= Y;
    --    end if;
    -- end process;

    Zc <= '1' when R(7 downto 0)=0 else
          '0';

    Nc <= R(7);

    Cc <= R(7);

    Vc <= (not A(3) and not B(3) and R(3)) or (A(3) and B(3) and not R(3)) when (op="0100") else
          (not A(3) and B(3) and R(3)) or (A(3) and not B(3) and not R(3)) when (op="0100") else
          '0';

    process(clk)
    begin
        if rising_edge(clk) then
            if (clear='1') then
                Z <= '0'; N <= '0'; C <= '0'; V <= '0';
            else
                case op is
                    when "0100" => Z<=Zc; N<=Nc; C<=Cc; V<=Vc; -- add
                    when "0101" => Z<=Zc; N<=Nc; C<=Cc; V<=Vc; -- sub
                    when others => null;
                end case;
            end if;
        end if;
    end process;
    
    process(clk, clear)
    begin
       if (clear='1') then
           AR_out <= (others => '0');
       elsif rising_edge(clk) then
           AR_out <= R;
       end if;
    end process;
    --AR_out <= R;

end Behavioral;

