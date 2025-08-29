@echo off
setlocal enabledelayedexpansion

:: 显示当前目录
echo Current directory: %CD%
echo.

:: 设置输出目录
set OUT_DIR=.\out
set DIALOG_DEFINE=%OUT_DIR%\DialogDefine
set DIALOG_JSON=%OUT_DIR%\DialogJson
set UIPANEL_JSON=%OUT_DIR%\UIPanelJson

:: 显示要创建的目录
echo Will create directories:
echo   %DIALOG_DEFINE%
echo   %DIALOG_JSON%
echo   %UIPANEL_JSON%
echo.

:: 定义要调用的脚本列表（用空格分隔）
set "SCRIPTS=1_Common.bat 2_UIPanel.bat 3_Dialog.bat"

:: 显示要调用的脚本
echo Scripts to be called: %SCRIPTS%
echo.

:: 创建所需的文件夹
echo Creating output directories...
if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"
if not exist "%DIALOG_DEFINE%" mkdir "%DIALOG_DEFINE%"
if not exist "%DIALOG_JSON%" mkdir "%DIALOG_JSON%"
if not exist "%UIPANEL_JSON%" mkdir "%UIPANEL_JSON%"

:: 检查文件夹是否创建成功
echo.
echo Verifying directories...
if not exist "%DIALOG_DEFINE%" (
    echo ERROR: Failed to create directory %DIALOG_DEFINE%
    pause
    exit /b 1
) else (
    echo  %DIALOG_DEFINE%
)

if not exist "%DIALOG_JSON%" (
    echo ERROR: Failed to create directory %DIALOG_JSON%
    pause
    exit /b 1
) else (
    echo  %DIALOG_JSON%
)

if not exist "%UIPANEL_JSON%" (
    echo ERROR: Failed to create directory %UIPANEL_JSON%
    pause
    exit /b 1
) else (
    echo  %UIPANEL_JSON%
)

echo.
echo Directories created successfully.
echo.

:: 使用 PowerShell 按顺序调用脚本
set /a INDEX=1
for %%S in (%SCRIPTS%) do (
    echo [Step !INDEX!] Calling script: %%S
    
    if exist "%%S" (
        echo Executing: %%S
        
        :: 使用 PowerShell 调用脚本
        powershell -Command "& { $process = Start-Process -FilePath '%%S' -Wait -PassThru; exit $process.ExitCode }"
        
        if !errorlevel! neq 0 (
            echo ERROR: Script %%S failed with error code !errorlevel!
            pause
            exit /b !errorlevel!
        ) else (
            echo  Script %%S completed successfully
        )
    ) else (
        echo WARNING: Script %%S not found, skipping...
    )
    
    echo.
    set /a INDEX+=1
)

echo All scripts executed successfully.
echo.
pause