@echo off
setlocal enabledelayedexpansion

:: Configuration
set filesPerFolder=100

:: Display initial information
:init
cls
echo.
echo  __  __                                                        
echo /\ \/\ \           [FILE ORGANIZER SCRIPT v1.1]                                               
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
echo - Scan all files in the current directory
echo - Create folders named by file extensions (e.g. mp4_1, exe_1)
echo - Move files in batches of %filesPerFolder% in each folder
echo.
echo ___________________________________________________________________
echo.
echo WARNING: This will change your file structure!
echo.

:: First confirmation prompt
:confirm
set /p "confirm=Do you want to continue? (Y/N): "
if /i "!confirm!"=="y" goto scan
if /i "!confirm!"=="n" (
    echo Operation cancelled.
    pause
    exit /b
)
echo Please enter Y or N
goto confirm

:scan
echo.
echo Scanning files...
set extensions=
set totalFiles=0

:: Count total files and collect extensions
for /f "delims=" %%f in ('dir /b /a-d *.*') do (
    set /a totalFiles+=1
    set "filename=%%~nf"
    set "ext=%%~xf"
    
    :: Handle files without extensions
    if "!ext!"=="" (
        set "ext=_no_extension"
    ) else (
        :: Remove dot from extension
        set "ext=!ext:~1!"
    )
    
    :: Build unique extensions list
    if "!extensions!"=="" (
        set "extensions=!ext!"
    ) else (
        echo !extensions! | find "!ext!" >nul || set "extensions=!extensions! !ext!"
    )
    
    echo Found file !totalFiles!: %%~nxf
)

if %totalFiles%==0 (
    echo No files found to process.
    pause
    exit /b
)

echo.
echo ___________________________________________________________________
echo.
echo Scan complete.
echo Total files found: %totalFiles%
echo File extensions found: !extensions!
echo ___________________________________________________________________
echo.

:: Second confirmation prompt
:confirm2
set /p "confirm=Do you want to proceed with organization? (Y/N): "
if /i "!confirm!"=="y" goto proceed
if /i "!confirm!"=="n" (
    echo Operation cancelled.
    pause
    exit /b
)
echo Please enter Y or N
goto confirm2

:proceed
echo.
echo Starting file organization...
echo.

:: Initialize summary variables
set totalFoldersCreated=0
set totalFilesMoved=0
set processedExtensions=0

:: Process each extension
for %%e in (!extensions!) do (
    set /a folderNumber=1
    set /a fileCount=0
    set /a extFilesMoved=0
    set /a extFoldersCreated=1
    
    :: Prepare folder name
    if "%%e"=="_no_extension" (
        set "folderPrefix=no_extension"
    ) else (
        set "folderPrefix=%%e"
    )
    
    echo Processing %%e files...
    
    :: Create first folder
    if not exist "!folderPrefix!_!folderNumber!" (
        md "!folderPrefix!_!folderNumber!"
        set /a totalFoldersCreated+=1
        echo Created folder: !folderPrefix!_!folderNumber!
    )

    :: Prepare file pattern
    if "%%e"=="_no_extension" (
        set "filePattern=*."
    ) else (
        set "filePattern=*.%%e"
    )
    
    :: Count files for this extension
    set extFileCount=0
    for /f %%a in ('dir /b /a-d !filePattern! ^| find /c /v ""') do set extFileCount=%%a
    
    if !extFileCount! gtr 0 (
        set currentExtFile=0
        echo Files to process: !extFileCount!
        
        :: Move files
        for /f "delims=" %%f in ('dir /b /a-d !filePattern!') do (
            if "%%f" neq "%~nx0" (
                set /a currentExtFile+=1
                set /a totalFilesMoved+=1
                set /a extFilesMoved+=1
                
                echo Moving file !currentExtFile! of !extFileCount! [%%e]
                
                if !fileCount! equ !filesPerFolder! (
                    set /a folderNumber+=1
                    set /a fileCount=0
                    set /a extFoldersCreated+=1
                    set /a totalFoldersCreated+=1
                    md "!folderPrefix!_!folderNumber!" >nul
                    echo Created folder: !folderPrefix!_!folderNumber!
                )
                move "%%f" "!folderPrefix!_!folderNumber!\" >nul
                set /a fileCount+=1
            )
        )
    )
    
    set /a processedExtensions+=1
    echo Processed: !extFilesMoved! %%e files in !extFoldersCreated! folder(s)

:: Display summary
echo.
echo ___________________________________________________________________
echo ORGANIZATION COMPLETE:
echo - Total extensions processed: !processedExtensions!
echo - Total files moved: !totalFilesMoved! / %totalFiles%
echo - Total folders created: !totalFoldersCreated!
echo - Original file extensions: !extensions!
echo ___________________________________________________________________
echo.
echo All files have been organized successfully!
echo.
pause