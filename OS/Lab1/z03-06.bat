@echo off
title MyLab
chcp 65001 > nul

set title=%1%
set file=%2%
rem для проверки на не корректно введённую команду
set count=0

echo строка параметров: %title% %file%
echo режим: %title%
echo имя файла: %file%

if "%title%"=="" (
	echo имя этого файла: %0%
	echo режим = {создать/ удалить}
	echo файл = имя файла
	set /a count += 1
)

if "%file%"=="" (
	goto ab
)

if "%title%"=="удалить" (

		if not exist %file% (
				echo файл не существует(((
				goto ba
		) else (
				del %file%
				echo удалён!
				goto ba
		)
	
	set /a count += 1
)

if "%title%"=="создать" (
	
		if exist %file% (
			echo файл уже существует(((
			goto ba
		) else (
			echo. > "%file%"
			echo создан!
			goto ba
		)
	
	set /a count += 1
)

if "%count%" equ 0 (
	echo режим задан не корректно!
)

:ab
if not "%title%"=="" (
echo не указано название файла для создания/удаления!
) 
:ba

pause
