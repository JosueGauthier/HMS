LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xor_clr IS
    PORT (
        xor_clr_in1, xor_clr_in2 : IN STD_LOGIC;
        xor_clr_out : OUT STD_LOGIC);
END xor_clr;

ARCHITECTURE structural OF xor_clr IS
BEGIN
    xor_clr_out <= xor_clr_in1 XOR xor_clr_in2;
END structural;