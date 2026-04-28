library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- pMem interface
entity pMem is
  port(
    pAddr : in unsigned(15 downto 0);
    pData : out unsigned(23 downto 0));
end pMem;

architecture Behavioral of pMem is

-- program Memory
type p_mem_t is array (0 to 15) of unsigned(23 downto 0);
constant p_mem_c : p_mem_t :=
  (x"004000", --Load GR0 AA
   x"0000AA", -- AA
   x"074000", -- LOAD GR7 AF
   x"0000AF", -- AF
   x"000000", -- LOAD GR0 PM(0) 
   x"000000", -- 0
   x"084000", -- JUMP PM(0)
   x"000000", -- 0
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000",
   x"000000");

  signal p_mem : p_mem_t := p_mem_c;


begin  -- pMem
  pData <= p_mem(to_integer(pAddr));
  
end Behavioral;
