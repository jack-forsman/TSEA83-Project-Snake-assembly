library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- K1 interface
entity K1Mem is
  port (
    OP : in unsigned(4 downto 0);
    K1_data : out unsigned(7 downto 0));
end K1Mem;

architecture Behavioral of K1Mem is

-- K1 Memory - 7 bits to fit any uMem adress
type k1_mem_t is array (0 to 15) of unsigned(7 downto 0); -- extend as needed
                                                          -- max 32 instrs.
constant k1_mem_c : k1_mem_t :=
  (
    b"00001010", -- LOAD 00
    b"00001011", -- JUMP 01
    b"00001100", -- STORE 02
    b"00001101", -- ADD 03
    b"00010001", -- SUB 04
    b"00010101", -- AND 05 
    b"00011001", -- OR 06
    b"00011101", -- BRA ADR 07
    b"00100001", -- BNE ADR 08
    b"00100011", -- BEQ ADR 09
    b"00100101", -- CMP 10
    b"00101000", -- JSR 11
    b"00101010", -- RET 12
    b"00000000",
    b"00000000",
    b"00000000"
    );

signal k1_mem : k1_mem_t := k1_mem_c;

begin  -- Behavioral
  K1_data <= k1_mem(to_integer(OP));

end Behavioral;
