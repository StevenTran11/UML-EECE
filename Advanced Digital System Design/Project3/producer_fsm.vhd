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
        done         : in  std_logic;  -- Done
        rst          : in  std_logic;  -- Reset
        save         : out  std_logic  -- Save
    );
end entity producer_fsm;

architecture fsm_arch of producer_fsm is
    type state_type is (START, WAITS, CHECK, INCREMENT);
    signal state : state_type := START; -- Initialize to START
    signal next_address_b : natural range 0 to 2**ADDR_WIDTH := 0; -- Initialize to 0
	 
	function can_advance (
			head, tail: in natural range 0 to 2**ADDR_WIDTH - 1
		) return boolean
		is
	begin
		if head > tail and head /= 2**ADDR_WIDTH - 1 and tail /= 0 then
			return true;
		elsif head < tail and (tail - head) > 1 then
			return true;
		end if;
		return false;
	end function can_advance;
	 
begin

    process(clk, rst)
    begin
        if rst = '0' then
            state <= START;
            next_address_b <= 0;
        elsif rising_edge(clk) then
            case state is
                when START =>
                    save <= '0';
                    soc <= '1';
                    state <= WAITS;
                when WAITS =>
						  save <= '0';
                    soc <= '1';
                    if done = '1' then
                        state <= CHECK;
                    end if;
                when CHECK =>
						  save <= '0';
						  soc <= '0';
                    if can_advance(next_address_b, tail_ptr) then
                        state <= INCREMENT;
                    else
                        state <= CHECK;
                    end if;
                when INCREMENT =>
						  soc <= '0';
                    save <= '1';
						  state <= START;
                    if next_address_b = 2**ADDR_WIDTH - 1 then
                        next_address_b <= 0;
                    else
                        next_address_b <= next_address_b + 1;
					end if;
            end case;
        end if;
    end process;

    address_b <= next_address_b;

end architecture fsm_arch;
