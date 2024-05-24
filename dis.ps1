# Disable Windows Defender real-time monitoring
Set-MpPreference -DisableRealtimeMonitoring $true

Write-Host "Windows Defender real-time monitoring has been disabled."
