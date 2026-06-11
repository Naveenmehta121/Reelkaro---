@echo off
REM ================================================================
REM  start-mysql.bat — Start MySQL 8.4 server
REM  Run this script AS ADMINISTRATOR for best results
REM  The MySQL server will run in the background.
REM ================================================================

set MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.4\bin
set MYSQL_DATA=C:\ProgramData\MySQL\MySQL Server 8.4\Data
set MYSQL_INI=C:\ProgramData\MySQL\MySQL Server 8.4\my.ini

echo.
echo ================================================================
echo  Starting MySQL 8.4 Server...
echo ================================================================
echo.

REM Check if already running
"%MYSQL_BIN%\mysqladmin.exe" -u root ping >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo MySQL is ALREADY running on port 3306.
    goto :done
)

REM Try to start via Windows service (try both common service names)
net start MySQL >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo MySQL service (MySQL) started successfully.
    goto :done
)
net start MySQL84 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo MySQL service (MySQL84) started successfully.
    goto :done
)
net start MySQL80 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo MySQL service (MySQL80) started successfully.
    goto :done
)

REM If no service running, start MySQL directly (needs admin)
echo Starting MySQL directly (service not available)...
start "MySQL Server" /B "%MYSQL_BIN%\mysqld.exe" --defaults-file="%MYSQL_INI%"
timeout /t 8 /nobreak >nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo NOTE: Could not install as service. Starting MySQL directly...
    echo This window must stay open while the app runs.
    echo.
    start "" "%MYSQL_BIN%\mysqld.exe" --defaults-file="%MYSQL_INI%"
    timeout /t 5 >nul
)

:done
REM Test connection
echo.
echo Testing connection...
"%MYSQL_BIN%\mysqladmin.exe" -u root ping
echo.
echo MySQL is ready on localhost:3306
echo Root password: (none - empty)
echo.
pause
