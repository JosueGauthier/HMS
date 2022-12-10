library ieee;
use ieee.std_logic_1164.all;

entity popfsm_tb is
end popfsm_tb;

architecture tb of popfsm_tb is

    component PopMachine_Controller_FSM is
    port (
        clk : in std_logic;
        clr : in std_logic;
        coin_ack, coin_retired, seq30, sgt30, pop_retired : in std_logic;
        clr_cnt, change_dec, drop_pop, return_nickel, add_cnt, ld_cnt : out std_logic
    );
    end component;

    signal clk       : std_logic;
    signal clr    : std_logic;
    signal coin_ack, coin_retired, seq30, sgt30, pop_retired : std_logic;
    signal clr_cnt, change_dec, drop_pop, return_nickel, add_cnt, ld_cnt : std_logic;

    constant clock_period: time := 10 ns;
    signal stop_the_clock: boolean;

begin

    dut : PopMachine_Controller_FSM
    port map (
        clk    => clk,
        clr    => clr,
        coin_ack => coin_ack, 
        coin_retired => coin_retired,
        seq30 => seq30,
        sgt30 => sgt30,
        pop_retired => pop_retired,
        clr_cnt => clr_cnt,
        change_dec => change_dec,
        drop_pop => drop_pop,
        return_nickel => return_nickel,
        add_cnt => add_cnt,
        ld_cnt => ld_cnt
    );

    stimuli : process
    begin
        clr <= '0';
        coin_ack <= '0';
        coin_retired <= '0';
        seq30 <= '0';
        sgt30 <= '0';
        pop_retired <= '0';
            wait for 30 * clock_period;
        clr <= '1';
            wait for 30 * clock_period;
        clr <= '0';
            wait for clock_period;
        coin_ack <= '1';
            wait for 20*clock_period;
        coin_ack <= '0';
            wait for 20*clock_period;
        coin_ack <= '1';
            wait for 20*clock_period;
        coin_ack <= '0';
            wait for 20*clock_period;
        coin_ack <= '1';
        sgt30 <= '1';
            wait for 20*clock_period;
        coin_ack <= '0';
            wait for 20*clock_period;
        coin_retired <= '1';
            wait for 20*clock_period;
        coin_retired <= '0';
            wait for 20*clock_period;
        coin_retired <= '1';
            wait for 20*clock_period;
        coin_retired <= '0';
            wait for 20*clock_period;
        coin_retired <= '1';
            wait for 20*clock_period;
        coin_retired <= '0';
        seq30 <= '1';
        sgt30 <= '0';
            wait for 20*clock_period;
        pop_retired <= '1';
            wait for 20*clock_period;
        seq30 <= '0';
        pop_retired <= '0';
            wait for 20*clock_period;
        wait;
    end process;
    
  clocking: process
    begin
      while not stop_the_clock loop
        clk <= '1', '0' after clock_period / 2;
        wait for clock_period;
      end loop;
      wait;
    end process;    

end tb;

