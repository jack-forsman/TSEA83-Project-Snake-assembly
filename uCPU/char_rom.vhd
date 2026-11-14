--------------------------------------------------------------------------------
-- CHAR_ROM
-- Version 2.0: 2023-01-12, Petter Kallstrom. ROM part of VGA_MOTOR.
-- Description:
-- * This is just a single-port ROM, that contains the images of all characters
-- Version 3.0: 2023-09-29, Anders Nilsson. 12-bit ROM.
-- Edited by G52 2026

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type


-- entity
entity char_rom is
	port (
		clk      : in std_logic;
		addr     : in unsigned(10 downto 0);
		data     : out std_logic_vector(11 downto 0));
end char_rom;


-- architecture
architecture Behavioral of char_rom is
	type rom_t is array (0 to 511) of std_logic_vector(11 downto 0);
	signal rom_data : rom_t;

begin

	-- Read from the ROM:
	process(clk)
	begin
		if rising_edge(clk) then
			data <= rom_data(to_integer(addr));
		end if;
	end process;
	
	rom_data <= (
          x"0F0",x"0F0",x"0F0",x"0F0",x"0D0",x"0D0",x"0D0",x"0D0",  -- Background
          x"0F0",x"0F0",x"0F0",x"0F0",x"0D0",x"0D0",x"0D0",x"0D0",
          x"0F0",x"0F0",x"0F0",x"0F0",x"0D0",x"0D0",x"0D0",x"0D0",
          x"0F0",x"0F0",x"0F0",x"0F0",x"0D0",x"0D0",x"0D0",x"0D0",
          x"0D0",x"0D0",x"0D0",x"0D0",x"0F0",x"0F0",x"0F0",x"0F0",
          x"0D0",x"0D0",x"0D0",x"0D0",x"0F0",x"0F0",x"0F0",x"0F0",
          x"0D0",x"0D0",x"0D0",x"0D0",x"0F0",x"0F0",x"0F0",x"0F0",
          x"0D0",x"0D0",x"0D0",x"0D0",x"0F0",x"0F0",x"0F0",x"0F0",

		
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F", -- Snake HEAD
          x"00F",x"00F",x"00F",x"00F",x"00F",x"FFF",x"FFF",x"00F", -- behövs 4
          x"00F",x"00F",x"00F",x"00F",x"00F",x"FFF",x"000",x"00F", -- olika
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"FFF",x"000",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"FFF",x"FFF",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
		
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F", -- Snake BODY
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",

          x"0F0",x"F00",x"0F0",x"033",x"033",x"033",x"F00",x"0B0", -- Apple
          x"F00",x"F00",x"F00",x"033",x"033",x"F00",x"F00",x"F00",
          x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",
          x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",
          x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",
          x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",
          x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",
          x"0B0",x"F00",x"F00",x"F00",x"F00",x"F00",x"F00",x"0F0",

          x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0", -- Edge
          x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",
          x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",
          x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",
          x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",
          x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",
          x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",
          x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",x"0B0",
          
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F", -- Snake HEAD
          x"00F",x"FFF",x"000",x"00F",x"00F",x"000",x"FFF",x"00F", -- UP
          x"00F",x"FFF",x"FFF",x"00F",x"00F",x"FFF",x"FFF",x"00F", -- 05
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",

          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F", -- Snake HEAD
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F", -- DOWN
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F", -- 06
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"FFF",x"FFF",x"00F",x"00F",x"FFF",x"FFF",x"00F",
          x"00F",x"FFF",x"000",x"00F",x"00F",x"000",x"FFF",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",

          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F", -- Snake HEAD
          x"00F",x"FFF",x"FFF",x"00F",x"00F",x"00F",x"00F",x"00F", -- LEFT
          x"00F",x"000",x"FFF",x"00F",x"00F",x"00F",x"00F",x"00F", -- 07
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"000",x"FFF",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"FFF",x"FFF",x"00F",x"00F",x"00F",x"00F",x"00F",
          x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F",x"00F"
	);
	
end Behavioral;

