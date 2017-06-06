#!bin/bash
cd ~/Desktop/Projekt/Genomi/PBSim
touch err.txt
rm $(find . -name stat.txt) 2> err.txt
rm err.txt
find "$(pwd)" -name *.f* > input.txt
while  read -r line
do  
    touch "${line%/*}"/output.txt
    echo ${line%/*} >> stat.txt
    echo $line
    time1=$(date +%s%3N)
    kraken --db ~/Desktop/Projekt/minikrakendb --quick --thread $1 $line 2> pomStat.txt > "${line%/*}"/pomOutput.txt
    time2=$(date +%s%3N)

    tail -n 2 pomStat.txt >> stat.txt

    kraken-translate --db ~/Desktop/Projekt/minikrakendb "${line%/*}"/pomOutput.txt > "${line%/*}"/output.txt

    IFS="/" read -a array <<< $line
    numName1=$((${#array[@]}-7))
    numName2=$((${#array[@]}-6))
    name1=${array[$numName1]}
    name2=${array[$numName2]}
    name2=$(echo $name2 | sed 's/.*/\L&/')
    
    echo -n "Broj pogodjenih do vrste: "  >> stat.txt
    grep -c $name1\ $name2 "${line%/*}"/output.txt >> stat.txt
    
    echo -n "Broj ukupno pogodjenih: "  >> stat.txt
    grep -c ".*" "${line%/*}"/output.txt >> stat.txt
    
    echo -n "Time of execution: " >> stat.txt
    echo $time2/1000-$time1/1000 | bc -l >> stat.txt
    echo " " >> stat.txt
    
done < input.txt


