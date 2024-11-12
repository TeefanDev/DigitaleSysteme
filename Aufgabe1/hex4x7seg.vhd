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
  signal t                  : std_logic;
  signal modulo_4_counter   : std_logic_vector(1 downto 0)  := "00";
  signal modulo_214_counter : std_logic_vector(13 downto 0) := (others => '0');
  signal seg_sel            : std_logic_vector(3 downto 0);
  signal en: std_logic := '0';

begin

  -- Modulo-2**14-Zaehler

  process (clk, rst)
  begin
    if rst = RSTDEF then
      modulo_214_counter <= (others => '0');
      en                 <= '0';
    elsif rising_edge(clk) then
      if modulo_214_counter = "11111111111111" then
        modulo_214_counter <= (others => '0');
        en                 <= not en; -- Toggle en signal for modulo-4 counter
      else
        modulo_214_counter <= modulo_214_counter + 1;
      end if;
    end if;
  end process;

  -- Modulo-4-Zaehler
  process (clk, rst)
  begin
    if rst = RSTDEF then
      modulo_4_counter <= "00";
    elsif rising_edge(clk) and en = '1' then
      if modulo_4_counter = "11" then
        modulo_4_counter <= "00";
      else
        modulo_4_counter <= modulo_4_counter + 1;
      end if;
    end if;
  end process;

  -- 1-aus-4-Dekoder als Phasengenerator

  process (rst, modulo_4_counter)
  begin
    ena <= "0001" when modulo_4_counter = "00" else
      "0010" when modulo_4_counter = "01" else
      "0100" when modulo_4_counter = "10" else
      "1000";
  end process;

  -- 1-aus-4-Multiplexer
  process (modulo_4_counter)
  begin
    if modulo_4_counter = "00" then
      t <= dpin(0);
    elsif modulo_4_counter = "01" then
      t <= dpin(1);
    elsif modulo_4_counter = "10" then
      t <= dpin(2);
    else
      t <= dpin(3);
    end if;

    dp <= t;
  end process;

  -- 7-aus-4-Dekoder
  with seg_sel select
    seg <= "1111110" when "0000",
    "0000110" when "0001",
    "1101101" when "0010",
    "1111001" when "0011",
    "0110011" when "0100",
    "1011011" when "0101",
    "1011111" when "0110",
    "1110000" when "0111",
    "1111111" when "1000",
    "1111011" when "1001",
    "1110111" when "1010",
    "0011111" when "1011",
    "1001110" when "1100",
    "0111101" when "1101",
    "1001111" when "1110",
    "1000111" when others;

  -- 1-aus-4 4 Bit-Multiplexer

  with modulo_4_counter select
    seg_sel <= data(3 downto 0) when "00", -- rechte Anzeige
    data(7 downto 4) when "01", -- zweite von rechts
    data(11 downto 8) when "10", -- zweite von links
    data(15 downto 12) when others; -- linke Anzeige

end struktur;