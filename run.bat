@echo off
REM Microservices Lab - Build & Run Script (Windows)
REM Usage: run.bat build|up|down|logs

setlocal enabledelayedexpansion

echo.
echo ================================
echo Microservices Lab
echo SLIIT - CTSE Lab 5
echo ================================
echo.

if "%1"=="" (
    echo Usage: run.bat {build^|up^|down^|logs^|status^|test}
    echo.
    echo Commands:
    echo   build   - Build all Docker images
    echo   up      - Start all services
    echo   down    - Stop all services
    echo   logs    - View service logs
    echo   status  - Check service status
    echo   test    - Run basic API tests
    exit /b 1
)

if "%1"=="build" (
    echo Building all services...
    docker-compose build
    echo.
    echo [OK] Build complete!
    goto :eof
)

if "%1"=="up" (
    echo Starting all services...
    docker-compose up -d
    timeout /t 5 /nobreak
    echo.
    echo [OK] Services started!
    echo.
    echo Services running on:
    echo   API Gateway: http://localhost:8080
    echo   Item Service: http://localhost:8081/items
    echo   Order Service: http://localhost:8082/orders
    echo   Payment Service: http://localhost:8083/payments
    goto :eof
)

if "%1"=="down" (
    echo Stopping all services...
    docker-compose down
    echo.
    echo [OK] Services stopped!
    goto :eof
)

if "%1"=="logs" (
    echo Showing logs...
    docker-compose logs -f
    goto :eof
)

if "%1"=="status" (
    echo Service status:
    docker-compose ps
    goto :eof
)

if "%1"=="test" (
    echo Testing services...
    echo.
    echo Testing Item Service GET /items:
    powershell -Command "Invoke-RestMethod -Uri 'http://localhost:8080/items' | ConvertTo-Json"
    echo.
    echo Testing Order Service GET /orders:
    powershell -Command "Invoke-RestMethod -Uri 'http://localhost:8080/orders' | ConvertTo-Json"
    echo.
    echo Testing Payment Service GET /payments:
    powershell -Command "Invoke-RestMethod -Uri 'http://localhost:8080/payments' | ConvertTo-Json"
    goto :eof
)

echo Unknown command: %1
echo Usage: run.bat {build^|up^|down^|logs^|status^|test}
exit /b 1
