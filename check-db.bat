@echo off
REM ================================================================
REM  ReelKaro — Quick Database Check
REM  Verifies MySQL is running and shows all stored users
REM ================================================================

set /p MYSQL_PASSWORD="Enter MySQL root password (default: press Enter if blank): "

echo.
echo ================================================================
echo  Database Connection Check
echo ================================================================

echo [1] Testing connection...
mysql -u root -p%MYSQL_PASSWORD% -e "SELECT 'Connected!' AS Status;" 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Cannot connect to MySQL.
    echo Make sure MySQL service is running.
    echo.
    echo  Start MySQL service:
    echo    net start MySQL80
    echo.
    pause
    exit /b 1
)

echo.
echo [2] Tables in reelkaro database:
mysql -u root -p%MYSQL_PASSWORD% -e "USE reelkaro; SHOW TABLES;"

echo.
echo [3] All registered users:
mysql -u root -p%MYSQL_PASSWORD% -e "SELECT id, name, email, role, created_at FROM reelkaro.users ORDER BY created_at DESC;"

echo.
echo [4] All creator profiles:
mysql -u root -p%MYSQL_PASSWORD% -e "SELECT u.name, cp.username, cp.niche, cp.city, cp.state, cp.instagram_handle, cp.followers_count FROM reelkaro.users u JOIN reelkaro.creator_profiles cp ON cp.user_id = u.id;"

echo.
echo [5] All brand profiles:
mysql -u root -p%MYSQL_PASSWORD% -e "SELECT u.name, bp.company_name, bp.industry, bp.website FROM reelkaro.users u JOIN reelkaro.brand_profiles bp ON bp.user_id = u.id;"

echo.
echo ================================================================
pause
