library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity consumer_fsm is
    generic (
        ADDR_WIDTH : natural := 6
    );
    port (
        clk             : in  std_logic;
        head_ptr        : in  natural range 0 to 2**ADDR_WIDTH - 1;
        address_a       : out natural range 0 to 2**ADDR_WIDTH - 1
    );
end entity consumer_fsm;

architecture fsm_arch of consumer_fsm is
    type state_type is (WAIT_FOR_SPACE, INCREMENT_ADDRESS);
    signal state : state_type := WAIT_FOR_SPACE; -- Initialize to WAIT_FOR_SPACE
    signal next_address_a : natural range 0 to 2**ADDR_WIDTH := 2**ADDR_WIDTH - 1; -- Initialize to max value
begin

    process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when WAIT_FOR_SPACE =>
                    next_address_a <= next_address_a;
                when INCREMENT_ADDRESS =>
                    if next_address_a + 1 <= 2**ADDR_WIDTH - 1 then
                        next_address_a <= next_address_a + 1;
                    else
                        next_address_a <= 0;
                    end if;
            end case;

            if (head_ptr > next_address_a + 1) or (next_address_a - head_ptr) < (2**ADDR_WIDTH - 1) then
                state <= INCREMENT_ADDRESS;
            else
                state <= WAIT_FOR_SPACE;
            end if;
        end if;
    end process;

    address_a <= next_address_a;

end architecture fsm_arch;
