library ieee;
use ieee.std_logic_1164.all;

entity cdc_syncfifo is
  generic (
    dat_t : std_logic_vector(7 downto 0)  -- Replace with actual data width
  );
  port (
    wdata  : in std_logic_vector(dat_t'range);  -- Data to write
    wrdy   : out std_logic;                      -- Write ready
    wput   : in std_logic;                      -- Write enable
    wclk   : in std_logic;                      -- Write clock
    wrst_n : in std_logic;                      -- Write reset (active low)
    rdata  : out std_logic_vector(dat_t'range);  -- Data to read
    rrdy   : out std_logic;                      -- Read ready
    rget   : in std_logic;                      -- Read enable
    rclk   : in std_logic;                      -- Read clock
    rrst_n : in std_logic                       -- Read reset (active low)
  );
end entity cdc_syncfifo;

architecture rtl of cdc_syncfifo is

  signal wptr  : std_logic_vector(n-1 downto 0);  -- Write pointer (internal)
  signal we     : std_logic;                      -- Write enable (internal)
  signal wq2_rptr : std_logic_vector(n-1 downto 0);  -- Write pointer (synced to read clock)
  signal rptr  : std_logic_vector(n-1 downto 0);  -- Read pointer (internal)
  signal rq2_wptr : std_logic_vector(n-1 downto 0);  -- Read pointer (synced to write clock)

  constant N : positive := dat_t'length;

  component wctl is
    port (
      wrdy   : out std_logic;
      wptr   : out std_logic_vector(n-1 downto 0),
      we     : out std_logic;
      wput   : in std_logic;
      wq2_rptr : in std_logic_vector(n-1 downto 0),
      wclk    : in std_logic;
      wrst_n  : in std_logic
    );
  end component wctl;

  component rctl is
    port (
      rrdy   : out std_logic;
      rptr   : out std_logic_vector(n-1 downto 0),
      rget   : in std_logic;
      rq2_wptr : in std_logic_vector(n-1 downto 0),
      rdata  : in std_logic_vector(dat_t'range);
      rclk    : in std_logic;
      rrst_n  : in std_logic
    );
  end component rctl;

  component sync3 is
    port (
      q      : out std_logic;
      d      : in std_logic;
      clk    : in std_logic;
      rst_n  : in std_logic
    );
  end component sync3;

  component dp_ram2 is
    generic (
      dat_t : std_logic_vector(7 downto 0)  -- Replace with actual data width
    );
    port (
      q      : out std_logic_vector(dat_t'range);
      d      : in std_logic_vector(dat_t'range);
      waddr  : in std_logic_vector(1 downto 0);    -- Assuming RAM depth is 2
      raddr  : in std_logic_vector(1 downto 0);    -- Assuming RAM depth is 2
      we     : in std_logic;
      clk    : in std_logic
    );
  end component dp_ram2;

begin

  -- Instantiate wctl component
  wctl_inst : wctl port map (
    wrdy   => wrdy,
    wptr   => wptr,
    we     => we,
    wput   => wput,
    wq2_rptr => wq2_rptr,
    wclk    => wclk,
    wrst_n  => wrst_n
  );

  -- Instantiate rctl component
  rctl_inst : rctl port map (
    rrdy   => rrdy,
    rptr   => rptr,
    rget   => rget,
    rq2_wptr => rq2_wptr,
    rdata  => rdata,
    rclk    => rclk,
    rrst_n  => rrst_n
  );

  -- Instantiate sync2 components for write and read pointers
  w2r_sync : sync3 port map (
    q      => rq2_wptr,
    d      => wptr,
    clk    => rclk,
    rst_n  => rrst_n
  );

  r2w_sync : sync3 port map (
    q      => wq2_rptr,
    d      => rptr,
    clk    => wclk,
    rst_n  => wrst_n
  );

  -- Instantiate dp_ram2 component
  dpram : dp_ram2 generic map (
    dat_t => dat_t
  ) port map (
    q      => rdata,
    d      => wdata,
    waddr  => wptr,
    raddr  => rptr,
    we     => we,
    clk    => wclk
  );

end architecture rtl;
