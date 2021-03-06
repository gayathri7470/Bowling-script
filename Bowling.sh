#while loop is used to check until the name is entered
while $name

do
echo "Enter your Full Name"

# question trap is used and prints the output which never exits the command shell if Ctrl +c is used

trap 'print "Hit Ctrl +C to exit"' INT
read name
if [ -z "$name" ]
then
echo "Please enter your Name"
else
echo "The name registered is" $name
fi
done
#end of while loop

#To append the name and date to the file bowler.txt , bowler1.txt is an intermediate file

echo $name >> bowler1.txt
echo $(date) >> bowler1.txt
echo "Welcome to Bowling script" $name
#To calculate the sum cumilatively

sum=0
#x is used for checking the strike condition
X=10
#count for incrementing
count=1
#var3 is used to hold the value of addition of two pins for each frame
var3=0
#var5 is used to hold the value of var3 so that after adding some values to var3 the value is not lost
var5=0
#declaring two arrays for SC10) question to print the cumilative values and the maximum score
set -A myarraylist
set -A mylist

#pins is the first ball and pins2 is the second ball

while [[ $count -le 9 ]]
do
echo "Click the number of pins knock down"
read pins
#the value in pins is appended to the array myarraylist
myarraylist[${#myarraylist[*]}+1]=$pins
#var1 checks if the entered pin is in between 0 and 9 or not 
var1=$(echo "$pins" | grep "[0-9]" | wc -l )

#this is used to calculate the SPARE score if any occured in the bowling game
if [ $var3 -eq 10 ]
then
var3=$(expr "$var5" + "$pins")
echo "The sum for previous frame is" $var3

#the cumilative additions are appended to an array 

mylist[${#mylist[*]}+1]=$var3
fi
if [ $pins -eq $X -a $var3 -eq 10 ]
then
echo "Click the number of pins knock down"
read pins2
 var3=$(expr "$var3" + "$pins" + "$pins2")
echo "the sum at strike is  " $var3
fi
if [  $var1 -ne 0 -a $pins -eq $X ]
then
echo "It is a strike"
echo "Click the number of pins knock down"
read pins
continue
elif [ $var1 -ne 0 -a $pins -ne $X ]
then
echo "Click the number of pins knock down"
read pins2
myarraylist[${#myarraylist[*]}+1]=$pins2
var4=$var3
var2=$(echo "$pins2" | grep "[0-9]" | wc -l )
let var3=$pins+$pins2;
var5=$(expr "$var4" + "$var3")
else
echo "Enter valid input"
fi
if [ $var3 -eq 10 ]
then
echo "Its a spare"
count=$(expr "$count" + 1)
continue
elif [ $var3 -gt 10 ]
then
echo "The sum is greater than 10"
else
echo "Score per frame" $var5
sum=$(expr "$sum" + "$var5")
mylist[${#mylist[*]}+1]=$var5
var3=$var5
count=$(expr "$count" + 1)
fi
done
echo "THE TOTAL SCORE FOR FIRST 9 FRAMES IS"
echo "${mylist[*]}"
echo "MAXIMUM SCORE EARNED"
echo "${mylist[9]}"
echo "In the 10th frame you can bowl 3 times but conditions apply"
max=18
Func () {
for i in ${myarraylist[@]};
do
echo "$i"
done
}
echo "Click the number of pins knock down"
read pins3
myarraylist[${#myarraylist[*]}+1]=$pins3
echo "Click the number of pins knock down"
read pins4
myarraylist[${#myarraylist[*]}+1]=$pins4
total=$(expr "$pins3" + "$pins4")
if [ $total -eq $X ]
then
echo "its a spare you earned one more chance"
mylist[${#mylist[*]}+1]=$total
echo "Click the number of pins knock down"
read pins5
myarraylist[${#myarraylist[*]}+1]=$pins5
mylist[${#mylist[*]}+1]=$pins5
echo "THE TOTAL SCORE FOR 10 FRAMES IS"
echo "${mylist[*]}" >> bowler1.txt
elif [ $pins3 -eq $X ]
then
echo "Congratulations ! Its a Strike ! You earned one more chance"
if [ $pins4 -eq $X ]
then
echo "Its a strike again !! You earned one more chance"
echo "Click the number of pins knock down"
read pins5
myarraylist[${#myarraylist[*]}+1]=$pins5
echo "game is over"
total1=$(expr "$pins3" + "$pins4" + "$pins5")
mylist[${#mylist[*]}+1]=$(expr "$total1" + "$var5")
echo "game is over"
echo "THE CUMILATIVE SCORE FOR 10 FRAMES IS"
Func >> bowler1.txt
echo "MAXIMUM SCORE EARNED"
echo "${mylist[10]}"
fi
else
mylist[${#mylist[*]}+1]=$(expr "$total" + "$var5")
echo "game is over"
echo "THE CUMILATIVE SCORE FOR 10 FRAMES IS"
echo "${mylist[*]}"
Func >> bowler1.txt
fi
echo  -e "${mylist[10]}\n" >> bowler1.txt

#check if both the files are empty first or else remove bowler1.txt or bowler.txt
awk -F" " '{printf "%s %s",$1,$2}' bowler1.txt > bowler.txt
