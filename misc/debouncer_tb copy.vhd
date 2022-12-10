----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2022 03:34:02 PM
-- Design Name: 
-- Module Name: deb_teb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity deb_teb is
end deb_teb;

architecture Behavioral of deb_teb is


    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT debouncer
        PORT(
            clk : IN  std_logic;
            button : IN  std_logic;
            debounced : OUT  std_logic
        );
    END COMPONENT;

    signal clk_tb : std_logic :='0';
    signal button_tb : std_logic :='0';
    signal debounced_tb : std_logic;


    -- Clock period definitions
    constant clk_period : time := 20 ns;	-- 50MHz

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: debouncer PORT MAP (
            clk => clk_tb,
            button => button_tb,
            debounced => debounced_tb
        );

    -- Clock process definitions
    clk_process :process
    begin
        clk_tb <= '1';
        wait for clk_period/2;
        clk_tb <= '0';
        wait for clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin

        button_tb <= '0';
        wait for 200 ns;
        button_tb <= '1';
        wait for 200 ns;
        button_tb <= '0';
        wait for 10 ns;
        button_tb <= '1';
        wait for 10 ns;
        button_tb <= '0';
        wait for 10 ns;
        button_tb <= '1';
        wait for 10 ns;
        button_tb <= '0';
        wait for 10 ns;
        button_tb <= '1';
        wait for 10 ns;
        button_tb <= '0';
        
        wait;

    end process;





end Behavioral;
