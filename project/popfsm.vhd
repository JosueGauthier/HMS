LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY PopMachine_Controller_FSM IS
    PORT (
        clk : IN STD_LOGIC;
        clr : IN STD_LOGIC;
        coin_ack, coin_retired, seq30, sgt30, pop_retired : IN STD_LOGIC;
        clr_cnt, change_dec, drop_pop, return_nickel, add_cnt, ld_cnt : OUT STD_LOGIC;
        current_state : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END PopMachine_Controller_FSM;

ARCHITECTURE rtl OF PopMachine_Controller_FSM IS

    -- Enumerated type declaration and state signal declaration
    TYPE t_State IS (idle, state1, state2, state3, state4, state5,
        state6, state7, state8);
    SIGNAL State, NextState : t_State;

BEGIN

    next_process : PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            State <= NextState;
        END IF;
    END PROCESS next_process;

    state_process : PROCESS (clk, clr)
    BEGIN
        IF clr = '1' THEN
            NextState <= idle;
        ELSIF rising_edge(clk) THEN
            CASE State IS
                WHEN idle =>
                    IF coin_ack = '1' THEN
                        NextState <= state7;
                    ELSE
                        NextState <= idle;
                    END IF;

                WHEN state7 =>
                    NextState <= state1;

                WHEN state1 =>
                    IF (coin_ack = '0') THEN
                        IF (sgt30 = '1') THEN
                            NextState <= state2;
                        ELSIF (seq30 = '1') THEN
                            NextState <= state5;
                        ELSE
                            NextState <= idle;
                        END IF;
                    ELSE
                        NextState <= state1;
                    END IF;

                WHEN state2 =>
                    IF seq30 = '1' THEN
                        NextState <= state5;
                    ELSIF sgt30 = '1' THEN
                        NextState <= state3;
                    ELSE
                        NextState <= state2;
                    END IF;

                WHEN state3 =>
                    IF coin_retired = '1' THEN
                        NextState <= state8;
                    ELSE
                        NextState <= state3;
                    END IF;

                WHEN state8 =>
                    NextState <= state4;

                WHEN state4 =>
                    IF coin_retired = '0' THEN
                        NextState <= state2;
                    ELSE
                        NextState <= state4;
                    END IF;

                WHEN state5 =>
                    IF pop_retired = '1' THEN
                        NextState <= state6;
                    ELSE
                        NextState <= state5;
                    END IF;

                WHEN state6 =>
                    NextState <= idle;

                WHEN OTHERS =>
                    NextState <= NextState;

            END CASE;
        END IF;
    END PROCESS state_process;

    output_process : PROCESS (State)
    BEGIN
        CASE State IS
            WHEN idle =>
                clr_cnt <= '0';
                change_dec <= '0';
                drop_pop <= '0';
                return_nickel <= '0';
                add_cnt <= '0';
                ld_cnt <= '0';

            WHEN state7 =>
                clr_cnt <= '0';
                change_dec <= '0';
                drop_pop <= '0';
                return_nickel <= '0';
                add_cnt <= '1';
                ld_cnt <= '0';

            WHEN state1 =>
                clr_cnt <= '0';
                change_dec <= '0';
                drop_pop <= '0';
                return_nickel <= '0';
                add_cnt <= '0';
                ld_cnt <= '1';

            WHEN state2 =>
                clr_cnt <= '0';
                change_dec <= '0';
                drop_pop <= '0';
                return_nickel <= '0';
                add_cnt <= '0';
                ld_cnt <= '0';

            WHEN state3 =>
                clr_cnt <= '0';
                change_dec <= '0';
                drop_pop <= '0';
                return_nickel <= '1';
                add_cnt <= '0';
                ld_cnt <= '0';

            WHEN state8 =>
                clr_cnt <= '0';
                change_dec <= '1';
                drop_pop <= '0';
                return_nickel <= '0';
                add_cnt <= '0';
                ld_cnt <= '0';

            WHEN state4 =>
                clr_cnt <= '0';
                change_dec <= '0';
                drop_pop <= '0';
                return_nickel <= '0';
                add_cnt <= '0';
                ld_cnt <= '0';

            WHEN state5 =>
                clr_cnt <= '0';
                change_dec <= '0';
                drop_pop <= '1';
                return_nickel <= '0';
                add_cnt <= '0';
                ld_cnt <= '0';

            WHEN state6 =>
                clr_cnt <= '1';
                change_dec <= '0';
                drop_pop <= '0';
                return_nickel <= '0';
                add_cnt <= '0';
                ld_cnt <= '0';

            WHEN OTHERS =>
                clr_cnt <= '0';
                change_dec <= '0';
                drop_pop <= '0';
                return_nickel <= '0';
                add_cnt <= '0';
                ld_cnt <= '0';

        END CASE;
    END PROCESS output_process;

    WITH State SELECT
        current_state <=
        "0000" WHEN idle,
        "0001" WHEN state1,
        "0010" WHEN state2,
        "0011" WHEN state3,
        "0100" WHEN state4,
        "0101" WHEN state5,
        "0110" WHEN state6,
        "0111" WHEN state7,
        "1000" WHEN state8,
        "1111" WHEN OTHERS;

END ARCHITECTURE rtl;