library ieee;
use ieee.std_logic_1164.all;

entity and2 IS
port (in1,in2: in  std_logic; 
      and_out: out std_logic);
end and2;

architecture structural of and2 is
begin    
    and_out <= in1 and in2;    
end structural;