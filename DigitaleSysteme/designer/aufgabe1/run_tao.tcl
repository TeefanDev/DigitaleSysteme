set_device -family {SmartFusion2} -die {M2S005} -speed {STD}
read_vhdl -mode vhdl_2008 {C:\Users\stefa\Desktop\A_Stefan\HTWG\7.Semester\DigitaleSysteme\MeineUebungen\DigitaleSysteme\Aufgabe1\hex4x7seg.vhd}
read_vhdl -mode vhdl_2008 {C:\Users\stefa\Desktop\A_Stefan\HTWG\7.Semester\DigitaleSysteme\MeineUebungen\DigitaleSysteme\Aufgabe1\aufgabe1.vhd}
set_top_level {aufgabe1}
map_netlist
check_constraints {C:\Users\stefa\Desktop\A_Stefan\HTWG\7.Semester\DigitaleSysteme\MeineUebungen\DigitaleSysteme\DigitaleSysteme\constraint\synthesis_sdc_errors.log}
write_fdc {C:\Users\stefa\Desktop\A_Stefan\HTWG\7.Semester\DigitaleSysteme\MeineUebungen\DigitaleSysteme\DigitaleSysteme\designer\aufgabe1\synthesis.fdc}
