----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2022 03:19:56 PM
-- Design Name: 
-- Module Name: PopMachine_TopM2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY PopMachine_TopM IS
    PORT (
        clk : IN STD_LOGIC;
        clr : IN STD_LOGIC;
        coin_sensor : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        coin_ack, coin_retired, pop_retired : IN STD_LOGIC;
        drop_pop, return_nickel : OUT STD_LOGIC;
        segments : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        segments_sel : OUT STD_LOGIC_VECTOR(5 DOWNTO 0));
END PopMachine_TopM;

ARCHITECTURE behavioral OF PopMachine_TopM IS

    CONSTANT price : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

    -- comparator -> controller fsm
    SIGNAL AEQBOUT_Sgt30 : STD_LOGIC;
    SIGNAL AGTBOUT_Seq30 : STD_LOGIC;
    -- controller fsm -> up down counter 74LS69 
    SIGNAL LD_CNT__LD : STD_LOGIC;
    -- controller fsm -> 4 bits ripple adder
    SIGNAL add_CNT__en : STD_LOGIC;
    -- controller fsm -> 7 seg driver
    SIGNAL current_state__SS3 : STD_LOGIC;
    -- controller fsm -> XOR counter
    SIGNAL clr_cnt__XOR_clr : STD_LOGIC;
    -- controller fsm -> XOR counter
    SIGNAL dec_change__XOR : STD_LOGIC;
    -- counter -> 7 seg
    SIGNAL Q__SS0_B_A : STD_LOGIC_VECTOR(3 DOWNTO 0);
    -- ripple adder -> 7 seg + counter
    SIGNAL sum__SS1_D : STD_LOGIC_VECTOR(3 DOWNTO 0);
    -- coin_deco -> ripple adder
    SIGNAL coin_deco__A : STD_LOGIC_VECTOR(3 DOWNTO 0);
    -- ripple adder -> up down counter 74LS69 
    SIGNAL SUM__D : STD_LOGIC_VECTOR(3 DOWNTO 0);

    -- xor_clr -> up down counter 74LS69 
    SIGNAL xor_clr_out__clr : STD_LOGIC;
    -- xorDown -> up down counter 74LS69 
    SIGNAL xorDown_out__en : STD_LOGIC;

    COMPONENT PopMachine_Controller_FSM IS
        PORT (
            clk : IN STD_LOGIC;
            clr : IN STD_LOGIC;
            coin_ack, coin_retired, seq30, sgt30, pop_retired : IN STD_LOGIC;
            clr_cnt, change_dec, drop_pop, return_nickel, add_cnt, ld_cnt : OUT STD_LOGIC;
            current_state : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT cmprtr4b IS
        PORT (
            A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            aeqbout, agtbout, altbout : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT ripple_adder IS
        GENERIC (WIDTH : POSITIVE := 8);
        PORT (
            A, B : IN STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
            SUM : OUT STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
            COUT : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT xorDown IS
        PORT (
            xorDown_in1, xorDown_in2 : IN STD_LOGIC;
            xorDown_out : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT xor_clr IS
        PORT (
            xor_clr_in1, xor_clr_in2 : IN STD_LOGIC;
            xor_clr_out : OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT up_dn_counter_top IS
        GENERIC (
            n : POSITIVE := 4
        );
        PORT (
            CLK : IN STD_LOGIC; -- input clock
            -- input
            updown, clr, ld, en : IN STD_LOGIC; -- inputs 
            D : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0); -- seting input
            -- outputs
            Q : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0); -- counter
            overflow : OUT STD_LOGIC); -- OVERFLOW
    END COMPONENT;
    COMPONENT SevenSegment_driver IS
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
    END COMPONENT;

    COMPONENT Coin_Deco IS
        PORT (
            coin_in : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            deco_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
    END COMPONENT;

BEGIN

    fsm : PopMachine_Controller_FSM
    PORT MAP(
        clk => clk,
        clr => clr,
        coin_ack => coin_ack,
        coin_retired => coin_retired,
        pop_retired => pop_retired,
        seq30 => AEQBOUT_Sgt30,
        sgt30 => AGTBOUT_Seq30,
        drop_pop => drop_pop,
        return_nickel => return_nickel,
        clr_cnt => clr_cnt__XOR_clr,
        change_dec => dec_change__XOR,
        current_state => current_state__SS3,
        add_cnt => add_CNT__en,
        ld_cnt => LD_CNT__LD,
    );

    SevenSeg : SevenSegment_driver
    PORT MAP(
        clk => clk,
        rst => clr, --! ??
        SS0 => Q__SS0_B_A,
        SS1 => sum__SS1_D,
        SS2 => price,
        SS3 => current_state__SS3,
        SS4 => '0', --! ?
        SS5 => '0', --! ?
        Sel => segments_sel,
        SSO => segments,

    );

    xorDown_1 : xorDown
    PORT MAP(
        xorDown_in1 => dec_change__XOR,
        xorDown_in2 => LD_CNT__LD,
        xorDown_out => xorDown_out__en,
    );

    xorClr : xor_clr
    PORT MAP(

        xor_clr_in1 => clr_cnt__XOR_clr,
        xor_clr_in2 => clr,
        xor_clr_out => xor_clr_out__clr,
    );

    comparator4b : cmprtr4b
    PORT MAP(
        A => Q__SS0_B_A,
        B => price,
        aeqbout => AEQBOUT_Sgt30,
        agtbout => AGTBOUT_Seq30,
        altbout => '0', --! ???? 
    );

    rippleAdder : ripple_adder
    PORT MAP(
        A => coin_deco__A,
        B => Q__SS0_B_A,
        SUM => SUM__D,
        COUT => '0', --! ???? 
    );

    coinDeco : Coin_Deco
    PORT MAP(
        coin_in => coin_sensor,
        deco_out => coin_deco__A,
    );

    updownCounter : up_dn_counter_top
    PORT MAP(
        CLK => clk,
        updown => '1',
        clr => xor_clr_out__clr,
        ld => LD_CNT__LD,
        en => xorDown_out__en,
        D => SUM__D,
        Q => Q__SS0_B_A,
        overflow => '0', --! ???? 
    );

END ARCHITECTURE behavioral;