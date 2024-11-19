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

    CONSTANT RES:   std_logic_vector := "11111111111111";
    SIGNAL   reg:   std_logic_vector(13 DOWNTO 0);
    SIGNAL strb:    std_logic;
    SIGNAL sel:     std_logic_vector(1 DOWNTO 0);
    SIGNAL cc:      std_logic_vector(3 DOWNTO 0);
    SIGNAL seg_sel: std_logic_vector(3 DOWNTO 0);

BEGIN
    -- Modulo-2^14-Counter
    p1: PROCESS (rst, clk) IS
    BEGIN
        IF rst=RSTDEF THEN
            strb    <= '0';
            reg     <= (OTHERS => '1');
        ELSIF rising_edge(clk) THEN
            
            strb <= '0';

            IF reg=RES THEN
                strb <= '1';                    
            END IF;

            reg(13 DOWNTO 9)    <= reg(12 DOWNTO 8);
            reg(8)              <= reg(7) XOR reg(13);
            reg(7)              <= reg(6);
            reg(6)              <= reg(5) XOR reg(13);
            reg(5 DOWNTO 2)     <= reg(4 DOWNTO 1);
            reg(1)              <= reg(0) XOR reg(13);
            reg(0)              <= reg(13);
            
        END IF;
    END PROCESS;
    
   
    -- Modulo-4-Counter
    p2: PROCESS (rst, clk) IS 
    BEGIN
    
        IF rst=RSTDEF THEN
            sel <= "00";

        ELSIF rising_edge(clk) THEN
            IF sel="11" THEN
                IF strb='1' THEN
                    sel <= "00";
                END IF;
            ELSE
                sel <= sel + strb;
            END IF;
        END IF;

    END PROCESS;
    

    -- 1-aus-4-Dekoder als Phasengenerator
    WITH sel SELECT
        cc <=   "0001" WHEN "00",
                "0010" WHEN "01",
                "0100" WHEN "10",
                "1000" WHEN "11",
                "1111" WHEN OTHERS;
        ena <= cc   WHEN rst/=RSTDEF
                    ELSE (OTHERS => '0');
    
       
    -- 1-aus-4-Multiplexer
    WITH sel SELECT
        dp <=   dpin(0) WHEN "00",
                dpin(1) WHEN "01",
                dpin(2) WHEN "10",
                dpin(3) WHEN OTHERS;


    -- 1-aus-4-Bit-Multiplexer
    WITH sel SELECT
		seg_sel <=  data( 3 downto 0 ) when "00",        -- right
                    data( 7 downto 4 ) when "01",        -- second from right
                    data(11 downto 8 ) when "10",        -- second from left
                    data(15 downto 12) when others;      -- left
        

    -- 7-aus-4-Dekoder
    WITH seg_sel SELECT
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