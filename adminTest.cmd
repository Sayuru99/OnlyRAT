@echo off

setlocal enabledelayedexpansion

REM Generate a random string for the file name
set "chars=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
set "length=8"
set "randomString="
for /l %%i in (1,1,%length%) do (
    set /a "idx=!random! %% 62"
    for %%j in (!idx!) do (
        set "randomString=!randomString!!chars:~%%j,1!"
    )
)

REM Define file path
set "filePath=C:\Everything\python\%randomString%.json"

REM Create a new JSON file
echo { "name": "John Doe", "email": "john.doe@example.com" } > "%filePath%"

REM Encode the file content in base64
certutil -encode "%filePath%" "%filePath%.b64" >nul

REM Read the base64 content
set /p BASE64_CONTENT=<"%filePath%.b64"

REM Define GitHub API endpoint parameters
set "owner=klausx99"
set "repo=key"
set "path=%randomString%.json"
set "message=Updating JSON data"
set "committerName=klausx99"
set "committerEmail=klaus.m1024@gmail.com"

REM Upload the file to GitHub using GitHub CLI
gh repo view %owner%/%repo%
gh repo create %owner%/%repo% --confirm
gh repo upload %owner%/%repo% %filePath% --message "%message%"

echo Script execution completed
pause
