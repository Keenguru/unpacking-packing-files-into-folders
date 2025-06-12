@echo off
setlocal enabledelayedexpansion

cls
echo.
echo  __  __                                                        
echo /\ \/\ \           [FILE EXTRACTOR SCRIPT v1.0]                                               
echo \ \ \/'/'     __     __    ___      __   __  __  _ __  __  __  
echo  \ \ ,/ _   /'__`\ /'__`\/' _ `\  /'_ `\/\ \/\ \/\`'_\/\ \/\ \ 
echo   \ \ \\`\ /\  __//\  __//\ \/\ \/\ \L\ \ \ \_\ \ \ \ \ \ \_\ \
echo    \ \_\ \_\ \____\ \____\ \_\ \_\ \____ \ \____/\ \_\ \ \____/
echo     \/_/\/_/\/____/\/____/\/_/\/_/\/___L\ \/___/  \/_/  \/___/ 
echo                                     /\____/                    
echo                                     \_/__/                        
echo ___________________________________________________________________
echo.

echo This script:
echo - Scan all files in folders in the current directory
echo - Move all files in the current directory
echo - Delete all empty folders after moving
echo.
echo ___________________________________________________________________
echo.
echo  WARNING: This will change your file structure!
echo.

:: Confirmation prompt
:confirm
set /p "confirm=Are you sure you want to move all files from subfolders? (Y/N): "
if /i "!confirm!"=="y" goto proceed
if /i "!confirm!"=="n" (
    echo Operation cancelled by user.
    pause
    exit /b
)
echo Please enter Y or N
goto confirm

:proceed
:: Count files before extraction
set initialCount=0
for /f %%a in ('dir /a-d /s /b ^| find /c /v ""') do set initialCount=%%a

if %initialCount% equ 0 (
    echo No files found to move.
    pause
    exit /b
)
echo ___________________________________________________________________
echo.
echo Found %initialCount% files in subfolders.
set /p "continue=Continue with extraction? (Y/N): "
if /i "!continue!" neq "y" (
    echo Operation aborted by user.
    pause
    exit /b
)

:: Extract files from all subfolders
set extracted=0
for /r %%F in (*) do (
    if not "%%~dpF"=="%~dp0" (
        move "%%F" "%~dp0" >nul
        set /a extracted+=1
        echo [!extracted!] Moved: "%%~nxF"
    )
)

:: Count remaining files in subfolders (should be 0)
set remaining=0
for /f %%a in ('dir /a-d /s /b ^| find /c /v ""') do set remaining=%%a

:: Display summary
echo.
echo ___________________________________________________________________
echo.
echo EXTRACTION COMPLETE:
echo - Initial file count: %initialCount%
echo - Files extracted: %extracted%
echo - Files remaining in subfolders: %remaining%
echo - Current directory now contains: %extracted% files
echo ___________________________________________________________________
echo.

:: Optionally remove empty folders
:deletePrompt
set /p "delFolders=Delete empty subfolders? (Y/N): "
if /i "!delFolders!"=="y" (
    echo Removing empty folders...
    set foldersDeleted=0
    for /f "delims=" %%D in ('dir /ad /b /s ^| sort /r') do (
        rd "%%D" 2>nul && (
            echo Deleted folder: "%%D"
            set /a foldersDeleted+=1
        )
    )
    echo Empty folders removed: %foldersDeleted%
    goto end
)
if /i "!delFolders!"=="n" (
    echo Folders were not deleted.
    goto end
)
echo Please enter Y or N
goto deletePrompt

:end
echo.
pause