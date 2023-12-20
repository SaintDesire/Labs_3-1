@echo off
chcp 65001 > nul 2>&1
setlocal enabledelayedexpansion

echo Введите строку:
set input= %*
echo Строка параметров !input!

set num=1
for %%a in (%input%) do (
    echo Параметр !num!: %%a
    set /a num+=1
)

endlocal

pause