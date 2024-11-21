LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY FSM IS
    PORT (
        input  : IN STD_LOGIC;       
        reset  : IN STD_LOGIC;
        clock  : IN STD_LOGIC;
        output : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END FSM;

ARCHITECTURE behavior OF FSM IS
    TYPE state IS (state0, state1, state2, state3);
    SIGNAL pr_state : state;
BEGIN
    PROCESS (reset, clock)
    BEGIN
        IF (reset = '1') THEN
            pr_state <= state0;
            output <= "00";
        ELSIF rising_edge(clock) THEN
            CASE pr_state IS
                WHEN state0 =>
                    output <= "00";
                    IF (input = '1') THEN
                        pr_state <= state1;
                    END IF;

                WHEN state1 =>
                    output <= "01";
                    IF (input = '1') THEN
                        pr_state <= state2;
                    END IF;

                WHEN state2 =>
                    output <= "10";
                    IF (input = '1') THEN
                        pr_state <= state3;
                    END IF;

                WHEN state3 =>
                    output <= "11";
                    IF (input = '1') THEN
                        pr_state <= state0;
                    END IF;

                WHEN OTHERS =>
                    pr_state <= state0;
                    output <= "00";
            END CASE;
        END IF;
    END PROCESS;
END behavior;