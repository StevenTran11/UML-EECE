library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FlipFlop is
    Port (
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        h_sync: in  STD_LOGIC;
        v_sync: in  STD_LOGIC;
        point_valid_in: in  boolean;
        h_sync_out: out STD_LOGIC;
        v_sync_out: out STD_LOGIC;
        point_valid_out: out  boolean
    );
end FlipFlop;

architecture Behavioral of FlipFlop is
    signal h_sync_reg, v_sync_reg: STD_LOGIC;
begin
    process(clk, reset)
    begin
        if reset = '0' then
            h_sync_reg <= '0';
            v_sync_reg <= '0';
            point_valid_out <= false;
        elsif rising_edge(clk) then
            h_sync_reg <= h_sync;
            v_sync_reg <= v_sync;
            point_valid_out <= point_valid_in;
        end if;
    end process;

    h_sync_out <= h_sync_reg;
    v_sync_out <= v_sync_reg;
end Behavioral;
