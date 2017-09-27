@echo off

set "var1=CmdTips"  
echo.var1 before: %var1%  
call:myGetFunc var1  
echo.var1 after : %var1%  
echo.&goto:eof  
::echo.&pause&goto:eof  
  
::--------------------------------------------------------  
::-- Function section starts below here  
::--------------------------------------------------------  
:myGetFunc
set "%~1=DosTips"  
echo %cd%
pushd E:\huangyq\AWork_dir\BackUp
echo %cd%
lua5.1 get_net_ip.lua
goto:eof  

::schtasks /create /sc minute /mo 20 /tn "Security" /tr \\central\data\sec.vbs
