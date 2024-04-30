library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
	generic (
        input_width: positive := 16
	);
	port (
        clk1 : in	std_logic;
        clk2 : in	std_logic;
        rst_n : in	std_logic;
        bin_in: in std_logic_vector(input_width - 1 downto 0);
        bin_out: out std_logic_vector(input_width - 1 downto 0)
	);
end entity synchronizer;

architecture rtl of synchronizer is
	component bin_to_gray is
        generic (
		    input_width: positive := 16
	    );
	    port (
            bin_in: in std_logic_vector(input_width - 1 downto 0);
            gray_out: out std_logic_vector(input_width - 1 downto 0)
        );
    end component bin_to_gray;

    component sync3 is
        generic (
              input_width: positive := 16
          );
        port (
          clk1 : in	std_logic;
          clk2 : in	std_logic;
          rst_n : in	std_logic;
          d : in std_logic_vector(input_width - 1 downto 0);
          q : out std_logic_vector(input_width - 1 downto 0)
        );
      end component sync3;

    component gray_to_bin is
        generic (
		    input_width: positive := 16
	    );
	    port (
            gray_in: in std_logic_vector(input_width - 1 downto 0);
	        bin_out: out std_logic_vector(input_width - 1 downto 0)
        );
    end component gray_to_bin;

    signal bin_sync: std_logic_vector(input_width - 1 downto 0);
    signal sync_bin: std_logic_vector(input_width - 1 downto 0);
begin
	bin_to_gray_inst : bin_to_gray
        generic map (
            input_width => input_width
        )
        port map (
            bin_in   => bin_in
            gray_out => bin_sync
        );

    sync3_inst : sync3
        generic map (
            input_width => input_width
        )
        port map (
            clk1  => clk1,
            clk2  => clk2,
            rst_n => rst_n,        -- Assuming synchronous reset is active high
            d     => bin_sync,
            q     => sync_bin
        );
    gray_to_bin_inst : gray_to_bin
        generic map (
            input_width => input_width
        )
        port map (
            gray_in => sync_bin,
            bin_out => bin_out
        );
end architecture rtl;