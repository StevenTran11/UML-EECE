library ieee;
use ieee.std_logic_1164.all;

entity color_map_tb is
end entity color_map_tb;

architecture tb_arch of tb_color_map is
    -- Constants declaration
    constant CLK_PERIOD : time := 10 ns;  -- Clock period (simulation time)
    constant TOTAL_STAGES : natural := 10; -- Total stages for testing
    
    -- Components declaration
    component color_map
        generic (
            total_stages : natural := 0
        );
        port (
            clk    : in  std_logic;
            reset  : in  std_logic;
            stage_input : in complex_record;  -- Assuming complex_record type is defined
            vga_red   : out std_logic_vector(3 downto 0);
            vga_green : out std_logic_vector(3 downto 0);
            vga_blue  : out std_logic_vector(3 downto 0)
        );
    end component color_map;
    
    -- Signals declaration
    signal clk : std_logic := '0';  -- Clock signal
    signal reset : std_logic := '1';  -- Reset signal
    signal stage_input : complex_record;  -- Input signal
    signal vga_red, vga_green, vga_blue : std_logic_vector(3 downto 0);  -- Output signals
    
begin
    -- Instantiate the DUT
    dut: color_map
        generic map (
            total_stages => TOTAL_STAGES
        )
        port map (
            clk => clk,
            reset => reset,
            stage_input => stage_input,
            vga_red => vga_red,
            vga_green => vga_green,
            vga_blue => vga_blue
        );

    -- Clock process
    clk_process: process
    begin
        while now < 100000 ns loop  -- Simulation time limit
            clk <= not clk;
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Test process
    test_process: process
    begin
        -- Initialize reset
        reset <= '1';
        wait for CLK_PERIOD;
        reset <= '0';
        
        -- Stimulus generation
        for i in 0 to TOTAL_STAGES loop
            stage_input <= (others => '0'); -- Assuming stage_input is a complex record with all '0's
            wait for CLK_PERIOD;
        end loop;
        wait for CLK_PERIOD;
        
        -- End simulation
        wait;
    end process;
end architecture tb_arch;