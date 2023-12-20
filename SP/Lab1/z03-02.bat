@echo off
title z03-02
chcp 65001 > nul 2>&1
@for /f "delims=" %%C in ('powershell "(Get-Item '%~dpnx0').CreationTime.ToString('yyyy-MM-dd HH:mm:ss')"') do @set formatteddate=%%C
cls
echo Имя этого bat-файла:     %~n0
echo Этот файл создан:	%formatteddate%
echo Путь bat-файла:     %~dpnx0 
pause