library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- K2Mem interface
entity K2Mem is
  port (
    M : in unsigned(1 downto 0);
    K2_data : out unsigned(7 downto 0));
end K2Mem;

architecture Behavioral of K2Mem is

-- K2 Memory - 7 bits to fit any uMem adress
type k2_mem_t is array (0 to 3) of unsigned(7 downto 0);
  
constant k2_mem_c : k2_mem_t :=
  (
    b"00000011", -- 03 Direktadressering (00)
    b"00000100", -- 04 Immediate (01)
    b"00000101", -- 05 Indirekt adressering (02)
    b"00000111" -- 07 Indexerad adressering (03)
    );

signal k2_mem : k2_mem_t := k2_mem_c;

begin  -- Behavioral
  K2_data <= k2_mem(to_integer(M));

end Behavioral;
