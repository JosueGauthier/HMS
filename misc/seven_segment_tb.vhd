library ieee;
use ieee.std_logic_1164.all;

entity BCDto7Seg_tb is
end BCDto7Seg_tb;

architecture tb of BCDto7Seg_tb is

    component BCDto7Seg
        port (BCD      : in std_logic_vector (3 downto 0);
              Segments : out std_logic_vector (6 downto 0));
    end component;

    signal BCD      : std_logic_vector (3 downto 0);
    signal Segments : std_logic_vector (6 downto 0);

begin

    dut : BCDto7Seg
    port map (BCD      => BCD,
              Segments => Segments);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        
        BCD <= "0000";
        wait for 100ns;
        if(Segments/="1111110") then
            assert false report "Segments should be 1111110 for BCD=0000" severity error;
        end if;     
        
        BCD <= "0001";
        wait for 100ns;
        if(Segments/="1100000") then
            assert false report "Segments should be 1100000 for BCD=0001" severity error;
        end if;            
        
        BCD <= "0010";
        wait for 100ns;
        if(Segments/="0011011") then
            assert false report "Segments should be 0011011 for BCD=0010" severity error;
        end if;             

        BCD <= "0011";
        wait for 100ns;
        if(Segments/="1110010") then
            assert false report "Segments should be 1110010 for BCD=0011" severity error;
        end if;
        
        BCD <= "0100";
        wait for 100ns;
        if(Segments/="1100101") then
            assert false report "Segments should be 1100101 for BCD=0100" severity error;
        end if;     
        
        BCD <= "0101";
        wait for 100ns;
        if(Segments/="0110110") then
            assert false report "Segments should be 0110110 for BCD=0101" severity error;
        end if;            
        
        BCD <= "0110";
        wait for 100ns;
        if(Segments/="0111110") then
            assert false report "Segments should be 0111110 for BCD=0110" severity error;
        end if;             

        BCD <= "0111";
        wait for 100ns;
        if(Segments/="1100011") then
            assert false report "Segments should be 1100011 for BCD=0111" severity error;
        end if;        
        
        BCD <= "1000";
        wait for 100ns;
        if(Segments/="1111111") then
            assert false report "Segments should be 1111111 for BCD=1000" severity error;
        end if;             

        BCD <= "1001";
        wait for 100ns;
        if(Segments/="1100111") then
            assert false report "Segments should be 1100111 for BCD=1001" severity error;
        end if;     
             
        -- EDIT Add stimuli here

        wait;
    end process;

end tb;