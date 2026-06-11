@echo off
REM ================================================================
REM  ReelKaro - Start MySQL + Tomcat
REM  Double-click or run from project root
REM ================================================================
setlocal

SET JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.19.10-hotspot
SET MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.4\bin
SET MYSQL_DATA=C:\ProgramData\MySQL\MySQL Server 8.4\Data
SET CATALINA_HOME=C:\tools\apache-tomcat-10.1.20
SET WAR_SRC=%~dp0target\reelkaro.war

REM --- Environment variables for DB connection (read by DBConnection.java) ---
SET DB_HOST=127.0.0.1
SET DB_PORT=3306
SET DB_NAME=reelkaro
SET DB_USER=root
SET "DB_PASSWORD="

echo =====================================================
echo  Step 1: Starting MySQL 8.4...
echo =====================================================
REM Try starting MySQL service (try common service names)
net start MySQL >nul 2>&1
IF ERRORLEVEL 1 net start MySQL84 >nul 2>&1
IF ERRORLEVEL 1 net start MySQL80 >nul 2>&1
IF ERRORLEVEL 1 (
    echo Starting MySQL directly (no service found, trying direct start)...
    START "MySQL Server" /B "%MYSQL_BIN%\mysqld.exe" --defaults-file="C:\ProgramData\MySQL\MySQL Server 8.4\my.ini"
)
timeout /t 8 /nobreak >nul

echo Checking MySQL connection...
"%MYSQL_BIN%\mysqladmin.exe" -u root -h 127.0.0.1 ping 2>nul
IF ERRORLEVEL 1 (
    echo [WARNING] MySQL may not be ready yet. Waiting 5 more seconds...
    timeout /t 5 /nobreak >nul
)

echo =====================================================
echo  Step 2: Deploying WAR to Tomcat...
echo =====================================================
copy /Y "%WAR_SRC%" "%CATALINA_HOME%\webapps\reelkaro.war" >nul
echo WAR deployed.

echo =====================================================
echo  Step 3: Starting Tomcat 10.1...
echo =====================================================
SET PATH=%JAVA_HOME%\bin;%PATH%
call "%CATALINA_HOME%\bin\startup.bat"

echo =====================================================
echo  ReelKaro is starting!
echo  Open: http://localhost:8080/reelkaro/
echo =====================================================
timeout /t 5 /nobreak >nul
start http://localhost:8080/reelkaro/

endlocal
