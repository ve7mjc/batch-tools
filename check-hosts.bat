@echo off

:: CURRIE, Matthew
:: 14 Jan 2016
:: Check network host status from list
:: Load a comma delimited list of network hosts to check with ping
:: Format ip_address,description with spaces
:: Usage: check-hosts.bat hosts.cfg

echo.
echo Checking for CAAS components on LAN ...
echo.

echo Network Address
echo ---------------
echo.

set ip_address_string="IPv4 Address"
for /f "usebackq tokens=2 delims=:" %%f in (`ipconfig ^| findstr /c:%ip_address_string%`) do (
    echo Your IP Address is: %%f
)

echo.
echo Network Hosts
echo -------------
echo.

for /f "tokens=*" %%i in (%1) do (
	:: %%i is string
	for /f "delims=, tokens=1,2" %%a in ("%%i") do (
		%SystemRoot%\system32\ping.exe -n 1 %%a >nul
		if not errorlevel 1 (
			echo [ OK ] %%b - %%a
		)
		if errorlevel 1 (
			echo [FAIL] %%b - %%a
		)
	)
)

echo.
pause