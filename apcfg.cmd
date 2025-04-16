@echo off
@setlocal enableextensions enabledelayedexpansion

::Default options
set "OPTION-AP-LIST=./aplist.txt"
set "OPTION-RADIO-IFACE=n/a"
set "OPTION-RADIO-ROLE=n/a"
set "OPTION-RADIO-TXPWR=n/a"
set "OPTION-WLC-PRI=n/a"
set "OPTION-WLC-SEC=n/a"
set "OPTION-AP-LED-BLINK=5"
REM set "OPTION-WLC-PRI=10.99.98.100 qCD_WLC5520"
REM set "OPTION-WLC-SEC=10.99.98.90 qCD_WLC9800"
REM set "OPTION-RADIO-IFACE=802.11a 802.11-abgn"
REM set "OPTION-RADIO-ROLE=manual"
REM set "OPTION-RADIO-TXPWR=global"

set "ARG-HELP=-h --help --hel --he --h"
set "ARG-RADIO-IFCE=-i --iface --ifac --ifa --if --i"
set "ARG-RADIO-POWR=-p --power --powe --pow --po --p"
set "ARG-RADIO-ROLE=-r --role --rol --ro --r"
set "ARG-APLIST=-l --list --lis --li --l"
set "ARG-AP-BLINK=-b --blink --blin --bli --bl --b"
set "ARG-WLC-1=-w1 --wlc-p --wlc-pr --wlc-pri --wlc-prim --wlc-prima --wlc-primar --wlc-primary"
set "ARG-WLC-2=-w2 --wlc-s --wlc-se --wlc-sec --wlc-seco --wlc-secon --wlc-second --wlc-seconda --wlc-secondar --wlc-secondary"

set "PARAM-RADIO-ABGN=abgn ab abg g n an"
set "PARAM-RADIO-PWR=global g gl glo glob globa"
set "PARAM-ROLE-AUTO=auto a au aut"
set "PARAM-ROLE-MANUAL=manual m ma man manu manua"
set "PARAM-CLEAR=n/a na n 0" 
set "OPT-RADIO-IFCE=-"

set "SCRIPT-NAME=%0"

if "%1"=="" goto NOARG

:LOOP-CLI-ARGS
@echo off
set "CLI-ARG-SHIFT-NUM=0"

@echo off
for %%i in (%ARG-HELP%) do if /i "%%i"=="%1" goto HELP
if "%2"=="" goto MISSING-PARAMETER

@echo off
for %%i in (%ARG-AP-BLINK%) do if /i "%%i"=="%1" (
    set "CLI-ARG-SHIFT-NUM=2"
	if %2 GEQ 5 (
	    if %2 LEQ 120 (
		   set "OPTION-AP-LED-BLINK=%2"
		)
	)
	for %%j in (%PARAM-CLEAR%) do if /i "%%j"=="%2" set "OPTION-AP-LED-BLINK=n/a"
)

@echo off
for %%i in (%ARG-RADIO-ROLE%) do if /i "%%i"=="%1" (
    set "CLI-ARG-SHIFT-NUM=2"
	set "BOOL-PARAM-SET=0"
    for %%j in (%PARAM-ROLE-AUTO%) do if /i "%%j"=="%2" (
	    set "BOOL-PARAM-SET=1"
        set "OPTION-RADIO-ROLE=auto" 
	)
	for %%j in (%PARAM-ROLE-MANUAL%) do if /i "%%j"=="%2" (
	    set "BOOL-PARAM-SET=1"
        set "OPTION-RADIO-ROLE=manual" 
	)
)

@echo off
for %%i in (%ARG-RADIO-POWR%) do if /i "%%i"=="%1" (
	set "CLI-ARG-SHIFT-NUM=2"
	set "BOOL-PARAM-SET=0"
	if %2 GEQ 1 (
	    if %2 LEQ 6 (
	        set "BOOL-PARAM-SET=1"
			set "OPTION-RADIO-TXPWR=%2"
	    )
    )
	for %%j in (%PARAM-RADIO-PWR%) do if "%%j"=="%2" (
        set "BOOL-PARAM-SET=1"
		set "OPTION-RADIO-TXPWR=global"
	)
	for %%j in (%PARAM-CLEAR%) do if /i "%%j"=="%2" set "OPTION-RADIO-TXPWR=n/a"
	if "!BOOL-PARAM-SET!"=="0" goto UNKNOWN-PARAM
)

@echo off
for %%i in (%ARG-RADIO-IFCE%) do if /i "%%i"=="%1" (
    set "CLI-ARG-SHIFT-NUM=2"
	set "BOOL-PARAM-SET=0"
    for %%j in (%PARAM-RADIO-ABGN%) do if /i "%%j"=="%2" (
	    set "BOOL-PARAM-SET=1"
		set "OPT-RADIO-IFCE=%OPT-RADIO-IFCE% 802.11-abgn"
	)
	if /i "%2"=="a" (
	    set "BOOL-PARAM-SET=1"
		set "OPT-RADIO-IFCE=%OPT-RADIO-IFCE% 802.11a"
	)
	if /i "%2"=="b" (
	    set "BOOL-PARAM-SET=1"
		set "OPT-RADIO-IFCE=%OPT-RADIO-IFCE% 802.11b"
	)
	for %%j in (%PARAM-CLEAR%) do if /i "%%j"=="%2" set "OPT-RADIO-IFCE=n/a"
	if "!BOOL-PARAM-SET!"=="0" goto UNKNOWN-PARAM
)

@echo off
set "WLC-NAME=%3+"

for %%i in (%ARG-WLC-1%) do if /i "%%i"=="%1" (
    set "CLI-ARG-SHIFT-NUM=3"
	if "%2"=="100" (
	    set "CLI-ARG-SHIFT-NUM=2"
		set "OPTION-WLC-PRI=10.99.98.100 qCD_WLC5520"
	) else ( if "%WLC-NAME%"=="" goto MISSING-3-PARAMETER
	    if not "%WLC-NAME:+=%"=="%WLC-NAME%" goto MISSING-3-PARAMETER
        set "OPTION-WLC-PRI=%2 %3"
	)
	echo.
	echo Alert: PRI-WLC - Check correct value IP:%2 Sysname:%3
)
for %%i in (%ARG-WLC-2%) do if /i "%%i"=="%1" (
    set "CLI-ARG-SHIFT-NUM=3"
    if "%WLC-NAME%"=="" goto MISSING-3-PARAMETER
	if not "%WLC-NAME:-=%"=="%WLC-NAME%" goto MISSING-3-PARAMETER
    set "OPTION-WLC-PRI=%2 %3"
	echo.
	echo Alert: SEC-WLC - Check correct value IP:%2 Sysname:%3
)

@echo off
if %CLI-ARG-SHIFT-NUM% EQU 0 goto UNKNOWN-ARG
if %CLI-ARG-SHIFT-NUM% GEQ 3 shift
if %CLI-ARG-SHIFT-NUM% GEQ 2 shift
shift
if not "%1"=="" goto LOOP-CLI-ARGS
goto PRINT-OPTIONS

:NOARG
:PRINT-OPTIONS
@echo off
if not "%OPT-RADIO-IFCE%"=="-" set "OPTION-RADIO-IFACE=%OPT-RADIO-IFCE:~2%"
echo.
echo AP list              : %OPTION-AP-LIST%
echo AP radio interface(s): %OPTION-RADIO-IFACE%
echo AP radio role        : %OPTION-RADIO-ROLE%
echo AP radio TX power    : %OPTION-RADIO-TXPWR%
echo AP Primary WLC       : %OPTION-WLC-PRI%
echo AP Secondary WLC     : %OPTION-WLC-SEC%
echo AP LED blink (sec)   : %OPTION-AP-LED-BLINK%
if not exist %OPTION-AP-LIST% goto HELP-WRONG-AP-LIST
echo.
echo Correct parameters (Y/Enter = Ok)?
set /p ANSWER=""
if "%ANSWER%"=="" goto PRINT-SRIPT
if /i "%ANSWER%"=="y" goto PRINT-SRIPT
goto END

:PRINT-SRIPT
@echo on
for /f %%i in (%OPTION-AP-LIST%) do (
	if /i not "%OPTION-AP-LED-BLINK%"=="n/a" echo config ap led-state flash %OPTION-AP-LED-BLINK% %%i
	if /i not "%OPTION-RADIO-IFACE%"=="n/a" (
	    for %%j in (%OPTION-RADIO-IFACE%) do (
			echo config %%j disable %%i
			if /i not "%OPTION-RADIO-ROLE%"=="n/a" echo config %%j role %%i %OPTION-RADIO-ROLE% client-serving
			if /i not "%OPTION-RADIO-TXPWR%"=="n/a" echo config %%j txPower ap %%i %OPTION-RADIO-TXPWR%
	        echo config %%j enable %%i
	    )
	)
	if /i not "%OPTION-WLC-PRI%"=="n/a" (
	    for /f "tokens=1,2" %%j in ("%OPTION-WLC-PRI%") do (
		    echo config ap primary-base %%k %%i %%j
		)
	)
	if /i not "%OPTION-WLC-SEC%"=="n/a" (
	    for /f "tokens=1,2" %%j in ("%OPTION-WLC-SEC%") do (
		    echo config ap primary-base %%k %%i %%j
		)
	)
	echo.
)
goto END

:MISSING-3-PARAMETER
@echo off
echo.
echo Err - Missing 3rd parametr for argument %1 %2 
goto HELP


:MISSING-PARAMETER
@echo off
echo.
echo Err - Missing parametr for argument %1
goto HELP

:UNKNOWN-PARAM
@echo off
echo.
echo Err - Unknown parametr: %1 %2
goto HELP

:HELP-WRONG-AP-LIST
@echo off
echo.
echo Err - Could't access AP-list file %OPTION-AP-LIST%.
goto HELP 

:UNKNOWN-ARG
@echo off
echo.
echo Err - Unknown argument: %1
goto HELP

:HELP
@echo off
echo.
echo This script processes the input parameters and prints commands for the WLC 5520 (AireOS) for each specified wireless access point.
echo.
echo Usage: %SCRIPT-NAME% [Options]
echo  where options are:
echo   -h --help                              print this HELP
echo   -l --list ^<list^>                       ap list file. One record per line
::echo   -l --list ^<list^>                       ap list file. Two records per line = rename request
::echo   -a --access-point ^<ap-name^>            single acces-point name for process. This option supress -l 
echo   -i --iface (a^|b^|g^|n^|abgn)              ap interface. Multiple usage allowed
echo   -r --role (manual^|auto)                wireless interface role
echo   -p --power (1..6^|global)               transmit power 1=max 6=min global=WLC driven
echo   -w1 --wlc-primary ^<WLC_IP WLC_NAME^>    Primary WLC setting
echo   -w2 --wlc-secondary ^<WLC_IP WLC_NAME^>  Secondary WLC setting
echo   -b --blink ^<5..120^>                    Blink AP led for N seconds

:END
@echo off
echo END - Script end
endlocal
