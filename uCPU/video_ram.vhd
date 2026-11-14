--------------------------------------------------------------------------------
-- PICT MEM
-- Anders Nilsson
-- 16-feb-2016
-- Version 1.1
-- Version 2.0: 2023-09-29. Anders Nilsson. Separate processes for ports in VideoRAM (block RAM).
-- * Separate processes is necessary when buiding dual port block RAMs (Vivado design user guide)
-- * https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Simple-Dual-Port-Block-RAM-with-Single-Clock-VHDL
-- * The design guide also states the use of shared variables when accessing the same
-- * "signal" from several processes, such as the case with dual port block RAMs.
-- * Shared variables should further be protected:
-- * https://fpgatutorial.com/vhdl-shared-variable-protected-type/#protected-type-example
-- * https://www.linkedin.com/pulse/vhdl-shared-variables-protected-types-memory-modeling-jim-lewis
-- Edited by G52 2026

-- library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;            -- basic IEEE library
use IEEE.NUMERIC_STD.ALL;               -- IEEE library for the unsigned type


-- entity
entity VIDEO_RAM is
	port (
		clk       : in std_logic;
		-- port 1
		we1       : in std_logic;
		data_in1  : in std_logic_vector(7 downto 0);
		data_out1 : out std_logic_vector(7 downto 0);
		addr1     : in unsigned(10 downto 0);
		-- port 2
		we2       : in std_logic;
		data_in2  : in std_logic_vector(7 downto 0);
		data_out2 : out std_logic_vector(7 downto 0);
		addr2     : in unsigned(10 downto 0));
end VIDEO_RAM;


-- architecture
architecture Behavioral of VIDEO_RAM is

	-- video RAM type
	type ram_t is array (0 to 2047) of std_logic_vector(7 downto 0);
	-- initiate video RAM to one cursor ("1F") followed by spaces ("00")
	--signal VideoRAM : ram_t := (0 => x"1F", others => (others => '0'));
        shared variable VideoRAM : ram_t := (
        -- Snake
        125 => x"02", 126 => x"02", 127 => x"01",
        -- Apple
        130 => x"03",
        -- Walls
        0 => x"04", 1 => x"04", 2 => x"04", 3 => x"04", 4 => x"04", 5 => x"04",
        6 => x"04", 7 => x"04", 8 => x"04", 9 => x"04", 10 => x"04", 11 => x"04",
        12 => x"04", 13 => x"04", 14 => x"04", 15 => x"04", 16 => x"04", 17 => x"04",
        18 => x"04", 19 => x"04", 20 => x"04", 40 => x"04", 60 => x"04", 80 => x"04",
        100 => x"04", 120 => x"04", 140 => x"04", 160 => x"04", 180 => x"04", 200 => x"04",
        220 => x"04", 240 => x"04", 260 => x"04", 280 => x"04", 281 => x"04", 282 => x"04",
        283 => x"04", 284 => x"04", 285 => x"04", 286 => x"04", 287 => x"04", 288 => x"04",
        289 => x"04", 290 => x"04", 291 => x"04", 292 => x"04", 293 => x"04", 294 => x"04",
        295 => x"04", 296 => x"04", 297 => x"04", 298 => x"04", 299 => x"04", 39 => x"04",
        59 => x"04", 79 => x"04", 99 => x"04", 119 => x"04", 139 => x"04", 159 => x"04",
        179 => x"04", 199 => x"04", 219 => x"04", 239 => x"04", 259 => x"04", 279 => x"04",
          others => (others => '0'));
        -- ram_t := (plats för objekt => x"nummer för vilken tiletyp"
begin

  process(clk)
  begin
    if rising_edge(clk) then
      data_out1 <= VideoRAM(to_integer(addr1));
      if (we1 = '1') then
        VideoRAM(to_integer(addr1)) := data_in1;
      end if;
    end if;
  end process;
	
  process(clk)
  begin
    if rising_edge(clk) then
      data_out2 <= VideoRAM(to_integer(addr2));
      if (we2 = '1') then
        VideoRAM(to_integer(addr2)) := data_in2;
      end if;
    end if;
  end process;

end Behavioral;
