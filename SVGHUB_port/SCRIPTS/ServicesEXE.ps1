# Inicio do Script
$CredencialServer = $null 

function Execute-ERP-AppServer {
    Invoke-Command -ComputerName [NOME_DO_SERVIDOR] -Credential $CredencialServer -ScriptBlock {& "[CAMINHO_DO_ERP]\bin\[APP_SERVER_DIR]\[ERP_EXECUTABLE].exe"}
    Write-Host "Pressione Enter para ir para o proximo..." -ForegroundColor Green
    Read-host
}

function Execute-ERP-RestHTTP {
    Invoke-Command -Computername [NOME_DO_SERVIDOR] -Credential $CredencialServer -ScriptBlock {& "[CAMINHO_DO_ERP]\bin\[REST_SERVER_DIR]\[ERP_EXECUTABLE].exe"}
    Write-Host "Pressione Enter para ir para o proximo..." -ForegroundColor Green
    Read-host
}

while ($true) {
    Clear-Host
    Write-Host "___________________________________________________" -ForegroundColor Green
    Write-Host "                MENU SERVIÇOS EXE                  " -ForegroundColor Green 
    Write-Host "===================================================" -ForegroundColor Green
    Write-Host "  [ 1] INICIAR ERP APPSERVER                       " -ForegroundColor Green
    Write-Host "  [ 2] INICIAR ERP REST HTTP                       " -ForegroundColor Green
    Write-Host "  [ 0] MENU PRINCIPAL                              " -ForegroundColor Red
    Write-Host "___________________________________________________" -ForegroundColor Green
    Write-Host "`nEscolha um serviço para executar:                " -ForegroundColor Green
    
    $Pergunta = (Read-Host).Trim()
    $lista = $Pergunta -split ","
    
    # LÓGICA DE CREDENCIAL ÚNICA
    if ($CredencialServer -eq $null -and $Pergunta -match "1|2") {
        Write-Host "`n[!] Autenticação necessária no Servidor." -ForegroundColor Yellow
        $CredencialServer = Get-Credential "Administrator"
    }
    
    foreach ($item in $lista) {
        Switch($item.Trim()) {
            "0" { Write-Host "Voltando ao Menu Principal..." -ForegroundColor Green; Start-Sleep 2; Return }
            "1" { Execute-ERP-AppServer }
            "2" { Execute-ERP-RestHTTP }
            Default {
                if ($item.Trim() -ne "") {
                    Write-Host "Opção [$item] Inválida." -ForegroundColor Red; Start-Sleep 2
                }
            }
        }
    }
}