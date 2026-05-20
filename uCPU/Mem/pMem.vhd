library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- pMem interface (LUT)
entity pMem is
  port(
    pAddr : in unsigned(9 downto 0);
    we : in std_logic; -- write enable
    clk : in std_logic;
    pData_i : in unsigned(23 downto 0);
    pData_o : out unsigned(23 downto 0));
end pMem;

architecture Behavioral of pMem is

-- program Memory
type p_mem_t is array (0 to 1023) of unsigned(23 downto 0);
constant p_mem_c : p_mem_t :=
  (
    x"004000", -- Load GR0 04
    x"000004", -- 04
    x"184000", -- ADD PM(3) + GR0 - 0001 1000 1000 0000 0000 0000
   -- x"204000", -- SUB PM(3) - GR0 - 0010 0000 1000 0000 0000 0000
    --x"284000", -- AND PM(3) - GR0 - 0010 1000 1000 0000 0000 0000
    --x"304000", -- OR PM(3) - GR0 - 0011 0000 1000 0000 0000 0000
    x"00FFFB", -- -5
   -- x"004000", --Load GR0 01
   -- x"000001", -- 01
  --  x"074000", -- LOAD GR7 AF
  --  x"0000AF", -- AF
  --  x"000000", -- LOAD GR0 PM(0) 
  --  x"120007", -- STORE, PM(7) := GR2(0)
  --  x"084000", -- JUMP PM(next adr)
  --  x"00000A", -- A
  --  x"084000", -- JUMP PM(next adr)
  --  x"00000F", -- F 
  --  x"38400D", -- BRA -3 (D 2 komplement)
   --   x"403FFB", -- BNE -5
    x"500001", -- CMP 
    x"483FFB", -- BEQ -3
    x"580002", -- JSR + 2 (+ 3 totalt?)
    x"084000", -- JMP next adr
    x"000000", -- 0
    x"004000", -- load GR0 next adr
    x"000008", -- 8
    x"600000", -- RET (borde hoppa till JMP till 0, loop)
    x"000000",
    x"004000",
    x"000010",
    others => (others => '0')
    );

  signal p_mem : p_mem_t := p_mem_c;


begin -- pMem
  -- Synkron skrivning
  process(clk)
  begin  
    if rising_edge(clk) then
      if we = '1' then
         p_mem(to_integer(pAddr)) <= pData_i;
      end if;
    end if;
  end process;

-- kombinatorisk läsning
  pData_o <= p_mem(to_integer(pAddr));
  
end Behavioral;
