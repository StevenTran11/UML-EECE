library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.seven_segment_pkg.all;

entity project3 is
    generic (
            ADDR_WIDTH : natural := 6
        );
    port (
        clk_10MHz : in std_logic;   -- Input clock of 10 MHz
        clk_50MHz : in std_logic;   -- Input clock of 50 MHz
		rst       : in  std_logic;  -- Reset
        -- Seven-Segment Display Ports
        HEX00 : out std_logic;  -- PIN_C14
        HEX01 : out std_logic;  -- PIN_E15
        HEX02 : out std_logic;  -- PIN_C15
        HEX03 : out std_logic;  -- PIN_C16
        HEX04 : out std_logic;  -- PIN_E16
        HEX05 : out std_logic;  -- PIN_D17
        HEX06 : out std_logic;  -- PIN_C17
        HEX07 : out std_logic;  -- PIN_D15
        HEX10 : out std_logic;  -- PIN_C18
        HEX11 : out std_logic;  -- PIN_D18
        HEX12 : out std_logic;  -- PIN_E18
        HEX13 : out std_logic;  -- PIN_B16
        HEX14 : out std_logic;  -- PIN_A17
        HEX15 : out std_logic;  -- PIN_A18
        HEX16 : out std_logic;  -- PIN_B17
        HEX17 : out std_logic   -- PIN_A16
    );
end entity project3;

architecture rtl of project3 is
    -- Components declaration
	component pll is
        port (
            inclk0: in std_logic;
            c0    : out std_logic
        );
    end component pll;

    component max10_adc is
        port (
            pll_clk:	in	std_logic;
            chsel:		in	natural range 0 to 2**5 - 1;
            soc:		in	std_logic;
            tsen:		in	std_logic;
            dout:		out	natural range 0 to 2**12 - 1;
            eoc:		out	std_logic;
            clk_dft:	out	std_logic
        );
    end component max10_adc;

    component producer_fsm is
        generic (
            ADDR_WIDTH : natural := 6
        );
        port (
            clk          : in  std_logic;  --1MHz
            tail_ptr     : in  natural range 0 to 2**ADDR_WIDTH - 1;
            address_b    : out natural range 0 to 2**ADDR_WIDTH - 1;
            soc          : out std_logic;  -- Start of conversion
            done         : in  std_logic;  -- Done
			rst          : in  std_logic;  -- Reset
            save         : out  std_logic  -- Save
        );
    end component producer_fsm;

    component consumer_fsm is
        generic (
            ADDR_WIDTH : natural := 6
        );
        port (
            clk             : in  std_logic;
				rst             : in  std_logic;  -- Reset
            head_ptr        : in  natural range 0 to 2**ADDR_WIDTH - 1;
            address_a       : out natural range 0 to 2**ADDR_WIDTH - 1
        );
    end component consumer_fsm;

    component true_dual_port_ram_dual_clock is

        generic 
        (
            DATA_WIDTH : natural := 12;
            ADDR_WIDTH : natural := 6
        );
    
        port 
        (
            clk_a	: in std_logic;
            clk_b	: in std_logic;
            addr_a	: in natural range 0 to 2**ADDR_WIDTH - 1;
            addr_b	: in natural range 0 to 2**ADDR_WIDTH - 1;
            data_a	: in std_logic_vector((DATA_WIDTH-1) downto 0);
            data_b	: in std_logic_vector((DATA_WIDTH-1) downto 0);
            we_a	: in std_logic := '1';
            we_b	: in std_logic := '1';
            q_a		: out std_logic_vector((DATA_WIDTH -1) downto 0);
            q_b		: out std_logic_vector((DATA_WIDTH -1) downto 0)
        );
    
    end component true_dual_port_ram_dual_clock;
	 
    component synchronizer is
        generic (
            input_width: positive := 16
        );
        port (
            clk1 : in	std_logic;
            clk2 : in	std_logic;
            rst_n : in	std_logic;
            bin_in : in std_logic_vector(input_width - 1 downto 0);
            bin_out : out std_logic_vector(input_width - 1 downto 0)
        );
    end component synchronizer;

    -- Internal signals
    signal pll_clk      : std_logic;   -- clock of 1 MHz
    signal q_a : std_logic_vector(11 downto 0);
    signal hex_display : seven_segment_array(0 to 1);

    signal soc:     std_logic;
    signal dout:    natural range 0 to 2**12 - 1;
    signal done:    std_logic;
    signal save:    std_logic;
    signal clk_dft: std_logic;

    signal tail_ptr_50, tail_ptr_1:         natural range 0 to 2**ADDR_WIDTH - 1;
    signal tail_ptr_vec_50, tail_ptr_vec_1: std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal head_ptr_50, head_ptr_1:         natural range 0 to 2**ADDR_WIDTH - 1;
    signal head_ptr_vec_50, head_ptr_vec_1: std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal dout_vec : std_logic_vector(11 downto 0);
    signal temperature : std_logic_vector(5 downto 0); -- Output temperature as std_logic_vector
    signal temperature_dec : std_logic_vector(11 downto 0); -- Output temperature as std_logic_vector

begin
    -- Get seven-segment configurations for the hexadecimal number
    temperature_dec <= to_bcd(temperature);
    hex_display <= get_hex_number(temperature_dec, common_anode);

    -- Convert pointers from natural to std logic vector
    tail_ptr_vec_50 <= std_logic_vector(to_unsigned(tail_ptr_50, ADDR_WIDTH));
    head_ptr_vec_1 <= std_logic_vector(to_unsigned(head_ptr_1, ADDR_WIDTH));
    dout_vec <= std_logic_vector(to_unsigned(dout, 12));
    -- Convert pointers from std logic vector to natural
    tail_ptr_1 <= to_integer(unsigned(tail_ptr_vec_1));
    head_ptr_50 <= to_integer(unsigned(head_ptr_vec_50));

    process (q_a)
    begin
        if q_a <= "111010001111" and q_a > "111010001101" then
            temperature <= "000000"; -- Temperature: 0
        elsif q_a <= "111010001101" and q_a > "111010001001" then
            temperature <= "000001"; -- Temperature: 1
        elsif q_a <= "111010001001" and q_a > "111010001000" then
            temperature <= "000010"; -- Temperature: 2
        elsif q_a <= "111010001000" and q_a > "111010000111" then
            temperature <= "000011"; -- Temperature: 3
        elsif q_a <= "111010000111" and q_a > "111010000101" then
            temperature <= "000100"; -- Temperature: 4
        elsif q_a <= "111010000101" and q_a > "111010000011" then
            temperature <= "000101"; -- Temperature: 5
        elsif q_a <= "111010000011" and q_a > "111010000001" then
            temperature <= "000110"; -- Temperature: 6
        elsif q_a <= "111010000001" and q_a > "111001111111" then
            temperature <= "000111"; -- Temperature: 7
        elsif q_a <= "111001111111" and q_a > "111001111101" then
            temperature <= "001000"; -- Temperature: 8
        elsif q_a <= "111001111101" and q_a > "111001111011" then
            temperature <= "001001"; -- Temperature: 9
        elsif q_a <= "111001111011" and q_a > "111001111000" then
            temperature <= "001010"; -- Temperature: 10
        elsif q_a <= "111001111000" and q_a > "111001110111" then
            temperature <= "001011"; -- Temperature: 11
        elsif q_a <= "111001110111" and q_a > "111001110110" then
            temperature <= "001100"; -- Temperature: 12
        elsif q_a <= "111001110110" and q_a > "111001110100" then
            temperature <= "001101"; -- Temperature: 13
        elsif q_a <= "111001110100" and q_a > "111001110011" then
            temperature <= "001110"; -- Temperature: 14
        elsif q_a <= "111001110011" and q_a > "111001110010" then
            temperature <= "001111"; -- Temperature: 15
        elsif q_a <= "111001110010" and q_a > "111001110001" then
            temperature <= "010000"; -- Temperature: 16
        elsif q_a <= "111001110001" and q_a > "111001110000" then
            temperature <= "010001"; -- Temperature: 17
        elsif q_a <= "111001110000" and q_a > "111001101111" then
            temperature <= "010010"; -- Temperature: 18
        elsif q_a <= "111001101111" and q_a > "111001101000" then
            temperature <= "010011"; -- Temperature: 19
        elsif q_a <= "111001101000" and q_a > "111001100100" then
            temperature <= "010100"; -- Temperature: 20
        elsif q_a <= "111001100100" and q_a > "111001100010" then
            temperature <= "010101"; -- Temperature: 21
        elsif q_a <= "111001100010" and q_a > "111001100000" then
            temperature <= "010110"; -- Temperature: 22
        elsif q_a <= "111001100000" and q_a > "111001011110" then
            temperature <= "010111"; -- Temperature: 23
        elsif q_a <= "111001011110" and q_a > "111001011101" then
            temperature <= "011000"; -- Temperature: 24
        elsif q_a <= "111001011101" and q_a > "111001011100" then
            temperature <= "011001"; -- Temperature: 25
        elsif q_a <= "111001011100" and q_a > "111001011001" then
            temperature <= "011010"; -- Temperature: 26
        elsif q_a <= "111001011001" and q_a > "111001010110" then
            temperature <= "011011"; -- Temperature: 27
        elsif q_a <= "111001010110" and q_a > "111001010011" then
            temperature <= "011100"; -- Temperature: 28
        elsif q_a <= "111001010011" and q_a > "111001010010" then
            temperature <= "011101"; -- Temperature: 29
        elsif q_a <= "111001010010" and q_a > "111001010000" then
            temperature <= "011110"; -- Temperature: 30
        elsif q_a <= "111001010000" and q_a > "111001001110" then
            temperature <= "011111"; -- Temperature: 31
        elsif q_a <= "111001001110" and q_a > "111001001100" then
            temperature <= "100000"; -- Temperature: 32
        elsif q_a <= "111001001100" and q_a > "111001001010" then
            temperature <= "100001"; -- Temperature: 33
        elsif q_a <= "111001001010" and q_a > "111001001000" then
            temperature <= "100010"; -- Temperature: 34
        elsif q_a <= "111001001000" and q_a > "111001000110" then
            temperature <= "100011"; -- Temperature: 35
        elsif q_a <= "111001000110" and q_a > "111001000011" then
            temperature <= "100100"; -- Temperature: 36
        elsif q_a <= "111001000011" and q_a > "111001000000" then
            temperature <= "100101"; -- Temperature: 37
        elsif q_a <= "111001000000" and q_a > "111000111101" then
            temperature <= "100110"; -- Temperature: 38
        elsif q_a <= "111000111101" and q_a > "111000111011" then
            temperature <= "100111"; -- Temperature: 39
        elsif q_a <= "111000111011" then
            temperature <= "101000"; -- Temperature: 40
        else
            temperature <= "000000"; -- Default temperature if code is out of range
        end if;
    end process;

    -- Display hexadecimal digits on seven-segment display ports
    HEX00 <= hex_display(0).a;
    HEX01 <= hex_display(0).b;
    HEX02 <= hex_display(0).c;
    HEX03 <= hex_display(0).d;
    HEX04 <= hex_display(0).e;
    HEX05 <= hex_display(0).f;
    HEX06 <= hex_display(0).g;

    HEX10 <= hex_display(1).a;
    HEX11 <= hex_display(1).b;
    HEX12 <= hex_display(1).c;
    HEX13 <= hex_display(1).d;
    HEX14 <= hex_display(1).e;
    HEX15 <= hex_display(1).f;
    HEX16 <= hex_display(1).g;

    -- Turn off unused segments
    HEX07 <= '1';
    HEX17 <= '1';

    -- Instantiate PLL
	pll_inst : pll
        port map (
            inclk0 => clk_10MHz,
            c0     => pll_clk
        );
    -- Instantiate ADC
    adc_inst : max10_adc
        port map (
            pll_clk => pll_clk,
            chsel => 0,
            soc => soc,
            tsen => '1',  -- 0 = Normal, 1 = Temperature Sensing
            dout => dout,
            eoc => done,
            clk_dft => clk_dft
        );
    -- Instantiate Producer FSM
    producer_inst : producer_fsm
        generic map (
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk       => clk_dft,
            tail_ptr  => tail_ptr_1,
            address_b => head_ptr_1,
            soc       => soc,
            done      => done,
			rst		  => rst,
            save      => save
        );
    -- Instantiate Consumer FSM
    consumer_inst : consumer_fsm
        generic map (
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk       => clk_50MHz,
			rst		  => rst,
            head_ptr  => head_ptr_50,
            address_a => tail_ptr_50
        );

    -- Instantiate Dual-Port RAM
    ram_inst : true_dual_port_ram_dual_clock
        generic map (
            DATA_WIDTH => 12,
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk_a => clk_50MHz,
            clk_b => clk_dft,
            addr_a => tail_ptr_50,
            addr_b => head_ptr_1,
            data_a => (others => '0'), -- Not used
            data_b => dout_vec, -- Convert dout to std_logic_vector
            we_a => '0', -- No Write
            we_b => save,
            q_a => q_a,
            q_b => open
        );

    -- Conversions
    -- Address a -> tail pointer 1
    synchronizer_inst1 : synchronizer
        generic map(
            input_width => ADDR_WIDTH
        )
        port map(
            clk1 => clk_50MHz,
            clk2  => clk_dft,
            rst_n => rst,
            bin_in => tail_ptr_vec_50,
            bin_out => tail_ptr_vec_1
        );
    -- Address b to head pointer 50
    synchronizer_inst2 : synchronizer
        generic map(
            input_width => ADDR_WIDTH
        )
        port map(
            clk1 => clk_dft,
            clk2  => clk_50MHz,
            rst_n => rst,
            bin_in => head_ptr_vec_1,
            bin_out => head_ptr_vec_50
        );
end architecture rtl;
