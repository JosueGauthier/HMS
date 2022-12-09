LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY xorDown IS
    PORT (
        xorDown_in1, xorDown_in2 : IN STD_LOGIC;
        xorDown_out : OUT STD_LOGIC);
END xorDown;

ARCHITECTURE structural OF xorDown IS
BEGIN
    xorDown_out <= xorDown_in1 XOR xorDown_in2;
END structural;