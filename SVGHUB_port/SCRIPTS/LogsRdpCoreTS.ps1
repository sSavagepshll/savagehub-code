[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

# Troque os parâmetros de LogName conforme a necessidade do script (System/Application ou RdpCoreTS)
Invoke-Command -Computername [NOME_DO_SERVIDOR] -Credential (Get-Credential Administrator) -ScriptBlock {
    Get-WinEvent -FilterHashtable @{
        LogName   = 'System','Application' # Para o script de RDP use 'Microsoft-Windows-RemoteDesktopServices-RdpCoreTS/Operational'
        Level     = 2,3  # 2=Error, 3=Warning
        StartTime = (Get-Date).AddHours(-24)
    } | Select-Object TimeCreated, Id, LevelDisplayName, Message | Format-Table -AutoSize
}

Write-Host "Pressione Enter para retornar ao menu." -ForegroundColor Green
Read-Host