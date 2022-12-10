library ieee;
use ieee.std_logic_1164.all;

entity Debouncer_tb is
end Debouncer_tb;

architecture tb of Debouncer_tb is

    component Debouncer
        port (clk       : in std_logic;
              button    : in std_logic;
              debounced : out std_logic);
    end component;

    signal clk       : std_logic;
    signal button    : std_logic;
    signal debounced : std_logic;

    constant clock_period: time := 10 ns;
    signal stop_the_clock: boolean;

begin

    dut : Debouncer
    port map (clk       => clk,
              button    => button,
              debounced => debounced);

    stimuli : process
    begin
        button <= '0';

        wait for 3 * clock_period;
        button <= '1';
        wait for clock_period;
        button <= '0';
        wait for clock_period;
        button <= '1';
        wait for clock_period;
        button <= '0';
        wait for clock_period;
        button <= '1';
        wait for 2ms;
        button <= '0';
        wait for clock_period;
        button <= '1';
        wait for clock_period;
        button <= '0';
        wait for clock_period;
        button <= '1';
        wait for clock_period;
        button <= '0';                                                
       
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