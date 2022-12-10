library ieee;
use ieee.std_logic_1164.all;

entity or2 IS
    port (in1,in2: in  std_logic; 
          or_out:  out std_logic);
end or2;

architecture structural of or2 is
begin    
    or_out <= in1 or in2;    
end structural;
