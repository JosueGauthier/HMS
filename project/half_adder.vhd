library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
port(A     : in std_logic;
     B     : in std_logic;
     SUM   : out std_logic;
     CARRY : out std_logic);
end half_adder;

architecture structural of half_adder is

component and2
port (in1,in2:  in std_logic; 
      and_out: out std_logic);
end component;

component xor2
port (in1,in2:  in std_logic; 
      xor_out: out std_logic);
end component;

begin

    -- Option 1: Using components
    U0: xor2 port map (in1 => A, in2 => B, xor_out => SUM);
    U1: and2 port map (in1 => A, in2 => B, and_out => CARRY);
  
  -- Option 2: Directly using logic operations
    --SUM <= A xor B;
    --CARRY <= A and B;

end structural;