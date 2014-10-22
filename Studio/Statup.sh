#!/bin/bash

clang -fobjc-arc -framework Foundation -I./Head             \
                                        ./imple/Fraction.m  \
                                        main.m              \
                                        -o prog1

#-I标示头文件目录包含.
#-L标示库目录包含.
#-l表示链接到具体的库,如curl,其实是链接libcurl.so库.
