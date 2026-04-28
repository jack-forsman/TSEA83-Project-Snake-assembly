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
    b"00001010", -- LOAD
    b"00001011", -- JUMP
    b"00001100", -- STORE
    b"00000000",
    b"00000000",
    b"00000000",
    b"00000000",
    b"00000000",
    b"00000000",
    b"00000000",
    b"00000000",
    b"00000000",
    b"00000000",
    b"00000000",
    b"00000000",
    b"00000000"
    );

signal k1_mem : k1_mem_t := k1_mem_c;

begin  -- Behavioral
  K1_data <= k1_mem(to_integer(OP));

end Behavioral;
