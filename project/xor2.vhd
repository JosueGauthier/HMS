library ieee;
use ieee.std_logic_1164.all;

entity xor2 IS
port (in1,in2: in  std_logic; 
      xor_out: out std_logic);
end xor2;

architecture structural of xor2 is
begin    
    xor_out <= in1 xor in2;    
end structural;