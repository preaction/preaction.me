
speed=$1
root_name=$2
count=$3

for NUM in $(seq 1 $count); do
    sleep $speed
    name=${root_name}_$NUM.png
    raspi2png -p $name
    echo -ne "\a"
done
echo -ne "\a"
echo -ne "\a"
echo -ne "\a"
echo -ne "\a"
