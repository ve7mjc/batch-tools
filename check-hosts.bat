@echo off

SETLOCAL ENABLEDELAYEDEXPANSION

:: CURRIE, Matthew
:: 14 Jan 2016
:: Check network host status from list
:: Load a comma delimited list of network hosts to check with ping
:: Format ip_address,description with spaces
:: Usage: check-hosts.bat hosts.cfg
		REM %SystemRoot%\system32\ping.exe -n 1 %%a >nul
::
:: DEV NOTES: Careful of DELAYED VARIABLE EXPANSION
echo.
echo Checking for network hosts on LAN per %1
echo.

echo Network Address(s)
echo ------------------
echo.

set ip_address_string="IPv4 Address"
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ip_address_string%`) do (
    echo Network Address: %%f
)

echo.
echo Network Hosts
echo -------------
echo.

set host_status=1
set HOST_PASS=1
set HOST_FAIL=0

for /f "tokens=*" %%i in (%1) do (
	:: %%i is string
	for /f "delims=, tokens=1,2" %%a in ("%%i") do (
		set host_status=!HOST_PASS!
		ping -n 1 %%a | findstr /I /C:"timed out" /C:"host unreachable" /C:"could not find host" >nul && set host_status=!HOST_FAIL!
		if !host_status!==1 (
			echo [ OK ] %%b - %%a
		) else (
			echo [FAIL] %%b - %%a
		)
	)
)

echo.
pause

ENDLOCAL