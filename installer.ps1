
function random_text {
    param ($text)
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
}


cd $env:TEMP
$directory_name = random_text
mkdir $directory_name