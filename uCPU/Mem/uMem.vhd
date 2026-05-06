library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- uMem interface
entity uMem is
  port (
    uAddr : in unsigned(7 downto 0);
    uData : out unsigned(25 downto 0));
end uMem;

architecture Behavioral of uMem is

-- micro Memory (26 bitar, 25 downto 0)
type u_mem_t is array (0 to 32) of unsigned(25 downto 0); -- extend as needed
                                                          -- (max 256 so far)
constant u_mem_c : u_mem_t :=
  --0000_0000_0000_0_0_0000_00000000
  --ALU___TB___FB__S_PC_SEQ_uAddr
  (
    -- Hämtfas
    b"0000_0011_1101_0_0_0000_00000000", -- ASR:=PC 00 uPC++
    b"0000_0010_0001_0_1_0000_00000000", -- IR:=PM, PC:=PC+1
    b"0000_0000_0000_0_0_0010_00000000", -- uPC:= K2
    
    -- Adresseringsmoder
    b"0000_0001_1101_0_0_0001_00000000", -- ASR:= IR, uPC:= K1
                                         -- (Direktadressering) 03
    
    b"0000_0011_1101_0_1_0001_00000000", -- ASR:= PC, PC:= PC+1, uPC:= K1
                                         -- (Immediate) 04
    
    b"0000_0001_1101_0_0_0000_00000000", -- ASR:= IR (Indirekt adressering) 05
    b"0000_0010_1101_0_0_0001_00000000", -- ASR:= PM, uPC:= K1 (indirekt)
    
    b"0000_0001_0101_0_0_0000_00000000", -- AR:= IR (Indexerad adressering) 07
    b"0000_0000_0000_0_0_0000_00000000", -- AR:= GRx + AR (vilken GRx? gör det skillnad?
    b"0000_0000_0000_0_0_0000_00000000", -- ASR:= AR, uPC:= K1

    -- Instruktioner
    b"0000_0010_0111_0_0_0011_00000000", -- GRx:= PM(A) (LOAD) 10                              
    b"0000_0010_0011_0_0_0011_00000000", -- PC := PM(A) (JUMP) 11
    b"0000_0111_0010_0_0_0011_00000000", -- PM(A) := GRx (STORE) 12

    b"0011_0000_0000_0_0_0000_00000000", -- AR := 0 (ADD) 13
    b"0100_0111_0000_0_0_0000_00000000", -- AR := 0 + GRx
    b"0100_0010_0000_0_0_0000_00000000", -- AR := AR + PM(A)
    b"0000_1000_0111_0_0_0011_00000000", -- GRx := AR

    b"0011_0000_0000_0_0_0000_00000000", -- AR := 0 (SUB) 14
    b"0100_0111_0000_0_0_0000_00000000", -- AR := 0 + GRx
    b"0101_0010_0000_0_0_0000_00000000", -- AR := AR - PM(A)
    b"0000_1000_0111_0_0_0000_00000000", -- GRx := AR

    b"0011_0000_0000_0_0_0000_00000000", -- AR := 0 (AND) 15
    b"0100_0111_0000_0_0_0000_00000000", -- AR := GRx
    b"0110_0010_0000_0_0_0000_00000000", -- AR := AR & PM(A)
    b"0000_1000_0111_0_0_0000_00000000", -- GRx := AR

    b"0011_0000_0000_0_0_0000_00000000", -- AR := 0 (OR) 16
    b"0100_0111_0000_0_0_0000_00000000", -- AR := 0 + GRx
    b"0111_0010_0000_0_0_0000_00000000", -- AR := AR | PM(A)
    b"0000_1000_0111_0_0_0000_00000000", -- GRx := AR

    b"0011_0000_0000_0_0_0000_00000000", -- AR := 0 (BRA ADR) 17
    b"0100_0011_0000_0_0_0000_00000000", -- AR := PC
    b"0111_0001_0000_0_0_0000_00000000", -- AR := AR + IR
    b"0000_1000_0011_0_0_0000_00000000" -- GRx := AR
  );

 signal u_mem : u_mem_t := u_mem_c;

begin  -- Behavioral
  uData <= u_mem(to_integer(uAddr));

end Behavioral;
