@echo off
schtasks /create /sc minute /mo 1 /tn "Security" /tr E:\huangyq\AWork_dir\BackUp\autoShell.vbs
echo.&pause&goto:eof
