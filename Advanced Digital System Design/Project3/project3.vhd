library ieee;
use ieee.std_logic_1164.all;

entity project3 is
    generic (
            ADDR_WIDTH : natural := 6
        );
    port (
        clk_10MHz : in std_logic;   -- Input clock of 10 MHz
        clk_50MHz : in std_logic    -- Input clock of 50 MHz
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
            save         : out  std_logic  -- Save
        );
    end component producer_fsm;

    component consumer_fsm is
        generic (
            ADDR_WIDTH : natural := 6
        );
        port (
            clk             : in  std_logic;
            head_ptr        : in  natural range 0 to 2**ADDR_WIDTH - 1;
            address_a       : out natural range 0 to 2**ADDR_WIDTH - 1
        );
    end component consumer_fsm;

    component true_dual_port_ram_dual_clock is

        generic 
        (
            DATA_WIDTH : natural := 8;
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
	 
    component bin_to_gray is
        generic (
            input_width: positive := 6  -- Assuming 6-bit input
        );
        port (
            bin_in  : in  std_logic_vector(input_width - 1 downto 0);
            gray_out: out std_logic_vector(input_width - 1 downto 0)
        );
    end component bin_to_gray;

    component gray_to_bin is
        generic (
            input_width: positive := 6  -- Assuming 6-bit input
        );
        port (
            gray_in : in  std_logic_vector(input_width - 1 downto 0);
            bin_out : out std_logic_vector(input_width - 1 downto 0)
        );
    end component gray_to_bin;

    component sync3 is
        port (
            clk1  : in  std_logic;
            clk2  : in  std_logic;
            rst_n : in  std_logic;
            d     : in  std_logic;
            q     : out std_logic
        );
    end component sync3;

    -- Internal signals
    signal addr_b_gray    : std_logic_vector(5 downto 0);
    signal addr_b_sync    : std_logic_vector(5 downto 0);
    signal head_ptr_gray : std_logic_vector(5 downto 0);
    signal head_ptr_sync : std_logic_vector(5 downto 0);
    signal tail_ptr_gray : std_logic_vector(5 downto 0);
    signal tail_ptr_sync : std_logic_vector(5 downto 0);
    signal pll_clk      : std_logic;   -- clock of 1 MHz
    signal head_ptr : natural range 0 to 2**ADDR_WIDTH - 1;
    signal tail_ptr : natural range 0 to 2**ADDR_WIDTH - 1;
    signal address_a : natural range 0 to 2**ADDR_WIDTH - 1;
    signal address_b : natural range 0 to 2**ADDR_WIDTH - 1;
    signal q_a, q_b: std_logic_vector(7 downto 0);

    signal chsel:       natural range 0 to 2**5 - 1;
    signal soc:         std_logic;
    signal dout:        natural range 0 to 2**12 - 1;
    signal done:        std_logic;
    signal clk_dft:     std_logic;
    signal save:     std_logic;

begin
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
            chsel => chsel,
            soc => soc,
            tsen => '1',  -- 0 = Normal, 1 = Temperature Sensing
            dout => dout,
            eoc => done,
            clk_dft => clk_dft
        );
    -- Instantiate Producer FSM
    producer_inst : producer_fsm
        generic map (
            ADDR_WIDTH => 6
        )
        port map (
            clk       => pll_clk,
            tail_ptr  => tail_ptr,
            address_b => address_b,
            soc       => soc,
            done      => done,
            save      => save
        );
    -- Instantiate Consumer FSM
    consumer_inst : consumer_fsm
        generic map (
            ADDR_WIDTH => 6
        )
        port map (
            clk       => clk_50MHz,
            head_ptr  => head_ptr,
            address_a => address_a
        );

    -- Instantiate Dual-Port RAM
    ram_inst : true_dual_port_ram_dual_clock
        generic map (
            DATA_WIDTH => 8,
            ADDR_WIDTH => 6
        )
        port map (
            clk_a => clk_50MHz,
            clk_b => pll_clk,
            addr_a => address_a,
            addr_b => address_b,
            data_a => dout, --Not used
            data_b => dout,
            we_a => '0', --No Write
            we_b => save,
            q_a => q_a, --Used to sev seg display.  Not added yet
            q_b => q_b
        );

    -- Conversions

    -- Transformation loop for address_b
    bin_to_gray_inst1 : bin_to_gray
        generic map (
            input_width => 6  -- Assuming 6-bit input
        )
        port map (
            bin_in   => address_b,
            gray_out => addr_b_gray
        );

    sync3_inst1 : sync3
        port map (
            clk1  => clk_50MHz,
            clk2  => pll_clk,
            rst_n => '1',        -- Assuming synchronous reset is active high
            d     => addr_b_gray,
            q     => addr_b_sync
        );

    gray_to_bin_inst1 : gray_to_bin
        generic map (
            input_width => 6  -- Assuming 6-bit input
        )
        port map (
            gray_in => addr_b_sync,
            bin_out => head_ptr
        );

    -- Transformation loop for addr_a
    bin_to_gray_inst2 : bin_to_gray
        generic map (
            input_width => 6  -- Assuming 6-bit input
        )
        port map (
            bin_in   => address_a,
            gray_out => tail_ptr_gray
        );

    sync3_inst2 : sync3
        port map (
            clk1  => clk_50MHz,
            clk2  => pll_clk,
            rst_n => '1',            -- Assuming synchronous reset is active high
            d     => tail_ptr_gray,
            q     => tail_ptr_sync
        );

    gray_to_bin_inst2 : gray_to_bin
        generic map (
            input_width => 6  -- Assuming 6-bit input
        )
        port map (
            gray_in => tail_ptr_sync,
            bin_out => tail_ptr
        );
end architecture rtl;
