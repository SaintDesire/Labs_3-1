@echo off
chcp 65001 > nul 2>&1

echo Имя этого bat-файла: %~n0
echo Путь bat-файла: %~f0

pause