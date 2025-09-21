@SET EXCEL_FOLDER=.\excel\Client\DialogExecl
@SET JSON_FOLDER=.\out\DialogJson
@SET CODE_FOLDER=.\out\DialogDefine
@SET EXE=.\excel2json.exe

:: josn文件要复制到的目的地
@SET DEST_FOLDER_1=..\..\MMORPG-Client\MMORPG\Assets\Res\Files\Data\Dialog

:: 创建目标文件夹（如果不存在）
@IF NOT EXIST "%EXCEL_FOLDER%" mkdir "%EXCEL_FOLDER%"
@IF NOT EXIST "%JSON_FOLDER%" mkdir "%JSON_FOLDER%"
@IF NOT EXIST "%CODE_FOLDER%" mkdir "%CODE_FOLDER%"
@IF NOT EXIST "%DEST_FOLDER_1%" mkdir "%DEST_FOLDER_1%"

:: execl转json和生成对应的define文件
@ECHO Converting excel files in folder %EXCEL_FOLDER% ...
for %%i in ("%EXCEL_FOLDER%\*.xlsx") do (
    @echo   processing %%~nxi 
    @CALL %EXE% --excel "%%i" --json "%JSON_FOLDER%\%%~ni.json" --csharp "%CODE_FOLDER%\%%~ni.cs" --header 3 --exclude_prefix #
)

:: 复制json文件
@ECHO Copying JSON files to destination folder %DEST_FOLDER% ...
for /r %JSON_FOLDER% %%i in (*.json) do (
    @echo   copying %%~nxi 
    @COPY "%%i" "%DEST_FOLDER_1%\%%~nxi"
)

echo "OK"
exit /b 0