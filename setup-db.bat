@echo off
REM ================================================================
REM  ReelKaro — MySQL Database Setup Script
REM  Run this ONCE after MySQL is installed and running
REM ================================================================

echo.
echo ================================================================
echo  ReelKaro Database Setup
echo ================================================================
echo.

set /p MYSQL_PASSWORD="Enter your MySQL root password: "

echo.
echo [1/2] Creating database and tables from schema.sql...
mysql -u root -p%MYSQL_PASSWORD% < "%~dp0database\schema.sql"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to run schema.sql.
    echo Make sure MySQL is running and your password is correct.
    pause
    exit /b 1
)

echo.
echo [2/2] Verifying tables were created...
mysql -u root -p%MYSQL_PASSWORD% -e "USE reelkaro; SHOW TABLES;"

echo.
echo ================================================================
echo  SUCCESS! Database is ready.
echo.
echo  Tables created:
echo    - users
echo    - brand_profiles
echo    - creator_profiles
echo    - campaigns
echo    - applications
echo    - submissions
echo    - rewards
echo    - leaderboard_view (view)
echo.
echo  Demo credentials seeded:
echo    Brand:   brand@demo.com   / password123
echo    Creator: creator@demo.com / password123
echo ================================================================
echo.
pause
