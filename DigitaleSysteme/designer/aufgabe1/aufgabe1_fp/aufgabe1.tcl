open_project -project {C:\Users\stefa\Desktop\A_Stefan\HTWG\7.Semester\DigitaleSysteme\MeineUebungen\DigitaleSysteme\DigitaleSysteme\designer\aufgabe1\aufgabe1_fp\aufgabe1.pro}\
         -connect_programmers {FALSE}
load_programming_data \
    -name {M2S005} \
    -fpga {C:\Users\stefa\Desktop\A_Stefan\HTWG\7.Semester\DigitaleSysteme\MeineUebungen\DigitaleSysteme\DigitaleSysteme\designer\aufgabe1\aufgabe1.map} \
    -header {C:\Users\stefa\Desktop\A_Stefan\HTWG\7.Semester\DigitaleSysteme\MeineUebungen\DigitaleSysteme\DigitaleSysteme\designer\aufgabe1\aufgabe1.hdr} \
    -spm {C:\Users\stefa\Desktop\A_Stefan\HTWG\7.Semester\DigitaleSysteme\MeineUebungen\DigitaleSysteme\DigitaleSysteme\designer\aufgabe1\aufgabe1.spm} \
    -dca {C:\Users\stefa\Desktop\A_Stefan\HTWG\7.Semester\DigitaleSysteme\MeineUebungen\DigitaleSysteme\DigitaleSysteme\designer\aufgabe1\aufgabe1.dca}
export_single_ppd \
    -name {M2S005} \
    -file {C:\Users\stefa\Desktop\A_Stefan\HTWG\7.Semester\DigitaleSysteme\MeineUebungen\DigitaleSysteme\DigitaleSysteme\designer\aufgabe1\aufgabe1.ppd}

save_project
close_project
