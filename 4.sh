#!/bin/bash

#varch="google.com";
varch="BAIDU.COM";

var="";
function transform_ch()
{
	case $1 in
	1)var="A";;
	2)var="B";;
	3)var="C";;
	4)var="D";;
	5)var="E";;
	6)var="F";;
	7)var="G";;
	8)var="H";;
	9)var="I";;
	10)var="J";;
	11)var="K";;
	12)var="L";;
	13)var="M";;
	14)var="N";;
	15)var="O";;
	16)var="P";;
	17)var="Q";;
	18)var="R";;
	19)var="S";;
	20)var="T";;
	21)var="U";;
	22)var="V";;
	23)var="W";;
	24)var="X";;
	25)var="Y";;
	26)var="Z";;

	27)var="0";;
	28)var="1";;
	29)var="2";;
	30)var="3";;
	31)var="4";;
	32)var="5";;
	33)var="6";;
	34)var="7";;
	35)var="8";;
	36)var="9";;

	*)var="BUG";;
	esac
	return 0;
}

function query()
{

	varch="${1}${2}${3}${4}${5}";	#baidu.com

	key="";	
	b="";
	case ${5} in
		".COM")key="No match for \"${varch}\"\.";;
		".NET")key="No match for \"${varch}\"\.";;
		".cn")key="no matching record";;
		".com.cn")key="no matching record";;
		".top")key="No match";;
		*)key="BUG";;
	esac

	#echo "${varch} and key= ${key}";
	#b=`whois ${varch} | grep "${key}"`;

	#查询Top域名需要指定HOST服务器.
	b=`whois ${varch} -h whois.nic.top | grep "${key}"`;
	#echo "${b}";

	if [ "${b}" == "" ] ; then
		echo "${varch} 已经被注册 ${b}." >> ${FILE};
	else
		#echo "${varch} 未被注册." >> ${FILE2};
		echo "${varch} 未被注册." >> 1.txt;
	fi
#sleep 1s	#cn域名需要限制查询时间.
}
######################################################################

#########################
#使用随机字符#
#########################
#ran=$(($RANDOM%26+1));	#bash和sh都支持的数值运算方式.
#transform_ch ${ran}
#varch="baid${var}";

#ran=$(($RANDOM%26+1));	#bash和sh都支持的数值运算方式.
#transform_ch ${ran}
#varch="${varch}${var}.com";

#echo "${varch}";

#b=`whois ${varch} | grep Creation`;
######################################################################

######################################################################

FILE=`date +%s`
FILE2=`date +%m%h`

begin=27;	#起始值,对应于字符表.
end=37;		#终止值,对应与字符表.

count=${begin};
count2=${begin};
count3=${begin};
count4=${begin};

first="";
second="";
three="";
four="";

while [ $count -lt ${end}	]		#构造第一个字符. 
do

transform_ch ${count};
first="${var}"
count2=$((${begin}));				
	while [ $count2 -lt ${end}	]	#构造第二个字符.
	do
		transform_ch ${count2};
		second="${var}"
		#query ${first} ${second} ".top" #调用函数.

		count3=$((${begin}));

		while [ $count3 -lt ${end}	]	#构造第三个字符.
		do
		transform_ch ${count3};
		three="${var}";
		#echo "${first}${second}${three}.com" >> all;

		#query ${first} ${second} ${three} ".top" #调用函数.
		#query ${first} ${second} ${three} ".net" #调用函数.

		count4=$((${begin}));
			while [ $count4 -lt ${end}	]
			do
			transform_ch ${count4};
			four="${var}";
			#query ${first} ${second} ${three} ${four} ".cn" #调用函数.
			#query ${first} ${second} ${three} ${four} ".com.cn" #调用函数.
			#query ${first} ${second} ${three} ${four} ".COM" #调用函数.
			#query ${first} ${second} ${three} ${four} ".NET" #调用函数.
			#$echo "${first}${second}${three}${four}.top";
			query ${first} ${second} ${three} ${four} ".top" #调用函数.

			count4=$((count4+1));
			done
		#query ${first} ${second} ${three} ".com.cn" #调用函数.
		#query ${first} ${second} ${three} ".cn" #调用函数.

		count3=$((count3+1));
		done

##############################################
#		varch="${first}${second}.net";
		#echo "${first}${second}";
#		b=`whois ${varch} | grep "Creation Date:"`;

#		if [ "${b}" != "" ] ; then
#		  echo "${varch} 已经被注册 ${b}." >> ${FILE};
#		else
#		  echo "${varch} 未被注册." >> ${FILE};
#		fi
##############################################

		count2=$((count2+1));
	done

count=$((count+1));
done
#####################################################################
exit 0;

