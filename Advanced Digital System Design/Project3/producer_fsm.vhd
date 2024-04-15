library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity producer_fsm is
    generic (
        ADDR_WIDTH : natural := 6
    );
    port (
        clk          : in  std_logic;  --1MHz
        tail_ptr     : in  natural range 0 to 2**ADDR_WIDTH - 1;
        address_b    : out natural range 0 to 2**ADDR_WIDTH - 1;
        soc          : out std_logic;  -- Start of conversion
        dout         : in  std_logic;  -- Done
        save         : out  std_logic  -- Save
    );
end entity producer_fsm;

architecture fsm_arch of producer_fsm is
    type state_type is (START, WAIT, CHECK, INCREMENT);
    signal state : state_type := START; -- Initialize to START
    signal next_address_b : natural range 0 to 2**ADDR_WIDTH := 0; -- Initialize to 0
begin

    process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when START =>
                    save <= '0';
                    soc <= '1';
                    state <= WAIT;
                when WAIT =>
                    soc <= '0';
                    if dout = '1' then
                        state <= CHECK;
                    end if;
                when CHECK =>
                    if next_address_b > tail_ptr or next_address_b < tail_ptr - 1 then
                        state <= INCREMENT;
                    else
                        state <= CHECK;
                    end if;
                when INCREMENT =>
                    save <= '1';
                    if next_address_b + 1 <= 2**ADDR_WIDTH - 1 then
                        next_address_b <= next_address_b + 1;
                    else
                        next_address_b <= 0;
            end case;
        end if;
    end process;

    address_b <= next_address_b;

end architecture fsm_arch;
