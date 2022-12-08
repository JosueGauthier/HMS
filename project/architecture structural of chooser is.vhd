architecture structural of chooser is

signal -- signals here
signal mux_IN0 : std_logic_vector(4 downto 0);
signal mux_IN1 : std_logic_vector(4 downto 0);
signal mux_IN2 : std_logic_vector(4 downto 0);
signal mux_SEL : std_logic_vector(1 downto 0);
signal mux_O   : std_logic_vector(4 downto 0);

-- copy of the inputs/outputs in the entity declaration in the file above
component MUX3x5 is
    port(
        IN0 : in std_logic_vector(4 downto 0);
        IN1 : in std_logic_vector(4 downto 0);
        IN2 : in std_logic_vector(4 downto 0);
        SEL : in std_logic_vector(1 downto 0);
        O   : out std_logic_vector(4 downto 0)
    );
end component;



component registry is
    port(
         -- some signals here
         TS : out std_logic_vector(4 downto 0)
    );

begin

some_name: registry
    port map(
            TS => mux_in1,    -- use , and not ;
            -- other maps
);

mux: MUX3x5
port map(
    IN0 => mux_in0,
    IN1 => mux_in1,
    IN2 => mux_in2,
    SEL => mux_sel,
    O   => mux_o
);

end architecture;