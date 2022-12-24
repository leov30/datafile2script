@echo off
title Datafile 2 Scrip Renanmer

if "%~1"=="" title ERROR&echo DRAG AND DROP .XML .DAT FILES&pause&exit
set "_dat=%~1"

set /a "_size=%~z1"
set "_file=%~n1.bat"

cd /d "%~dp0"

if exist xidel.exe set _xidel=xidel
if exist _bin\xidel.exe set _xidel=_bin\xidel
if exist c:\windows\system32\xidel.exe set _xidel=xidel
if "%_xidel%"=="" title ERROR&echo XIDEL.EXE WAS NOT FOUND, GET IT FROM HERE: https://www.videlibri.de/xidel.html&pause&exit

:option1
cls
echo ** Enter Extension for the files, press Enter to just use Defaults **
echo.
echo. 1. png ^(Default^)
echo. 2. jpg
echo. 3. txt
echo. 4. zip
echo. 5. other
echo. 
set /p "_opt=Enter Option: "||set _opt=1
if "%_opt%"=="1" set _ext=png&goto option2
if "%_opt%"=="2" set _ext=jpg&goto option2
if "%_opt%"=="3" set _ext=txt&goto option2
if "%_opt%"=="4" set _ext=zip&goto option2
if "%_opt%"=="5" (
	echo.
	set /p "_ext=Enter Other: "
	goto option2
)
echo INVALID OPTION&timeout 3&goto option1

:option2
cls
echo. ** Enter Option to Rename files **
echo.
echo. 1. Zip Name --------^> Description ^(Default^)
echo. 2. Description -----^> Zip Name
echo.
set /p "_opt=Enter Option: "||set _opt=1
if "%_opt%"=="1" set _alt1=$1&set _alt2=$2&goto next
if "%_opt%"=="2" set _alt1=$2&set _alt2=$1&goto next

echo INVALID OPTION&timeout 3&goto option2
:next
cls&echo Building script...

md output 2>nul
md _temp 2>nul

(echo @echo off
echo title Datafile2script Files Renamer ^^^| "%_file%" ^^^| Build: %DATE%
echo md _RENAMED 2^>nul
echo del _NOTFOUND.csv 2^>nul
echo choice /c:cm /m "Copy or Move files: "
echo if %%errorlevel%% equ 1 ^(set _opt=copy^)else ^(set _opt=move^)
echo cls^&echo Renaming Files ...)>"output\%_file%"

rem //remove header because it breaks xidel
%_xidel% -s "%_dat%" -e "replace( $raw, '^<!DOCTYPE mame \[.+?\]>$', '', 'ms')" >_temp\temp.dat

rem //this works for the big MAME xml
if %_size% gtr 80000000 (
	%_xidel% -s _temp\temp.dat -e "extract( $raw, '^\t<machine name=\""(\w+)\"".*>\s+<description>(.+)</description>$', (1,2), '*m')" >_temp\temp.1
)else (
	%_xidel% -s _temp\temp.dat -e "//(machine|game)[description]/(@name|description)" >_temp\temp.1
)

%_xidel% -s _temp\temp.1 -e "replace( $raw, '[<>:\"\"/\\|?*&]', '_')" >_temp\temp.2
%_xidel% -s _temp\temp.2 -e "replace( $raw, '^(.+)\r\n(.+)$', '%%_opt%% /y \"%_alt1%.%_ext%\" \"_RENAMED\\\%_alt2%.%_ext%\" >nul 2>&1 ||(echo \"$1\";\"$2\")>>_NOTFOUND.csv', 'm')" >>"output\%_file%"

del _temp\temp.dat _temp\temp.1 _temp\temp.2
rd _temp
cls&echo ALL DONE!!! scrip its in the "output" folder&timeout 5

