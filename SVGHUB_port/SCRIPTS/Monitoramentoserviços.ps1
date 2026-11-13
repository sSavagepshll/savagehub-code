# --- Força a execução em uma nova janela do PowerShell 7 (pwsh) ---
if ($args[0] -ne 'NovaJanela') {
    Start-Process pwsh -ArgumentList "-File `"$PSCommandPath`" NovaJanela"
    return
}
# -------------------------------------------------------------------

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Import-Module Microsoft.PowerShell.Management -UseWindowsPowerShell

# --- Configurações Iniciais ---
$ServerName = "Server"

# Lista dos serviços a monitorar genéricos para o portfólio
$ServiceList = @(
    "[ERP_DB_SERVICE]",
    "[ERP_ServerMaster]",
    "[ERP_RestHttp]",
    "[ERP_INTEGRATION_SERVICE]",
    "[ERP_AUX_SERVICE]",
    "[ERP_AppServer_00]",
    "[ERP_AppServer_01]",
    "[ERP_AppServer_02]"
)

$IntervalSeconds = 60
$EventLogSource = "MonitoramentoERP"
$EventLogName   = "Application"

Add-Type -AssemblyName System.Windows.Forms

try {
    New-EventLog -Source $EventLogSource -LogName $EventLogName -ErrorAction Stop
    Write-Host "Fonte de evento '$EventLogSource' criada com sucesso." -ForegroundColor Green
} catch {
    Write-Host "Fonte de evento '$EventLogSource' já existe ou sem permissão para criar. Continuando..." -ForegroundColor Yellow
}

Write-Host "`n[!] AUTENTICAÇÃO NECESSÁRIA PARA O SERVIDOR $ServerName" -ForegroundColor Cyan
$Usuario = "Administrator"
$SenhaSegura = Read-Host "Digite a senha para o usuário $Usuario" -AsSecureString
$ServerCredential = New-Object System.Management.Automation.PSCredential ($Usuario, $SenhaSegura)

Write-Host "`nIniciando monitoramento de $($ServiceList.Count) serviços no servidor '$ServerName'..." -ForegroundColor Green

while ($true) {
    Write-Host "`n--- Iniciando nova verificação às $(Get-Date) ---" -ForegroundColor Green
         
    try {
        $session = New-PSSession -ComputerName $ServerName -Credential $ServerCredential -ErrorAction Stop
    } catch {
        $alertMessage = "ERRO GRAVE: Não foi possível conectar ao servidor $ServerName. Verifique a rede e o WinRM (porta 5985)."
                 
        Write-EventLog -LogName $EventLogName -Source $EventLogSource -EventID 1000 -EntryType Error -Message $alertMessage
        $notify = New-Object System.Windows.Forms.NotifyIcon
        $notify.Icon = [System.Drawing.SystemIcons]::Error
        $notify.Visible = $true
        $notify.ShowBalloonTip(5000, "ERRO DE CONEXÃO WINRM", $alertMessage, [System.Windows.Forms.ToolTipIcon]::Error)
                 
        Start-Sleep -Seconds $IntervalSeconds
        continue 
    }

    foreach ($serviceName in $ServiceList) {
        try {
            $service = Invoke-Command -Session $session -ScriptBlock {
                Get-Service -Name $using:serviceName -ErrorAction Stop
            }
            if ($service.Status -eq 'Stopped') {
                $alertMessage = "O serviço '$serviceName' está PARADO no servidor '$ServerName'."
                                 
                Write-EventLog -LogName $EventLogName -Source $EventLogSource -EventID 1001 -EntryType Warning -Message $alertMessage
                $notify = New-Object System.Windows.Forms.NotifyIcon
                $notify.Icon = [System.Drawing.SystemIcons]::Error
                $notify.Visible = $true
                $notify.ShowBalloonTip(5000, "ALERTA DE SERVIÇO PARADO!", $alertMessage, [System.Windows.Forms.ToolTipIcon]::Error)
                Write-Host "ALERTA: $alertMessage" -ForegroundColor Red
            } else {
                Write-Host " [OK] Serviço '$serviceName' está Rodando." -ForegroundColor Green
            }
        }
        catch {
             $errorMessage = "ERRO ao verificar o serviço '$serviceName'. Ele pode não existir no servidor. Erro: $($_.Exception.Message)"
             Write-EventLog -LogName $EventLogName -Source $EventLogSource -EventID 1002 -EntryType Error -Message $errorMessage
             Write-Host $errorMessage -ForegroundColor Yellow
        }
    }
         
    Remove-PSSession -Session $session | Out-Null
    Write-Host "--- Verificação concluída. Próxima verificação em $IntervalSeconds segundos ---" -ForegroundColor Green
    Write-Host "[!] Pressione 'Q' a qualquer momento para voltar ao Menu Principal." -ForegroundColor Yellow
         
    while ([System.Console]::KeyAvailable) {
        $null = [System.Console]::ReadKey($true)
    }
    
    $TempoDecorrido = 0
    while ($TempoDecorrido -lt $IntervalSeconds) {
        Start-Sleep -Seconds 1
        $TempoDecorrido++
                 
        if ([System.Console]::KeyAvailable) {
            $Tecla = [System.Console]::ReadKey($true)
            if ($Tecla.Key -eq 'Q') {
                Write-Host "`n[!] Comando de saída recebido. Retornando ao Hub..." -ForegroundColor Yellow
                Start-Sleep -Seconds 1
                return
            }
        }
    }
}