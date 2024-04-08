library ieee;
use ieee.std_logic_1164.all;

entity mcp_blk is
  generic (
    dat_t : std_logic_vector(7 downto 0)
  );
  port (
    aready      : out std_logic;
    adatain     : in std_logic_vector(7 downto 0);
    asend       : in std_logic;
    aclk        : in std_logic;
    arst_n      : in std_logic;
    bdata       : out std_logic_vector(7 downto 0);
    bvalid      : out std_logic;
    bload       : in std_logic;
    bclk        : in std_logic;
    brst_n      : in std_logic
  );
end entity mcp_blk;

architecture rtl of mcp_blk is

  signal adata      : std_logic_vector(7 downto 0);
  signal b_ack      : std_logic;
  signal a_en       : std_logic;
  signal bq2_en     : std_logic;
  signal aq2_ack    : std_logic;

  component sync3 is  -- Assuming sync3 has the same port structure as sync2
    port (
      q      : out std_logic;
      d      : in std_logic;
      clk    : in std_logic;
      rst_n  : in std_logic
    );
  end component sync3;

  component amcp_send is
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
  end component amcp_send;

  component bmcp_recv is
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
  end component bmcp_recv;

begin

  async : sync3 port map (  -- Replace with actual sync3 port mapping
    q      => aq2_ack,
    d      => b_ack,
    clk    => aclk,
    rst_n  => arst_n
  );

  bsync : sync3 port map (  -- Replace with actual sync3 port mapping
    q      => bq2_en,
    d      => a_en,
    clk    => bclk,
    rst_n  => brst_n
  );

  alogic : amcp_send port map (
    adata   => adata,
    a_en    => a_en,
    aready  => aready,
    adatain => adatain,
    asend   => asend,
    aq2_ack => aq2_ack,
    aclk    => aclk,
    arst_n  => arst_n
  );

  blogic : bmcp_recv port map (
    bdata  => bdata,
    bvalid => bvalid,
    b_ack  => b_ack,
    adata  => adata,
    bload  => bload,
    bq2_en => bq2_en,
    bclk   => bclk,
    brst_n => brst_n
  );

end architecture rtl;
