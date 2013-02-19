#!/bin/bash

#本行为注释.

#为变量赋值.
#	a=2;
#	echo "11111$a";

#cat<<Help
#help!!!
#该区域内的文字将会原样输出.
#end!!!
#Help

#lua 2.lua | mysql -uroot -pta0mee

#echo "File name is ${0}";

svar=1
svar=$svar+1
echo $svar

var=1;			#bash默认是字符串赋值.

let "var=var+100"
var="$[${var}+1000]";
var=$(($var+1));	#bash和sh都支持的数值运算方式.
echo "${var}"


#shell中的条件判断语句.

if [ -n $var ] ; then
   echo "var 有值.";
else
   echo "var 没有值.";
fi

echo "your login shell is the ${SHELL}";

if [ $var=$temp ]; then
echo "值相等."
else
echo "值不相等."
fi

#if [ ${SHELL} = "/bin/bash" ]; then
#   echo "your login shell is the bash (bourne again shell)"
#else
#   echo "your login shell is not bash but ${SHELL}"
#fi


#for var in A B C ; do
#   echo "var is $var"
#done

var="2000";

case "$var" in
"1000"):
  echo "111111";;
"2000"):
  echo "000000";;
     *):
  echo "222222";;
esac

var=200;

if [ ${var} -eq 100 ]; then
	echo "var == 100"
elif [ ${var} -eq 200 ]; then
	echo "var == 200";
elif [ ${var} -eq 300 ]; then
	echo "var == 300";
elif [ ${var} -eq 400 ]; then
	echo "var == 400";
else
	echo "var is ${var}";
fi

while [ $var -gt 0 ]; do
	echo "var is ${var}.";
let "var=var-1";
done

for i in $(seq 0 10); do	#seq不指定第一个参数的话,默认从1开始.

	echo "i is ${i}."
	if [ ${i} -eq 2 ]; then
		echo "......"	
	elif [ ${i} -eq 8 ]; then
		echo "******"
	else
		echo "######"
	fi
done

for (( i=0; i<=100; i++));		#算术处理.
do
	echo "i = ${i}";

	if [ ${i} -eq 50 ];then
		echo "......";
	elif [ ${i} -eq 60 ]; then
		echo "******";
	else
		echo "######";
	fi

done
my_help()
{

cat <<HELP
	111111111111111111111111
22222222222222222222222222222222
33333333333333333333333333333333
44444444444444444444444444444444
    5555                    5555	
HELP
exit 0;
}

#echo "What is your favourite OS?"
#select var in "Linux" "Gnu Hurd" "Free BSD" "Other" "-h"; do
#  break;
#done
#echo "You have selected $var"

[ "${var}" = "-h" ] && my_help

#my_help;	#函数的调用.
#[ "$1" = "-h" ] && my_help #使用运行脚本所携带的参数.

#echo $((1+2));		#一个数值计算的结果.

exit 0;
