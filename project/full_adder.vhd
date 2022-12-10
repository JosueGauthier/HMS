library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
  port(A, B, CIN: in  std_logic;
       SUM, COUT: out std_logic);
end full_adder;

architecture structural of full_adder is

component half_adder
  port(A,   B:     in  std_logic;
       SUM, CARRY: out std_logic);
end component;

component or2
port (in1,in2:  in std_logic; 
      or_out: out std_logic);
end component;

signal U0_CARRY, U0_SUM, U1_CARRY: std_logic;

begin

  U0: half_adder port map (A => A,      B => B,   SUM => U0_SUM, CARRY => U0_CARRY);
  U1: half_adder port map (A => U0_SUM, B => CIN, SUM => SUM,    CARRY => U1_CARRY);

  U2: or2 port map (in1 => U0_CARRY, in2 => U1_CARRY, or_out => COUT);
  
end structural;