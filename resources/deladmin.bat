@echo off
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /f /v WinSystem

net user WinSystem /delete

REM Exit
exit
