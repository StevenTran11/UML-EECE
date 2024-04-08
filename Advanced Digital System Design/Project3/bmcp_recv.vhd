library ieee;
use ieee.std_logic_1164.all;

entity bmcp_recv is
  port (
    bdata  : out std_logic_vector(7 downto 0);
    bvalid : out std_logic;
    b_ack  : out std_logic;
    adata  : in std_logic_vector(7 downto 0);
    bload  : in std_logic;
    bq2_en : in std_logic;
    bclk   : in std_logic;
    brst_n : in std_logic
  );
end entity bmcp_recv;

architecture rtl of bmcp_recv is

  signal b_en : std_logic;
  signal bload_data : std_logic;

  component plsgen is
    port (
      pulse    : out std_logic;
      q        : out std_logic;
      d        : in std_logic;
      clk      : in std_logic;
      rst_n    : in std_logic
    );
  end component plsgen;

  component back_fsm is
    port (
      bclk     : in std_logic;
      brst_n   : in std_logic;
      bload    : in std_logic;
      b_en     : in std_logic;
      bvalid   : out std_logic
    );
  end component back_fsm;

begin

  pg1 : plsgen port map (
    pulse  => b_en,
    q      => open,  -- Unused q output
    d      => bq2_en,
    clk    => bclk,
    rst_n  => brst_n
  );

  fsm : back_fsm port map (
    bclk  => bclk,
    brst_n => brst_n,
    bload => bload,
    b_en  => b_en,
    bvalid => bvalid
  );

  bload_data <= bvalid and bload;

  process(bclk, brst_n)
  begin
    if rising_edge(bclk) then
      if brst_n = '0' then
        b_ack <= '0';
      else
        if bload_data then
          b_ack <= not b_ack;
        end if;
      end if;
    end if;
  end process;

  process(bclk, brst_n)
  begin
    if rising_edge(bclk) then
      if brst_n = '0' then
        bdata <= (others => '0');  -- Initialize to all zeros
      else
        if bload_data then
          bdata <= adata;
        end if;
      end if;
    end if;
  end process;

end architecture rtl;
