library ieee;
use ieee.std_logic_1164.all;

entity ripple_adder is
    generic(WIDTH : positive := 8);
    port(
        en :in std_logic;
        A, B: in  std_logic_vector(WIDTH-1 downto 0);
        SUM: out std_logic_vector(WIDTH-1 downto 0);
        COUT: out std_logic);
end ripple_adder;

architecture structural of ripple_adder is

    component full_adder
        port(

            en :in std_logic;
            A, B, CIN: in  std_logic;
            SUM, COUT: out std_logic);
    end component;

    signal C0 : std_logic_vector(WIDTH-1 downto 0);

begin

    reg: FOR i in WIDTH downto 0 generate

        reg_begin : if i = 0 generate
            FA : full_adder
                port map (en=> en, A => A(i), B => B(i), CIN => '0', SUM => SUM(i), COUT => C0(i));
        end generate;

        reg_middle : if i > 0 and i < WIDTH-1 generate
            FA : full_adder
                port map (en=> en,A => A(i), B => B(i), CIN => C0(i-1), SUM => SUM(i), COUT => C0(i));
        end generate;

        reg_end : if I = WIDTH-1 generate
            FA : full_adder
                port map (en=> en,A => A(i), B => B(i), CIN => C0(i-1), SUM => SUM(i), COUT => COUT);
        end generate;

    end generate;

end structural;
