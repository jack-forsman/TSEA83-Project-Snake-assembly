library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity alu_comp is
	port (
		clk     : in std_logic;
		clear   : in std_logic;
        A       : in unsigned(15 downto 0);
        B       : in unsigned(15 downto 0);
        op      : in unsigned(3 downto 0);
        AR_out  : out unsigned(15 downto 0);
        --HR_out : out unsigned(15 downto 0);
        Z_out : out std_logic
        );
end alu_comp;


-- architecture
architecture Behavioral of alu_comp is
	
	signal R : unsigned(31 downto 0);
    signal Zc, Nc, Cc, Vc : std_logic;
    signal Z, N, C, V : std_logic;

begin
        
    process(A, B, op)
    begin
      R <= (others => '0');
        case op is
            when "0000" => R <= (others => '0'); -- others => 0 eller null?
            when "0011" => R(31 downto 0) <= (others => '0'); -- 0
            when "0100" => R(16 downto 0) <= ('0'&A) + ('0'&B); -- add
            when "0101" => R(16 downto 0) <= ('0'&A) - ('0'&B); -- sub
            when "0110" => R(16 downto 0) <= ('0'&A) and ('0'&B); -- and
            when "0111" => R(16 downto 0) <= ('0'&A) or ('0'&B); -- or
            when "1000" => R <= A * B; -- unsigned mul
            when "1001" => R <= unsigned(signed(A) * signed(B)); -- signed muls
            when "1010" => R <= (A rem B) & (A/B); -- unsigned div
            when "1011" => R(31 downto 16) <= unsigned(signed(A) rem signed(B));    
                           R(15 downto 0) <= unsigned(signed(A) / signed(B));
                           -- signed divs
            when others => null;
        end case;
    end process;

    Zc <= '1' when R(31 downto 0)=0 and ((op = "1000") or (op = "1001")) else
          '1' when R(15 downto 0)=0 and ((op /= "1000") or (op /= "1001")) else
          '0';

    Nc <= R(31) when ((op="1000") or (op="1001")) else
          R(15);

    Cc <= R(31) when ((op="1000") or (op="1001")) else
          R(16);

    Vc <= (not A(15) and not B(15) and R(15)) or (A(15) and B(15) and not R(15)) when (op="0100") else
          (not A(15) and B(15) and R(15)) or (A(15) and not B(15) and not R(15)) when (op="0101") else
          '0';

    process(clk)
    begin
        if rising_edge(clk) then
            if (clear='1') then
                Z <= '0'; N <= '0'; C <= '0'; V <= '0';
            else
              case op is
                    when "0000" => null;
                    when "0100" => Z<=Zc; N<=Nc; C<=Cc; V<=Vc; -- add
                    when "0101" => Z<=Zc; N<=Nc; C<=Cc; V<=Vc; -- sub
                    when others => null;
                end case;
            end if;
        end if;
    end process;
    
    AR_out <= R(15 downto 0);
    Z_out <= Z;

end Behavioral;

