library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.seven_segment_pkg.all;

entity project3 is
    generic (
            ADDR_WIDTH : natural := 7
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

    function natural_to_std_logic_vector(value : natural; width : positive) return std_logic_vector is
        variable result : std_logic_vector(width-1 downto 0);
    begin
        for i in width-1 downto 0 loop
            if (value / (2**i)) mod 2 = 1 then
                result(i) := '1';
            else
                result(i) := '0';
            end if;
        end loop;
        return result;
    end function natural_to_std_logic_vector;

    function std_logic_vector_to_natural(value : std_logic_vector) return natural is
        variable result : natural := 0;
    begin
        for i in value'range loop
            if value(i) = '1' then
                result := result + 2**(value'length - 1 - i);
            end if;
        end loop;
        return result;
    end function std_logic_vector_to_natural;    

    -- Internal signals
    signal pll_clk      : std_logic;   -- clock of 1 MHz
    signal q_a: std_logic_vector(11 downto 0);
    signal hex_display : seven_segment_array(0 to 1);

    signal soc:     std_logic;
    signal dout:    natural range 0 to 2**12 - 1;
    signal done:    std_logic;
    signal save:    std_logic;

    signal tail_ptr_50, tail_ptr_1:         natural range 0 to 2**ADDR_WIDTH - 1;
    signal tail_ptr_vec_50, tail_ptr_vec_1: std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal head_ptr_50, head_ptr_1:         natural range 0 to 2**ADDR_WIDTH - 1;
    signal head_ptr_vec_50, head_ptr_vec_1: std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal dout_vec : std_logic_vector(11 downto 0);

	 signal adc_clk: std_logic;
begin
    -- Get seven-segment configurations for the hexadecimal number
    hex_display <= get_hex_number(q_a, common_anode);

    -- Convert pointers from natural to std logic vector
    tail_ptr_vec_50 <= std_logic_vector(to_unsigned(tail_ptr_50, ADDR_WIDTH));
    head_ptr_vec_1 <= std_logic_vector(to_unsigned(head_ptr_1, ADDR_WIDTH));
    dout_vec <= std_logic_vector(to_unsigned(dout, 12));
    -- Convert pointers from std logic vector to natural
    tail_ptr_1 <= to_integer(unsigned(tail_ptr_vec_1));
    head_ptr_50 <= to_integer(unsigned(head_ptr_vec_50));
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
    HEX07 <= '0';
    HEX17 <= '0';

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
            clk_dft => adc_clk
        );
    -- Instantiate Producer FSM
    producer_inst : producer_fsm
        generic map (
            ADDR_WIDTH => ADDR_WIDTH
        )
        port map (
            clk       => adc_clk,
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
            clk_b => adc_clk,
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
            clk2  => adc_clk,
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
            clk1 => adc_clk,
            clk2  => clk_50MHz,
            rst_n => rst,
            bin_in => head_ptr_vec_1,
            bin_out => head_ptr_vec_50
        );
end architecture rtl;
