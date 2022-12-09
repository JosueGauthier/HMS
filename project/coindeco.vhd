LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Coin_Deco IS
    PORT (
        coin_in : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        deco_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
END Coin_Deco;

ARCHITECTURE Behavioral OF Coin_Deco IS

BEGIN

    WITH coin_in SELECT deco_out <=
        "0001" WHEN "00",
        "0010" WHEN "01",
        "0100" WHEN "10",
        "1010" WHEN "11",
        "1111" WHEN OTHERS;

END Behavioral;