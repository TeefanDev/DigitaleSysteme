new_project \
         -name {aufgabe1} \
         -location {C:\Users\stefa\Desktop\A_Stefan\HTWG\7.Semester\DigitaleSysteme\MeineUebungen\DigitaleSysteme\DigitaleSysteme\designer\aufgabe1\aufgabe1_fp} \
         -mode {chain} \
         -connect_programmers {FALSE}
add_actel_device \
         -device {M2S005} \
         -name {M2S005}
enable_device \
         -name {M2S005} \
         -enable {TRUE}
save_project
close_project
