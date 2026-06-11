@echo off
setlocal EnableDelayedExpansion

REM ╔══════════════════════════════════════════════════════════════════╗
REM ║          ReelKaro — ONE-CLICK SMART LAUNCHER                    ║
REM ║  Double-click this file to start everything automatically       ║
REM ╚══════════════════════════════════════════════════════════════════╝

REM ───── CONFIGURATION ─────────────────────────────────────────────
SET JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.19.10-hotspot
SET MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.4\bin
SET MYSQL_INI=C:\ProgramData\MySQL\MySQL Server 8.4\my.ini
SET CATALINA_HOME=C:\tools\apache-tomcat-10.1.20
SET MVN_CMD=C:\tools\apache-maven-3.9.6\bin\mvn.cmd
SET PROJ_DIR=%~dp0
SET WAR_SRC=%PROJ_DIR%target\reelkaro.war
SET APP_URL=http://localhost:8080/reelkaro/

REM ───── DB env vars read by DBConnection.java ─────────────────────
SET DB_HOST=127.0.0.1
SET DB_PORT=3306
SET DB_NAME=reelkaro
SET DB_USER=root
SET "DB_PASSWORD="

REM ─────────────────────────────────────────────────────────────────
REM  SELF-ELEVATION: If not running as Admin, relaunch with UAC prompt
REM ─────────────────────────────────────────────────────────────────
net session >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo  [!] Administrator rights required to start MySQL service.
    echo  [!] A UAC prompt will appear — click YES to continue.
    echo.
    powershell -NoProfile -Command ^
      "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

REM ─────────────────────────────────────────────────────────────────
REM  BANNER
REM ─────────────────────────────────────────────────────────────────
cls
echo.
echo  ██████╗ ███████╗███████╗██╗      ██╗  ██╗ █████╗ ██████╗  ██████╗
echo  ██╔══██╗██╔════╝██╔════╝██║      ██║ ██╔╝██╔══██╗██╔══██╗██╔═══██╗
echo  ██████╔╝█████╗  █████╗  ██║      █████╔╝ ███████║██████╔╝██║   ██║
echo  ██╔══██╗██╔══╝  ██╔══╝  ██║      ██╔═██╗ ██╔══██║██╔══██╗██║   ██║
echo  ██║  ██║███████╗███████╗███████╗ ██║  ██╗██║  ██║██║  ██║╚██████╔╝
echo  ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
echo.
echo              India's First Clipping Platform — v1.0
echo  ════════════════════════════════════════════════════════════════════
echo.

SET /A STEP=0
SET /A TOTAL=5

CALL :LOG_STEP "Setting up environment"

REM ─────────────────────────────────────────────────────────────────
REM  STEP 1 — START MYSQL
REM ─────────────────────────────────────────────────────────────────
SET /A STEP+=1
echo  [%STEP%/%TOTAL%] Starting MySQL Server...
echo  ────────────────────────────────────────

REM Check if already running
"%MYSQL_BIN%\mysqladmin.exe" -u root -h 127.0.0.1 ping >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    CALL :OK "MySQL is already running on port 3306"
    GOTO :mysql_ready
)

REM Try all common service names
net start MySQL >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    CALL :OK "MySQL Windows service started"
    GOTO :wait_mysql
)
net start MySQL84 >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    CALL :OK "MySQL84 Windows service started"
    GOTO :wait_mysql
)
net start MySQL80 >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    CALL :OK "MySQL80 Windows service started"
    GOTO :wait_mysql
)

REM Direct launch fallback
CALL :WARN "No service found — launching mysqld directly..."
IF EXIST "%MYSQL_INI%" (
    START "MySQL-Server" /B "%MYSQL_BIN%\mysqld.exe" --defaults-file="%MYSQL_INI%"
) ELSE (
    START "MySQL-Server" /B "%MYSQL_BIN%\mysqld.exe" --datadir="C:\ProgramData\MySQL\MySQL Server 8.4\Data" --port=3306
)

:wait_mysql
CALL :WAIT "Waiting for MySQL to accept connections" 8

REM Verify MySQL is up — retry up to 3 times
SET /A TRIES=0
:mysql_ping_loop
"%MYSQL_BIN%\mysqladmin.exe" -u root -h 127.0.0.1 ping >nul 2>&1
IF %ERRORLEVEL% EQU 0 GOTO :mysql_ready
SET /A TRIES+=1
IF %TRIES% LSS 3 (
    CALL :WAIT "Still waiting for MySQL..." 4
    GOTO :mysql_ping_loop
)
CALL :FAIL "Cannot connect to MySQL after retries."
echo.
echo  TROUBLESHOOTING:
echo    1. Open MySQL Workbench and click Start Server
echo    2. Or open Services (Win+R → services.msc) and start 'MySQL'
echo    3. Then re-run this script
echo.
pause
exit /b 1

:mysql_ready
CALL :OK "MySQL is ready"
echo.

REM ─────────────────────────────────────────────────────────────────
REM  STEP 2 — INITIALIZE DATABASE (first time only)
REM ─────────────────────────────────────────────────────────────────
SET /A STEP+=1
echo  [%STEP%/%TOTAL%] Checking database schema...
echo  ────────────────────────────────────────

"%MYSQL_BIN%\mysql.exe" -u root -h 127.0.0.1 --silent -e ^
    "SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='reelkaro' AND TABLE_NAME='users';" >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    CALL :OK "Database 'reelkaro' already initialized"
) ELSE (
    CALL :WARN "First run — creating database and tables..."
    IF EXIST "%PROJ_DIR%database\schema.sql" (
        "%MYSQL_BIN%\mysql.exe" -u root -h 127.0.0.1 < "%PROJ_DIR%database\schema.sql" >nul 2>&1
        IF %ERRORLEVEL% EQU 0 (
            CALL :OK "Database created and schema applied successfully"
        ) ELSE (
            CALL :FAIL "Could not create database. Check your MySQL root password."
            pause
            exit /b 1
        )
    ) ELSE (
        CALL :FAIL "schema.sql not found at %PROJ_DIR%database\schema.sql"
        pause
        exit /b 1
    )
)
echo.

REM ─────────────────────────────────────────────────────────────────
REM  STEP 3 — BUILD THE WAR
REM ─────────────────────────────────────────────────────────────────
SET /A STEP+=1
echo  [%STEP%/%TOTAL%] Building application (Maven)...
echo  ────────────────────────────────────────

SET PATH=%JAVA_HOME%\bin;%PATH%

IF NOT EXIST "%MVN_CMD%" (
    REM Try alternate Maven locations
    IF EXIST "C:\tools\apache-maven-3.9.9\bin\mvn.cmd"  SET MVN_CMD=C:\tools\apache-maven-3.9.9\bin\mvn.cmd
    IF EXIST "C:\tools\apache-maven-3.9.8\bin\mvn.cmd"  SET MVN_CMD=C:\tools\apache-maven-3.9.8\bin\mvn.cmd
    IF EXIST "C:\tools\apache-maven-3.9.7\bin\mvn.cmd"  SET MVN_CMD=C:\tools\apache-maven-3.9.7\bin\mvn.cmd
)

IF EXIST "%MVN_CMD%" (
    echo     Building... (this takes ~10 seconds)
    CALL "%MVN_CMD%" -f "%PROJ_DIR%pom.xml" clean package -q -DskipTests
    IF %ERRORLEVEL% EQU 0 (
        CALL :OK "Build successful — WAR created"
    ) ELSE (
        CALL :FAIL "Maven build FAILED. Fix compilation errors and retry."
        pause
        exit /b 1
    )
) ELSE (
    IF EXIST "%WAR_SRC%" (
        CALL :WARN "Maven not found — using existing WAR (may be outdated)"
    ) ELSE (
        CALL :FAIL "Maven not found and no pre-built WAR exists!"
        echo     Please build the project manually: mvn clean package
        pause
        exit /b 1
    )
)
echo.

REM ─────────────────────────────────────────────────────────────────
REM  STEP 4 — DEPLOY TO TOMCAT
REM ─────────────────────────────────────────────────────────────────
SET /A STEP+=1
echo  [%STEP%/%TOTAL%] Deploying to Tomcat...
echo  ────────────────────────────────────────

IF NOT EXIST "%CATALINA_HOME%\webapps" (
    CALL :FAIL "Tomcat not found at: %CATALINA_HOME%"
    echo     Update CATALINA_HOME in this script.
    pause
    exit /b 1
)

REM Stop any existing Tomcat gracefully
IF EXIST "%CATALINA_HOME%\bin\shutdown.bat" (
    echo     Stopping any existing Tomcat instance...
    CALL "%CATALINA_HOME%\bin\shutdown.bat" >nul 2>&1
    timeout /t 3 /nobreak >nul
)

REM Remove old unpacked webapp for clean deploy
IF EXIST "%CATALINA_HOME%\webapps\reelkaro" (
    rmdir /S /Q "%CATALINA_HOME%\webapps\reelkaro" >nul 2>&1
)

REM Deploy fresh WAR
copy /Y "%WAR_SRC%" "%CATALINA_HOME%\webapps\reelkaro.war" >nul
IF %ERRORLEVEL% EQU 0 (
    CALL :OK "WAR deployed to Tomcat"
) ELSE (
    CALL :FAIL "Could not copy WAR to Tomcat webapps!"
    pause
    exit /b 1
)
echo.

REM ─────────────────────────────────────────────────────────────────
REM  STEP 5 — START TOMCAT
REM ─────────────────────────────────────────────────────────────────
SET /A STEP+=1
echo  [%STEP%/%TOTAL%] Starting Tomcat 10.1...
echo  ────────────────────────────────────────

REM Write a helper bat with all env vars baked in so Tomcat starts reliably
SET TOMCAT_LAUNCHER=%TEMP%\rk_tomcat_launch.bat
(
    echo @echo off
    echo SET JAVA_HOME=%JAVA_HOME%
    echo SET CATALINA_HOME=%CATALINA_HOME%
    echo SET DB_HOST=%DB_HOST%
    echo SET DB_PORT=%DB_PORT%
    echo SET DB_NAME=%DB_NAME%
    echo SET DB_USER=%DB_USER%
    echo SET DB_PASSWORD=%DB_PASSWORD%
    echo SET PATH=%JAVA_HOME%\bin;%%PATH%%
    echo CALL "%CATALINA_HOME%\bin\startup.bat"
) > "%TOMCAT_LAUNCHER%"

REM Stop any existing Tomcat first
CALL "%CATALINA_HOME%\bin\shutdown.bat" >nul 2>&1
timeout /t 2 /nobreak >nul

START "Tomcat-ReelKaro" /MIN "%TOMCAT_LAUNCHER%"
CALL :OK "Tomcat process launched"
echo.

REM ─────────────────────────────────────────────────────────────────
REM  WAIT FOR APP TO COME ONLINE — LIVE PROGRESS BAR
REM ─────────────────────────────────────────────────────────────────
echo  Waiting for ReelKaro to go live at: %APP_URL%
echo  ────────────────────────────────────────────────
echo.

SET /A WAITED=0
SET /A MAX_WAIT=60
SET READY=0

:health_loop
SET /A WAITED+=1
SET /A PCT=WAITED*100/MAX_WAIT

REM Build a simple progress bar
SET BAR=
SET /A BARS=WAITED*30/MAX_WAIT
SET /A REM_BARS=30-BARS
FOR /L %%i IN (1,1,%BARS%)     DO SET BAR=!BAR!█
FOR /L %%i IN (1,1,%REM_BARS%) DO SET BAR=!BAR!░

<nul set /p=  [!BAR!] !PCT!%% — !WAITED!s / !MAX_WAIT!s   ^

REM Check if app is responding
powershell -NoProfile -Command ^
    "try { $r=(Invoke-WebRequest '%APP_URL%' -UseBasicParsing -TimeoutSec 2 -ErrorAction Stop).StatusCode; exit 0 } catch { exit 1 }" >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    SET READY=1
    GOTO :app_ready
)

IF %WAITED% GEQ %MAX_WAIT% GOTO :timeout_warning

timeout /t 1 /nobreak >nul
echo.
GOTO :health_loop

:timeout_warning
echo.
echo.
CALL :WARN "App is taking longer than expected — opening browser anyway..."
GOTO :open_browser

:app_ready
echo.
echo.
CALL :OK "ReelKaro is LIVE!"

:open_browser
echo.
echo  ════════════════════════════════════════════════════════════════════
echo.
echo   🚀  ReelKaro is running!
echo.
echo   URL         : %APP_URL%
echo   Brand Login : Use your brand account email + password
echo   Creator     : Use your creator account email + password
echo.
echo   Database    : reelkaro @ 127.0.0.1:3306  (root, no password)
echo   Tomcat Logs : %CATALINA_HOME%\logs\catalina.out
echo.
echo  ════════════════════════════════════════════════════════════════════
echo.
echo  Opening browser in 2 seconds...
timeout /t 2 /nobreak >nul
start "" "%APP_URL%"

echo.
echo  [Press any key to EXIT this launcher — app will keep running]
pause >nul
exit /b 0

REM ─────────────────────────────────────────────────────────────────
REM  HELPER SUBROUTINES
REM ─────────────────────────────────────────────────────────────────
:OK
echo    [ OK ] %~1
EXIT /B 0

:WARN
echo    [WARN] %~1
EXIT /B 0

:FAIL
echo    [FAIL] %~1
EXIT /B 0

:LOG_STEP
echo    ....  %~1
EXIT /B 0

:WAIT
echo    ....  %~1 (%~2 seconds)...
timeout /t %~2 /nobreak >nul
EXIT /B 0
