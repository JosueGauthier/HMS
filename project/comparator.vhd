LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY cmprtr4b IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        aeqbout, agtbout, altbout : OUT STD_LOGIC);
END cmprtr4b;
ARCHITECTURE archi OF cmprtr4b IS
BEGIN
    PROCESS (A, B) IS
    BEGIN
        IF (A = B) THEN
            aeqbout <= '1';
            agtbout <= '0';
            altbout <= '0';
        ELSIF A > B THEN
            aeqbout <= '0';
            agtbout <= '1';
            altbout <= '0';
        ELSE
            aeqbout <= '0';
            agtbout <= '0';
            altbout <= '1';
        END IF;
    END PROCESS;
END archi;