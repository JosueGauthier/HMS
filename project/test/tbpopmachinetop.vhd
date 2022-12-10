-- half_adder_simple_tb.vhd

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY PopMachine_TopM_tb IS
END PopMachine_TopM_tb;

ARCHITECTURE tb OF PopMachine_TopM_tb IS

    COMPONENT PopMachine_TopM IS
        PORT (
            clk : IN STD_LOGIC;
            clr : IN STD_LOGIC;
            coin_sensor : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            coin_ack, coin_retired, pop_retired : IN STD_LOGIC;
            drop_pop, return_nickel : OUT STD_LOGIC;
            segments : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            segments_sel : OUT STD_LOGIC_VECTOR(5 DOWNTO 0));
    END COMPONENT;

    SIGNAL clk : IN STD_LOGIC;

    CONSTANT clock_period : TIME := 10 ns;
    SIGNAL stop_the_clock : BOOLEAN;

    SIGNAL clr : IN STD_LOGIC;
    SIGNAL coin_sensor : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL coin_ack : IN STD_LOGIC;
    SIGNAL coin_retired : IN STD_LOGIC;
    SIGNAL pop_retired : IN STD_LOGIC;
    SIGNAL drop_pop : OUT STD_LOGIC;
    SIGNAL return_nickel : OUT STD_LOGIC;
    SIGNAL segments : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL segments_sel : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);

BEGIN
    -- connecting testbench signals with half_adder.vhd
    UUT : ENTITY PopMachine_TopM PORT MAP (
        clk => clk,
        clr => clr,
        coin_sensor => coin_sensor,
        coin_ack => coin_ack,
        coin_retired => coin_retired,
        pop_retired => pop_retired,
        drop_pop => drop_pop,
        return_nickel => return_nickel,
        segments => segments,
        segments_sel => segments_sel,
        );

    stimuli : PROCESS
    BEGIN
        clr <= '0';
        coin_sensor <= "00";
        coin_ack <= '0';
        coin_retired <= '0';
        pop_retired <= '0';

        WAIT FOR 30 * clock_period;
        clr <= '1';
        WAIT FOR 30 * clock_period;
        clr <= '0';

        WAIT FOR 30 * clock_period;
        coin_sensor <= "00";
        WAIT FOR 30 * clock_period;
        coin_sensor <= "00";
        WAIT FOR 30 * clock_period;
        coin_sensor <= "00";
        WAIT FOR 30 * clock_period;
        coin_sensor <= "01";
        WAIT FOR 30 * clock_period;
        coin_sensor <= "10";
        WAIT FOR 30 * clock_period;
        coin_sensor <= "11";

        WAIT FOR 30 * clock_period;
        coin_ack <= '1';

        WAIT FOR 30 * clock_period;
        pop_retired <= '1';

        WAIT FOR 30 * clock_period;
        coin_ack <= '0';
        pop_retired <= '0';

        WAIT FOR 30 * clock_period;
        coin_sensor <= "10";
        WAIT FOR 30 * clock_period;
        coin_sensor <= "11";

        WAIT FOR 30 * clock_period;
        coin_retired <= '1';

        WAIT FOR 30 * clock_period;
        coin_retired <= '0';

        WAIT FOR 30 * clock_period;
        coin_sensor <= "10";
        WAIT FOR 30 * clock_period;
        coin_sensor <= "11";
    
        WAIT FOR 30 * clock_period;
        clr <= '1';
        WAIT FOR 30 * clock_period;
        clr <= '0';
        WAIT;
    END PROCESS;

    clocking : PROCESS
    BEGIN
        WHILE NOT stop_the_clock LOOP
            clk <= '1', '0' AFTER clock_period / 2;
            WAIT FOR clock_period;
        END LOOP;
        WAIT;
    END PROCESS;

END tb;