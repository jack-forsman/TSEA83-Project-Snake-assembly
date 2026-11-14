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
    -- SNAKE
    --VARIABLE locations (DM)
    -- x"52C" - Snake length
    -- x"52D" - temp index
    -- x"52E" - temp general
    -- x"52F" - cur HEAD type
    
    -- DELAY(tickrate?)
    x"024000", -- LOAD GR2 := FFFF
    x"00000C", -- C OUTER LOOP CONSTANT
    --x"000001", -- SIM
    x"014000", -- LOAD GR1 := FFFF
    x"00FFFF", -- FFFF INNER LOOP CONSTANT
    --x"000001, -- SIM
    -- INNER LOOP
    x"214000", -- SUB GR1 := GR1-1
    x"000001", -- 1
    x"480002", -- BEQ 2 (ny loop vid 0)
    x"084000", -- JMP NEXT (4)
    x"000004", -- 4
    -- OUTER LOOP
    x"224000", -- SUB GR2 := GR2-1
    x"000001", -- 1
    x"480002", -- BEQ 2 (sluta delay loop vid 0)
    x"084000", -- JMP NEXT (2)
    x"000002", -- 2
    
    -- CHECK_INPUT:
    x"001000", -- LOAD GR0 := KBD
    --x"004000", -- load gr0 := 3 SIM
    --x"000003", -- 3 SIM
    -- RIGHT (D)
    x"504000", -- CMP GR0, 03 (HÖGER)
    x"000003", -- 03
    x"48000A", -- BEQ A (hoppa till UPDATE RIGHT)
    -- UP (W)
    x"504000", -- CMP GR0, 01 (UPP)
    x"000001", -- 01
    x"48000E", -- BEQ 14 (hoppa till UPDATE UP)
    -- DOWN (S)
    x"504000", -- CMP GR0, 02 (NER)
    x"000002", -- 02
    x"480012", -- BEQ 18 (hoppa till UPDATE NER)
    -- LEFT (A)
    x"504000", -- CMP GR0, 04 (VÄNSTER)
    x"000004", -- 04
    x"480016", -- BEQ 22 (hoppa till UPDATE NER)
    x"383FF2", -- BRA -14
    
    -- UPDATE HEAD RIGHT
    x"014000", -- LOAD GR1 RIGHT HEAD TYPE
    x"000001", -- 01
    x"11052F", -- STORE cur head := GR1
    x"000400", -- LOAD GR0 HEAD TILE 
    x"184000", -- ADD PM(next) + GR0
    x"000001", -- 1
    x"380014", -- BRA 20 (hoppa till COLL

    -- UPDATE HEAD UP
    x"014000", -- LOAD GR1 UP HEAD TYPE
    x"000005", -- 05
    x"11052F", -- STORE cur head := GR1
    x"000400", -- LOAD GR0 HEAD TILE
    x"204000", -- SUB GR0 - PM(next)
    x"000014", -- d20 = x14
    x"38000D", -- BRA 13 (hopp till COLL
    
    -- UPDATE HEAD DOWN
    x"014000", -- LOAD GR1 DOWN HEAD TYPE
    x"000006", -- 06
    x"11052F", -- STORE cur head := GR1
    x"000400", -- LOAD GR0 HEAD TILE
    x"184000", -- ADD GR0 + PM(next)
    x"000014", -- d20 = x14
    x"380006", -- BRA 6 ( hopp till COLL

    -- UPDATE HEAD LEFT
    x"014000", -- LOAD GR1 LEFT HEAD TYPE
    x"000007", -- 07
    x"11052F", -- STORE cur head := GR1
    x"000400", -- LOAD GR0 HEAD TILE   
    x"204000", -- SUB GR0 - PM(next)
    x"000001", -- 1
    
    -- CHECK COLLISIONS
    x"10052E", -- STORE TEMP GENERAL := GR0
    x"03052E", -- LOAD GR3 := FUTURE TILE
    x"01C800", -- LOAD GR1 := VR(BASE+GR3)
    -- WALL
    x"514000", -- CMP GR1 04
    x"000004", -- 04
    x"400001", -- BNE 1
    x"680000", -- HALT
    -- APPLE
    x"514000", -- CMP GR1 03
    x"000003", -- 03
    x"400002", -- BNE 2
    x"064000", -- LOAD GR6 1 = TRUE
    x"000001", -- 1
    -- SELF
    x"514000", -- CMP GR1 02
    x"000002", -- 02
    x"400001", -- BNE 1
    x"680000", -- HALT
    
    
    -- SAVE TAIL
    x"03052C", -- LOAD GR3 SNAKE LENGTH
    x"234000", -- GR3 - 1
    x"000001", -- 1
    x"07C400", -- LOAD GR7 := DM(base+GR3) DM(i-1)
    x"17052E", -- STORE TEMP GENERAL := GR7 TAIL NR
    
    -- UPDATE BODY
    x"01052C", -- LOAD GR1 SNAKE LENGTH
    x"214000", -- GR1 -1 (SNAKE LENGTH - 1)
    x"000001", -- 1
    x"11052D", -- STORE temp index := GR1
    -- LOOP (i = i-1 fram till huvudet)
    x"03052D", -- LOAD GR3 := I
    x"234000", -- SUB GR3 -1
    x"000001", -- 1
    x"02C400", -- LOAD GR2 := DM(base+GR3) DM(i-1)
    x"1B4000", -- ADD GR3 + 1
    x"000001", -- 1
    x"12C400", -- STORE DM(I) := GR2 (DM(i-1)
    -- END LOOP?
    x"214000", -- GR1 -1
    x"000001", -- 1
    x"514000", -- CMP GR1, 00
    x"000000", -- 00
    x"480002", -- BEQ 2 (hoppa till huvud)
    x"11052D", -- store TEMP index := GR1
    x"383FF2", -- BRA -14 (hoppa till LOOP
 
    -- DRAW BODY
    x"01052C", -- LOAD GR1 SNAKE LENGTH
    x"214000", -- GR1 - 1 (SNAKE LENGTH - 1)
    x"000001", -- 1
    x"11052D", -- STORE temp index := GR1
    -- LOOP
    x"03052D", -- LOAD GR3 := I
    x"03C400", -- LOAD GR3 := DM(base+GR3) DM(i)
    x"044000", -- LOAD GR4 02
    x"000002", -- 02
    x"14C800", -- STORE VR(0+GR3) := GR4 BODY
    -- END LOOP?
    x"214000", -- GR1 - 1
    x"000001", -- 1
    x"514000", -- CMP GR1, 00
    x"000000", -- 0
    x"480002", -- BEQ 2 (HOPPA TILL RETURN)
    x"11052D", -- store TEMP index := GR1
    x"383FF4", -- BRA -12 (hoppa till LOOP)
    
    -- DRAW HEAD
    x"100400", -- STORE DM(0) := GR0
    x"030400", -- LOAD GR3 HEAD TILE
    x"04052F", -- LOAD GR4 cur HEAD
    x"14C800", -- STORE VR(0+GR3) := GR4 HEAD
    
    
    -- REMOVE TAIL
    x"044000", -- LOAD GR4 00
    x"000000", -- 00
    x"03052E", -- LOAD GR3 := TEMP GENERAL
    x"14C800", -- STORE VR(0+GR3) := GR4 BACKGROUND

    -- CHECK APPLE
    x"564000", -- CMP GR6, 01
    x"000001", -- 1
    x"480002", -- BEQ 2

    -- RETURN MAIN
    x"084000", -- jmp
    x"000000", -- 0
    
    -- ADD TAIL
    x"03052E", -- LOAD GR2 := TEMP GENERAL
    x"03052C", -- LOAD GR3 := SNAKE LENGTH
    x"12C400", -- STORE DM(BASE+GR3) := GR2
    x"1B4000", -- ADD GR3 + 1
    x"000001", -- 1
    x"13052C", -- STORE SNAKE LENGTH := GR3
    x"064000", -- LOAD GR6 0 FALSE
    x"000000", -- 0

    -- RANDOM APPLE
    x"031001", -- LOAD TIMER GR3
    x"01C800", -- LOAD GR1 := VR(BASE+GR3)
    -- CHECK OK
    x"514000", -- CMP GR1 04
    x"000004", -- 04 - EDGE
    x"483FFB", -- BEQ - 5
    x"514000", -- CMP GR1 01
    x"000001", -- 01 - HEAD 1
    x"483FF8", -- BEQ - 8
    x"514000", -- CMP GR1 02
    x"000002", -- 02 - BODY
    x"483FF5", -- BEQ - 11
    x"514000", -- CMP GR1 05
    x"000005", -- 05
    x"483FF2", -- BEQ - 14
    x"514000", -- CMP GR1 06
    x"000006", -- 06
    x"483FEF", -- BEQ - 17
    x"514000", -- CMP GR1 07
    x"000007", -- 07
    x"483FEC", -- BEQ - 20
    
    -- ADD APPLE
    x"044000", -- LOAD GR4 03
    x"000003", -- 03
    x"14c800", -- STORE VR(0+GR3) := GR4 APPLE
    -- RETURN MAIN
    x"084000", -- jmp main
    x"000000", -- 0
    
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"000000",
    x"680000", -- HALT (keeps from looping weirdly)
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
