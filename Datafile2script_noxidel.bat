@echo off

if "%~1"=="" title ERROR&echo DRAG AND DROP .XML .DAT FILES&pause&exit
set "_dat=%~1"

set /a "_size=%~z1"
set "_file=%~n1.bat"

cd /d "%~dp0"

set _tag=game
>nul findstr /l /c:"<machine name=" "%_dat%"&&set _tag=machine
>nul findstr /l /c:"<header>" "%_dat%"&&set "_skip=skip=1 "

md output 2>nul
(echo md _REN 2^>nul)>output.tmp

rem //don't include bios
for /f "%_skip%tokens=1,2,3 delims=><" %%g in ('findstr /l /c:"<%_tag% name=" /c:"<description>" "%_dat%"') do (
	call :make_batch "%%g" "%%h" "%%i"

)
move /y output.tmp "output\%_file%.bat"
pause&exit

:make_batch

if not "%~2"=="description" (
	for /f tokens^=2^ delims^=^" %%g in ("%~2") do set "_game=%%g"
	exit /b
)

if "%_game%"=="" exit /b
echo %_game%

set "_desc=%~3"
set "_desc=%_desc:&amp;=_%"
set "_desc=%_desc::=_%"
set "_desc=%_desc:/=_%"
set "_desc=%_desc:\=_%"
set "_desc=%_desc:|=_%"
set "_desc=%_desc:?=_%"
rem //can't remove [*"><]

(echo copy "%_game%.png" "_REN\%_desc%.png")>>output.tmp


set "_game="
exit /b