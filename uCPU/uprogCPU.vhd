library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--CPU interface
entity uprogCPU is
  port(clk: in std_logic;
       btnC : in std_logic;     -- reset button (middle of the five), active high
       	Hsync    : out std_logic;                        -- horizontal sync
	Vsync    : out std_logic;                        -- vertical sync
	vgaRed   : out std_logic_vector(3 downto 0);     -- VGA red
	vgaGreen : out std_logic_vector(3 downto 0);     -- VGA green
	vgaBlue  : out std_logic_vector(3 downto 0)     -- VGA blue
	);
end entity;

architecture func of uprogCPU is

	signal rst : std_logic;       -- synchronous clear

	-- micro Memory component
	component uMem
                port(uAddr : in unsigned(7 downto 0);
			uData : out unsigned(25 downto 0));
	end component;

	-- program Memory component
	component pMem
                port(pAddr : in unsigned(15 downto 0);
                           we : in std_logic; -- write enable
                           clk : in std_logic;
                           pData_i : in unsigned(23 downto 0);
                           pData_o : out unsigned(23 downto 0)); 
	end component;

        -- K1 Memory component
        component K1Mem
		port(OP : in unsigned(4 downto 0);
			K1_Data : out unsigned(7 downto 0));
	end component;

        -- K2 Memory component
        component K2Mem
		port(M : in unsigned(1 downto 0);
			K2_Data : out unsigned(7 downto 0));
	end component;

        -- VGA motor component
        component vga_motor
		port (
			clk      : in std_logic;
			VR_data  : in std_logic_vector(7 downto 0);
			VR_addr  : out unsigned(10 downto 0); 
			clear    : in std_logic;
			vgaRed   : out std_logic_vector(3 downto 0);
			vgaGreen : out std_logic_vector(3 downto 0);
			vgaBlue  : out std_logic_vector(3 downto 0);
			Hsync    : out std_logic;
			Vsync    : out std_logic);
	end component;

        -- picture memory component
	component video_ram
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
	end component;

	-- picture memory component
	component alu_comp
		port (
			clk      	: in std_logic;
			clear    	: in std_logic;
			A 			: in unsigned(3 downto 0);
			B 			: in unsigned(3 downto 0);
			op 			: in unsigned(3 downto 0);
			AR_out  	: out unsigned(7 downto 0));
	end component;
            
	-- micro memory signals
	signal uM : unsigned(25 downto 0); -- micro Memory output
        alias ALU : unsigned(3 downto 0) is uM(25 downto 22); -- ALU operations                                         
	alias TB : unsigned(3 downto 0) is uM(21 downto 18); -- to Bus
	alias FB : unsigned(3 downto 0) is uM(17 downto 14); -- from Bus
        alias S : std_logic is uM(13); -- Needed?
	alias PCsig : std_logic is uM(12);  -- (0:PC=PC, 1:PC++)
        alias SEQ : unsigned(3 downto 0) is uM(11 downto 8); -- uPC operations
	alias uAddr : unsigned(7 downto 0) is uM(7 downto 0); -- microadress

	-- program memory signals
	signal PM : unsigned(23 downto 0); -- Program Memory output
        signal WE : std_logic; -- Program Memory Write Enable
        signal PMI : unsigned (23 downto 0); -- Program Memory input

        -- Instruction and adressmode memory signals
        signal K1 : unsigned(7 downto 0); -- K1 Memory output
        signal K2 : unsigned(7 downto 0); -- K2 Memory output

	-- local registers
	signal uPC : unsigned(7 downto 0); -- micro Program Counter
	signal PC : unsigned(15 downto 0); -- Program Counter
	signal IR : unsigned(23 downto 0); -- Instruction Register
	signal ASR : unsigned(15 downto 0); -- Address Register
    signal SP : unsigned(15 downto 0); -- Stack Register
    signal AR : unsigned(3 downto 0); -- Add Register

	-- General register signals
	signal GR0 : unsigned(15 downto 0); -- General register 0
	signal GR1 : unsigned(15 downto 0); -- General register 1
	signal GR2 : unsigned(15 downto 0); -- General register 2
	signal GR3 : unsigned(15 downto 0); -- General register 3
	signal GR4 : unsigned(15 downto 0); -- General register 4
	signal GR5 : unsigned(15 downto 0); -- General register 5
	signal GR6 : unsigned(15 downto 0); -- General register 6
	signal GR7 : unsigned(15 downto 0); -- General register 7
	alias GRM : unsigned(2 downto 0) is IR(18 downto 16); -- General register MUX selector

        -- intermediate signals between VIDEO_RAM and VGA_MOTOR
	signal data_out2_s : std_logic_vector(7 downto 0); -- data
	signal addr2_s     : unsigned(10 downto 0);        -- address

        -- Address decoding signals
        signal CS_DM : std_logic; -- Chip select datamemory
        
	-- local combinatorials
	signal DATA_BUS : unsigned(23 downto 0); -- Data Buss
        signal ADR_BUS : unsigned (13 downto 0); -- Address buss (behov?)

	-- ALU result
	signal AR_out : unsigned (7 downto 0);

begin
        -- RST : Reset button on BASYS3
	process(clk)
	begin
		if rising_edge(clk) then
			rst <= btnC; -- syncronize the reset signal
		end if;
	end process;

	-- mPC : micro Program Counter
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				uPC <= (others => '0');
                        else
                          case SEQ is
                            when "0000" =>
                              uPC <= uPC +1;
                            when "0001" =>
                              uPC <= K1;
                            when "0010" =>
                              uPC <= K2;
                            when "0011" =>
                              uPC <= (others => '0');
                            when "0101" =>
                              uPC <= uAddr;
                            when "1111" =>
                              --HALT
                            when others => -- sålänge uPC + 1
                              uPC <= uPC + 1;
                            end case;
			end if;
		end if;
	end process;

	-- PC : Program Counter
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				PC <= (others => '0');
			elsif (FB = "0011") then
				PC <= DATA_BUS(15 downto 0);
			elsif (PCsig = '1') then
				PC <= PC + 1;
			end if;
		end if;
	end process;
        
        -- PM : Program Memory Write Enable
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
                          WE <= '0';
                          PMI <= (others => '0');
			elsif (FB = "0010") then
                                WE <= '1';
                                PMI <= DATA_BUS;
			else
				WE <= '0';
			end if;
		end if;
	end process;

	-- IR : Instruction Register
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				IR <= (others => '0');
			elsif (FB = "0001") then
				IR <= DATA_BUS;
			end if;
		end if;
	end process;

	-- ASR : Address Register
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				ASR <= (others => '0');
			elsif (FB = "1101") then
				ASR <= DATA_BUS(15 downto 0);
			end if;
		end if;
	end process;

        -- SP : Stack Register
        process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				SP <= (others => '0');
			elsif (FB = "0100") then
				SP <= DATA_BUS(15 downto 0);
			end if;
		end if;
	end process;

		-- AR : Add Register
		process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				AR <= "0000";
			elsif (ALU /= "0000") then
				AR <= AR_out(3 downto 0);
			end if;
		end if;
	end process;


        -- GRM : general register mux process (separat fil möjligt/bra?
        -- array? slipper case when, istället to_integer(grm) kan spara
        -- slipper också 8 rader i TB
	process(clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
                          GR0 <= (others => '0');
                          GR1 <= (others => '0');
                          GR2 <= (others => '0');
                          GR3 <= (others => '0');
                          GR4 <= (others => '0');
                          GR5 <= (others => '0');
                          GR6 <= (others => '0');
                          GR7 <= (others => '0');
                        elsif (FB = "0111") then
                          case GRM is
                            when "000" =>
                              GR0 <= DATA_BUS(15 downto 0);
                            when "001" =>
                              GR1 <= DATA_BUS(15 downto 0);
                            when "010" =>
                              GR2 <= DATA_BUS(15 downto 0);
                            when "011" =>
                              GR3 <= DATA_BUS(15 downto 0);
                            when "100" =>
                              GR4 <= DATA_BUS(15 downto 0);
                            when "101" =>
                              GR5 <= DATA_BUS(15 downto 0);
                            when "110" =>
                              GR6 <= DATA_BUS(15 downto 0);
                            when "111" =>
                              GR7 <= DATA_BUS(15 downto 0);
                            when others =>
                              NULL;
                            end case;
                        end if;
		end if;
	end process;

	-- micro memory component connection
	U0 : uMem port map(uAddr=>uPC, uData=>uM);

	-- program memory component connection
	U1 : pMem port map(pAddr=>ASR, pData_i=>PMI, pData_o=>PM, clk=>clk, we=>WE);

	-- K1  memory component connection
	U2 : K1Mem port map(OP=>IR(23 downto 19), K1_data=>K1); -- OP=>IR 24 downto 20, K1_data=>K1? k1=op?
	
	-- K2 memory component connection
	U3 : K2Mem port map(M=>IR(15 downto 14), K2_data=>K2); -- M=>IR..., K2_data=>K2 kalla k2 för adrmod?

    -- VGA motor component connection
	U4 : vga_motor port map(clk=>clk, clear=>rst, VR_data=>data_out2_s, VR_addr=>addr2_s, vgaRed=>vgaRed, vgaGreen=>vgaGreen, vgaBlue=>vgaBlue, Hsync=>Hsync, Vsync=>Vsync);

	-- Picture memory component connection
	-- 1 kopplad till cpu , 2 kopplad till vga motor
	U5 : video_ram port map(clk=>clk, we1=>'0', data_in1=>"00000000", addr1=>"00000000000", we2=>'0', data_in2=>"00000000", data_out2=>data_out2_s, addr2=>addr2_s);

	-- alu connection
	U6 : alu_comp port map(AR_out=>AR_out, A=>AR, B=>DATA_BUS(3 downto 0), clk=>clk, clear=>rst, op=>ALU);

	-- VRAM/ROM comp connection behövs sen
	-- för att koppla signaler från den till vga_motor
	
	-- Adressavkodning
	-- dataminne, video_ram, io?
        
	-- data bus assignment (sign extension bra?, slippa 15downto0 & "0000...?)
	DATA_BUS <=  IR when (TB = "0001") else
		PM when (TB = "0010") else
		"00000000" & PC when (TB = "0011") else
                "00000000" & ASR when (TB = "1101") else
                "00000000" & SP when (TB = "0100") else
                "00000000" & GR0 when (TB = "0111" and GRM = "000") else
                "00000000" & GR1 when (TB = "0111" and GRM = "001") else
                "00000000" & GR2 when (TB = "0111" and GRM = "010") else
                "00000000" & GR3 when (TB = "0111" and GRM = "011") else
                "00000000" & GR4 when (TB = "0111" and GRM = "100") else
                "00000000" & GR5 when (TB = "0111" and GRM = "101") else
                "00000000" & GR6 when (TB = "0111" and GRM = "110") else
                "00000000" & GR7 when (TB = "0111" and GRM = "111") else
				"00000000000000000000" & AR when (TB = "0101") else
					-- (här bör AR, HR vara, annat vet ej)
		(others => '0');

end architecture;
