library ieee;
use ieee.std_logic_1164.all;

entity amcp_send is
  port (
    adata    : out std_logic_vector(7 downto 0);
    a_en     : out std_logic;
    aready   : out std_logic;
    adatain  : in std_logic_vector(7 downto 0);
    asend     : in std_logic;
    aq2_ack  : in std_logic;
    aclk     : in std_logic;
    arst_n   : in std_logic
  );
end entity amcp_send;

architecture rtl of amcp_send is

  signal aack : std_logic;
  signal anxt_data : std_logic;

  component plsgen is
    port (
      pulse    : out std_logic;
      q        : out std_logic;
      d        : in std_logic;
      clk      : in std_logic;
      rst_n    : in std_logic
    );
  end component plsgen;

  component asend_fsm is
    port (
      asend     : in std_logic;
      aq2_ack   : in std_logic;
      aready    : out std_logic
    );
  end component asend_fsm;

begin

  pg1 : plsgen port map (
    pulse  => aack,
    q      => open,  -- Unused q output
    d      => aq2_ack,
    clk    => aclk,
    rst_n  => arst_n
  );

  fsm : asend_fsm port map (
    asend   => asend,
    aq2_ack => aq2_ack,
    aready  => aready
  );

  anxt_data <= aready and asend;

  process(aclk, arst_n)
  begin
    if rising_edge(aclk) then
      if arst_n = '0' then
        a_en <= '0';
      else
        if anxt_data then
          a_en <= not a_en;
        end if;
      end if;
    end if;
  end process;

  process(aclk, arst_n)
  begin
    if rising_edge(aclk) then
      if arst_n = '0' then
        adata <= (others => '0');  -- Initialize all bits to zero
      else
        if anxt_data then
          adata <= adatain;
        end if;
      end if;
    end if;
  end process;

end architecture rtl;
