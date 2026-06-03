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

REM Try to start via Windows service first
net start MySQL84 >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo MySQL service started successfully.
    goto :done
)

REM If no service, try installing it (needs admin)
echo Installing MySQL as a Windows service (requires Admin)...
"%MYSQL_BIN%\mysqld.exe" --install MySQL84 --defaults-file="%MYSQL_INI%" 2>&1
net start MySQL84 2>&1

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
