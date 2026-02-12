@echo off
setlocal

REM ── Set script directory ──
set "SCRIPT_DIR=%~dp0"

REM ── Auto-detect python_embeded directory ──
set "PYTHON_DIR="
if exist "%SCRIPT_DIR%python_embeded" (
    set "PYTHON_DIR=%SCRIPT_DIR%python_embeded"
) else if exist "%SCRIPT_DIR%..\python_embeded" (
    set "PYTHON_DIR=%SCRIPT_DIR%..\python_embeded"
) else if exist "%SCRIPT_DIR%python_embedded" (
    set "PYTHON_DIR=%SCRIPT_DIR%python_embedded"
) else if exist "%SCRIPT_DIR%..\python_embedded" (
    set "PYTHON_DIR=%SCRIPT_DIR%..\python_embedded"
)

if not defined PYTHON_DIR (
    echo ERROR: Could not find python_embeded directory.
    echo Searched in:
    echo   %SCRIPT_DIR%python_embeded
    echo   %SCRIPT_DIR%..\python_embeded
    echo   %SCRIPT_DIR%python_embedded
    echo   %SCRIPT_DIR%..\python_embedded
    echo.
    echo Place this script next to or inside your ComfyUI portable folder.
    pause
    exit /b 1
)

echo Found Python directory: %PYTHON_DIR%

REM ── Auto-detect sageattention .whl file ──
set "WHL_FILE="
for %%F in ("%SCRIPT_DIR%sageattention*.whl") do (
    set "WHL_FILE=%%F"
)

if not defined WHL_FILE (
    echo ERROR: No sageattention .whl file found in %SCRIPT_DIR%
    pause
    exit /b 1
)

echo Found wheel: %WHL_FILE%
echo.

REM ── Install triton for Windows ──
echo Installing triton-windows...
"%PYTHON_DIR%\python.exe" -m pip install -U "triton-windows<3.7"

REM ── Copy include/libs for triton ──
set "SOURCE=%SCRIPT_DIR%python_3.13.2_include_libs"
set "DESTINATION=%PYTHON_DIR%"

echo.
echo Copying folders from %SOURCE% to %DESTINATION%...
robocopy "%SOURCE%" "%DESTINATION%" /E /MT:8

if %ERRORLEVEL% LEQ 3 (
    echo Copy completed successfully!
) else (
    echo Error occurred during copy. Error level: %ERRORLEVEL%
)

REM ── Install sageattention ──
echo.
echo Installing sageattention wheel...
"%PYTHON_DIR%\python.exe" -m pip install "%WHL_FILE%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Installation completed successfully!
) else (
    echo Error occurred during installation.
)

REM ── Keep window open ──
echo.
pause
