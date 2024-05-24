@echo off

REM Save the current directory
set "initialPath=%cd%"

REM Change to the target directory
cd /d "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

REM Create the popup.vbs file
(echo MsgBox "Line 1" ^& vbCrLf ^& "Line 2",262192, "Title")> popup.vbs

REM Go back to the initial directory
cd /d "%initialPath%"
del initial.cmd
REM Optionally, display the current directory to verify the change
echo Current directory is now %cd%
