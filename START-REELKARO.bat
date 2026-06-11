@echo off
REM ================================================================
REM  START-REELKARO.bat — One-click launcher for ReelKaro
REM  This script handles MySQL + Tomcat startup automatically.
REM  Run AS ADMINISTRATOR for MySQL service management.
REM ================================================================
setlocal

REM ================================================================
REM  CONFIGURATION — Update these if your install paths differ
REM ================================================================
SET JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.19.10-hotspot
SET MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.4\bin
SET MYSQL_INI=C:\ProgramData\MySQL\MySQL Server 8.4\my.ini
SET CATALINA_HOME=C:\tools\apache-tomcat-10.1.20
SET WAR_SRC=%~dp0target\reelkaro.war

REM --- DB Connection (read by DBConnection.java) ---
SET DB_HOST=127.0.0.1
SET DB_PORT=3306
SET DB_NAME=reelkaro
SET DB_USER=root
SET "DB_PASSWORD="

REM ================================================================
REM  STEP 1: Start MySQL
REM ================================================================
echo.
echo ================================================================
echo  STEP 1: Starting MySQL Server...
echo ================================================================

REM Check if already running
"%MYSQL_BIN%\mysqladmin.exe" -u root -h 127.0.0.1 ping >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo [OK] MySQL is already running on port 3306.
    goto :mysql_ready
)

REM Try starting as Windows service (various common service names)
echo Trying to start MySQL Windows service...
net start MySQL >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo [OK] MySQL service 'MySQL' started.
    goto :wait_mysql
)

net start MySQL84 >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo [OK] MySQL service 'MySQL84' started.
    goto :wait_mysql
)

net start MySQL80 >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    echo [OK] MySQL service 'MySQL80' started.
    goto :wait_mysql
)

REM No service found — start mysqld directly
echo [INFO] No MySQL Windows service found. Starting mysqld directly...
echo [INFO] This window must stay open while running!
START "MySQL Server" "%MYSQL_BIN%\mysqld.exe" --defaults-file="%MYSQL_INI%"

:wait_mysql
echo Waiting for MySQL to be ready...
timeout /t 8 /nobreak >nul

REM Verify connection
"%MYSQL_BIN%\mysqladmin.exe" -u root -h 127.0.0.1 ping >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [WARNING] MySQL may not be ready. Waiting 5 more seconds...
    timeout /t 5 /nobreak >nul
    "%MYSQL_BIN%\mysqladmin.exe" -u root -h 127.0.0.1 ping >nul 2>&1
    IF %ERRORLEVEL% NEQ 0 (
        echo.
        echo [ERROR] Cannot connect to MySQL!
        echo.
        echo Possible solutions:
        echo  1. Open MySQL Workbench and start the server
        echo  2. Run MySQL Installer and ensure MySQL Server is running
        echo  3. Check Windows Services for 'MySQL' service
        echo  4. Try running this script as Administrator
        echo.
        echo Your MySQL root password might be required. Edit this script
        echo and update DB_PASSWORD if you have one set.
        echo.
        pause
        exit /b 1
    )
)

:mysql_ready
echo [OK] MySQL is ready!

REM ================================================================
REM  STEP 2: Initialize database (first time only)
REM ================================================================
echo.
echo ================================================================
echo  STEP 2: Ensuring database and tables exist...
echo ================================================================
"%MYSQL_BIN%\mysql.exe" -u root -h 127.0.0.1 -e "SELECT 'reelkaro DB found' FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME='reelkaro'" 2>nul | find "reelkaro DB found" >nul
IF %ERRORLEVEL% NEQ 0 (
    echo Setting up reelkaro database (first time)...
    "%MYSQL_BIN%\mysql.exe" -u root -h 127.0.0.1 < "%~dp0database\schema.sql"
    IF %ERRORLEVEL% EQU 0 (
        echo [OK] Database created and schema applied.
    ) ELSE (
        echo [WARNING] Could not auto-create DB. Please run: %~dp0setup-db.bat
    )
) ELSE (
    echo [OK] Database 'reelkaro' already exists.
)

REM ================================================================
REM  STEP 3: Build the WAR (if source is newer than WAR)
REM ================================================================
echo.
echo ================================================================
echo  STEP 3: Checking if rebuild is needed...
echo ================================================================
IF NOT EXIST "%WAR_SRC%" (
    echo WAR not found. Building...
    SET PATH=%JAVA_HOME%\bin;%PATH%
    CALL C:\tools\apache-maven-3.9.6\bin\mvn.cmd clean package -q
    IF %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Build failed! Fix errors and try again.
        pause
        exit /b 1
    )
    echo [OK] Build successful.
) ELSE (
    echo [OK] WAR found. Skipping build (run 'mvn clean package' to rebuild).
)

REM ================================================================
REM  STEP 4: Deploy WAR to Tomcat
REM ================================================================
echo.
echo ================================================================
echo  STEP 4: Deploying to Tomcat...
echo ================================================================
IF NOT EXIST "%CATALINA_HOME%\webapps" (
    echo [ERROR] Tomcat not found at: %CATALINA_HOME%
    echo Please update CATALINA_HOME in this script.
    pause
    exit /b 1
)

REM Remove old deployment to force fresh deploy
IF EXIST "%CATALINA_HOME%\webapps\reelkaro" (
    rmdir /S /Q "%CATALINA_HOME%\webapps\reelkaro"
)
copy /Y "%WAR_SRC%" "%CATALINA_HOME%\webapps\reelkaro.war" >nul
echo [OK] WAR deployed.

REM ================================================================
REM  STEP 5: Start Tomcat
REM ================================================================
echo.
echo ================================================================
echo  STEP 5: Starting Tomcat 10.1...
echo ================================================================
SET PATH=%JAVA_HOME%\bin;%PATH%

REM Stop any existing Tomcat first
taskkill /F /FI "WINDOWTITLE eq Tomcat*" >nul 2>&1

call "%CATALINA_HOME%\bin\startup.bat"

echo.
echo ================================================================
echo  ReelKaro is starting up!
echo.
echo  URL:        http://localhost:8080/reelkaro/
echo  Brand Demo: brand@demo.com  / password123
echo  Creator:    creator@demo.com / password123
echo.
echo  Database:   reelkaro @ 127.0.0.1:3306 (root, no password)
echo ================================================================
timeout /t 6 /nobreak >nul
start http://localhost:8080/reelkaro/

endlocal
