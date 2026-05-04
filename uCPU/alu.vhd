entity alu is
	port (
		clk     : in std_logic;
		clear   : in std_logic;
        A       : in unsigned(3 downto 0);
        B       : in unsigned(3 downto 0);
        op      : in unsigned(3 downto 0);
		AR_out  : out unsigned(7 downto 0);
        );
end alu;


-- architecture
architecture Behavioral of alu is
	
	signal AR : unsigned(7 downto 0);

BEGIN
	
process(A, B, op)
begin
    R <= (others => '0');
    case op is
        when "000" => R <= (others => '0');
        when others => null;
    end case
end process;

end Behavioral;

