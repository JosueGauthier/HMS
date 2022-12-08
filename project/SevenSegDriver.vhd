LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.functions.ALL;

ENTITY SevenSegment_driver IS
    GENERIC (
        Freq_in : POSITIVE := 100000000; -- 100 MHz
        Freq_refresh : POSITIVE := 1000 -- 1 kHz
    );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        SS0 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        SS1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        SS2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        SS3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        SS4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        SS5 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Sel : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        SSO : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END SevenSegment_driver;

ARCHITECTURE rtl OF SevenSegment_driver IS

    COMPONENT BCDto7Seg IS
        PORT (
            BCD : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            Segments : OUT STD_LOGIC_VECTOR (6 DOWNTO 0));
    END COMPONENT;

    COMPONENT sevenseg_mux IS
        PORT (
            A, B, C, D, E, F : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            S : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            Num_Out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            Cathode_Out : OUT STD_LOGIC_VECTOR(5 DOWNTO 0));
    END COMPONENT;

    CONSTANT counter_limit_int : INTEGER := Freq_in/Freq_refresh;
    CONSTANT counter_width : POSITIVE := log2(counter_limit_int);
    CONSTANT counter_limit : unsigned(counter_width - 1 DOWNTO 0) := to_unsigned(counter_limit_int, counter_width);

    SIGNAL counter_refresh : unsigned(counter_width - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL sel_flag : STD_LOGIC := '0';
    SIGNAL S : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL BCD : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
BEGIN

    -- generate refresh period of 10.5ms
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            counter_refresh <= (OTHERS => '0');
            sel_flag <= '0';
        ELSIF (rising_edge(clk)) THEN
            IF counter_refresh = counter_limit THEN
                counter_refresh <= (OTHERS => '0');
                sel_flag <= '1';
            ELSE
                counter_refresh <= counter_refresh + 1;
                sel_flag <= '0';
            END IF;
        END IF;
    END PROCESS;

    -- generate 6-to-1 MUX selector to generate anode activating signals for 6 LEDs 
    PROCESS (clk)
        VARIABLE S_var : unsigned(2 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        IF (rising_edge(clk)) THEN
            IF rst = '1' THEN
                S_var := (OTHERS => '0');
            ELSE
                IF sel_flag = '1' THEN
                    S_var := S_var + 1;
                    IF S_var = 7 THEN
                        S_var := (OTHERS => '0');
                    END IF;
                END IF;
            END IF;
            S <= STD_LOGIC_VECTOR(S_var);
        END IF;
    END PROCESS;

    sevenseg_mux_comp : sevenseg_mux
    PORT MAP(
        A => SS0, B => SS1, C => SS2, D => SS3, E => SS4, F => SS5,
        S => S,
        Num_Out => BCD,
        Cathode_Out => Sel
    );

    BCDto7Seg_comp : BCDto7Seg
    PORT MAP(
        BCD => BCD,
        Segments => SSO
    );

END ARCHITECTURE rtl;