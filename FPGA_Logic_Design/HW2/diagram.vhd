library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity diagram is
    Port (
		Clk_A : in  STD_LOGIC;
		Clk_B : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		Sig_A : in  STD_LOGIC;
		Sig_C : in  STD_LOGIC;
		Sig_E : in  STD_LOGIC;
		Sig_G : in  STD_LOGIC;
		Sig_B : out STD_LOGIC;
		Sig_D : out STD_LOGIC;
		Sig_F : out STD_LOGIC;
		Sig_H : out STD_LOGIC
    );
end diagram;

architecture Structural of diagram is
    signal temp1 : STD_LOGIC;
    signal temp2 : STD_LOGIC;
    signal temp3 : STD_LOGIC;
    signal temp4 : STD_LOGIC;

    component dff_hw is
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            d   : in  std_logic;
            q   : out std_logic
        );
    end component;

begin

    -- Instantiate 8 flip-flops
    dff1: dff_hw
        port map (
            clk => Clk_A, 
            rst => temp2,
            d   => Sig_A,
            q   => Sig_B
        );

    dff2: dff_hw
        port map (
            clk => Clk_A,
            rst => temp2,
            d   => Sig_C,
            q   => Sig_D
        );

    dff3: dff_hw
        port map (
            clk => Clk_A,
            rst => '1',
            d   => reset,
            q   => temp1
        );

    dff4: dff_hw
        port map (
            clk => Clk_A,
            rst => '1',
            d   => temp1,
            q   => temp2
        );

    dff5: dff_hw
        port map (
            clk => Clk_B,
            rst => temp4,
            d   => Sig_E,
            q   => Sig_F
        );

    dff6: dff_hw
        port map (
            clk => Clk_B,
            rst => temp4,
            d   => Sig_G,
            q   => Sig_H
        );

    dff7: dff_hw
        port map (
            clk => Clk_B,
            rst => '1',
            d   => reset,
            q   => temp3
        );

    dff8: dff_hw 
        port map (
            clk => Clk_B,
            rst => '1',
            d   => temp3,
            q   => temp4
        );

end Structural;
