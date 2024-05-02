library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.seven_segment_pkg.all;

entity SevenSegmentDriver is
    generic (
        lamp_mode_common_anode :    boolean := true;
        decimal_support :           boolean := true;
        implementer :               natural range 1 to 255 := 7;
        revision :                  natural range 0 to 255 := 0
    );
    port (
        clk :       in std_logic;
        reset_n :   in std_logic;
        address :   in std_logic_vector(1 downto 0);
        read :      in std_logic;
        readdata :  out std_logic_vector(31 downto 0);
        write :     in std_logic;
        writedata : in std_logic_vector(31 downto 0);
        lamps :     out std_logic_vector(41 downto 0)
    );
end entity SevenSegmentDriver;

architecture rtl of SevenSegmentDriver is
    function lamp_mode return lamp_configuration is 
    begin
        if lamp_mode_common_anode then 
            return common_anode;
        end if;
        return common_cathode;
    end function lamp_mode;
    function features_reg return std_logic_vector is
        variable result : std_logic_vector(31 downto 0) := (others => '0');
        begin
            result(31 downto 24) := std_logic_vector(to_unsigned(implementer,8));
            result(23 downto 16) := std_logic_vector(to_unsigned(revision,8));
            if lamp_mode = common_anode then
                result(3) := '1';
            end if;
            if decimal_support then
                result(0) := '1';
            end if;
            return result;
        end function features_reg;
    signal data_reg         : std_logic_vector(31 downto 0);
    signal control_reg      : std_logic_vector(31 downto 0);
    constant MAGIC_NUMBER     : std_logic_vector(31 downto 0) := x"41445335";
    signal preoutput        : std_logic_vector(19 downto 0);
    constant all_lamps_off : seven_segment_array(5 downto 0) := (others => lamps_off(lamp_mode));
begin
    preoutput <= to_bcd(data_reg(15 downto 0)) when control_reg(1) = '1' and decimal_support else data_reg(19 downto 0);
    lamps <=  concatenate_segments(get_hex_number("0000" & preoutput, lamp_mode)) when control_reg(0) = '1' else concatenate_segments(all_lamps_off);
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            -- Reset initialization
            data_reg <= (others => '0');
            control_reg <= (others => '0');
        elsif rising_edge(clk) then
            -- Memory-mapped register logic
            if read = '1' then -- Read operation
                case address is
                    when "00" => -- Data register
                        readdata <= data_reg;
                    when "01" => -- Control register
                        readdata <= control_reg;
                    when "10" => -- Features register
                        readdata <= features_reg;
                    when "11" => -- Magic number
                        readdata <= MAGIC_NUMBER;
                    when others =>
                        readdata <= (others => '0'); -- Default case
                end case;
            elsif write = '1' then -- Write operation
                case address is
                    when "00" => -- Data register
                        data_reg <= writedata;
                    when "01" => -- Control register
                        -- Only write to non-reserved bits
                        control_reg(0) <= writedata(0);
                        if decimal_support then
                            control_reg(1) <= writedata(1);
                        end if;
                    when others =>
                        null; -- Ignore writes to other addresses
                end case;
            end if;
        end if;
    end process;
end rtl;