#!/bin/bash

CURTIME=$((`date +%s`));
FILE=FILE_${CURTIME};

echo "${FILE}";


#被其他程序调用时,只有返回0才代表程序执行成功,其他值都被认为是执行失败.
return 0;
#return -1;
