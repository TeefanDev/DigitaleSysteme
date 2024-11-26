library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity hex4x7seg is
  generic
    (RSTDEF : std_logic := '0');
  port
  (
    rst  : in std_logic; -- reset,           active RSTDEF
    clk  : in std_logic; -- clock,           rising edge
    data : in std_logic_vector(15 downto 0); -- data input,      active high
    dpin : in std_logic_vector(3 downto 0); -- 4 decimal point, active high
    ena  : out std_logic_vector(3 downto 0); -- 4 digit enable  signals,                active high
    seg  : out std_logic_vector(7 downto 1); -- 7 connections to seven-segment display, active high
    dp   : out std_logic); -- decimal point output,                   active high
end hex4x7seg;

architecture struktur of hex4x7seg is
    -- Definition of used signals and constants
    constant RES: std_logic_vector(13 downto 0) := (OTHERS => '1');
    signal reg: std_logic_vector(13 downto 0) := (OTHERS => '1');
    signal strb: std_logic := '0';
    signal sel: std_logic_vector(1 downto 0) := "00";
    signal cc: std_logic_vector(3 downto 0);
    signal seg_sel: std_logic_vector(3 downto 0);


BEGIN
    -- Modulo-2^14-Counter
    p1: process (rst, clk) is
    begin
        if rst = RSTDEF then
            strb <= '0';
            reg <= RES;
        elsif rising_edge(clk) then
            strb <= '0';
            if reg = RES then
                strb <= '1';
            end if;
            reg <= reg(12 downto 0) & (reg(13) xor reg(7));
        end if;
    end process;

    -- Modulo-4 Counter
    p2: process (rst, clk) is
    begin
        if rst = RSTDEF then
            sel <= "00";
        elsif rising_edge(clk) then
            if strb = '1' then
                sel <= sel + 1;
            end if;
        end if;
    end process;

    -- 1-aus-4-Dekoder als Phasengenerator
    with sel select
        cc <= "0001" when "00",
              "0010" when "01",
              "0100" when "10",
              "1000" when others;

    ena <= cc when rst /= RSTDEF else (others => '0');

    -- 1-aus-4-Multiplexer
    with sel select
        dp <= dpin(0) when "00",
              dpin(1) when "01",
              dpin(2) when "10",
              dpin(3) when others;

    -- 1-aus-4-Bit-Multiplexer
    with sel select
        seg_sel <=  data( 3 downto 0 ) when "00",        -- right
                    data( 7 downto 4 ) when "01",        -- second from right
                    data(11 downto 8 ) when "10",        -- second from left
                    data(15 downto 12) when others;      -- left

    -- 7-aus-4-Dekoder
    with seg_sel select
    seg <=  "0111111" WHEN "0000",  -- 0
            "0000110" WHEN "0001",  -- 1
            "1011011" WHEN "0010",  -- 2
            "1001111" WHEN "0011",  -- 3
            "1100110" WHEN "0100",  -- 4
            "1101101" WHEN "0101",  -- 5
            "1111101" WHEN "0110",  -- 6
            "0000111" WHEN "0111",  -- 7
            "1111111" WHEN "1000",  -- 8
            "1101111" WHEN "1001",  -- 9
            "1110111" WHEN "1010",  -- A
            "1111100" WHEN "1011",  -- B
            "0111001" WHEN "1100",  -- C
            "1011110" WHEN "1101",  -- D
            "1111001" WHEN "1110",  -- E
            "1110001" WHEN "1111",  -- F
            "0000000" WHEN OTHERS;  -- default  
END struktur;
