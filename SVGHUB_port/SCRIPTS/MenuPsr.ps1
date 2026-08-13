[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Definindo Functions para as Estações
function WORKSTATION_01 {
    $C = "WORKSTATION_01"
    Write-Host "[>>>] Abrindo $C em uma nova janela..." -ForegroundColor Green
    Start-Process pwsh.exe -ArgumentList "-NoExit", "-Command", "Write-Host 'Conectando a $C...' -ForegroundColor Green; Enter-PSSession -ComputerName $C -Credential [USUARIO_ADMIN]"
    Write-Host "[!] Janela externa disparada. O Hub continua ativo." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}
function WORKSTATION_02 {
    $C = "WORKSTATION_02"
    Write-Host "[>>>] Abrindo $C em uma nova janela..." -ForegroundColor Green
    Start-Process pwsh.exe -ArgumentList "-NoExit", "-Command", "Write-Host 'Conectando a $C...' -ForegroundColor Green; Enter-PSSession -ComputerName $C -Credential [USUARIO_ADMIN]"
    Write-Host "[!] Janela externa disparada. O Hub continua ativo." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}
function WORKSTATION_03 {
    $C = "WORKSTATION_03"
    Write-Host "[>>>] Abrindo $C em uma nova janela..." -ForegroundColor Green
    Start-Process pwsh.exe -ArgumentList "-NoExit", "-Command", "Write-Host 'Conectando a $C...' -ForegroundColor Green; Enter-PSSession -ComputerName $C -Credential [USUARIO_ADMIN]"
    Write-Host "[!] Janela externa disparada. O Hub continua ativo." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

function Server { 
    $C = "[NOME_DO_SERVIDOR]"
    Write-Host "[>>>] Abrindo $C em uma nova janela..." -ForegroundColor Green
    Start-Process pwsh.exe -ArgumentList "-NoExit", "-Command", "Write-Host 'Conectando a $C...' -ForegroundColor Green; Enter-PSSession -ComputerName $C -Credential Administrator"
    Write-Host "[!] Janela externa disparada. O Hub continua ativo." -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

function CLIapp {C:\SavageHub\CLI\SavageHub.ps1}

function HELP {
    Clear-Host
    Write-Host "______________________________________________________________" -ForegroundColor Green
    Write-Host "                  MENU HELP - PSREMOTING                      " -ForegroundColor Green
    Write-Host "==============================================================" -ForegroundColor Green
    Write-Host "                      VERSÃO: 1.3                             " -ForegroundColor Green
    Write-Host "==============================================================" -ForegroundColor Green
    Write-Host "    [!] COMO FUNCIONA:                                        " -ForegroundColor Yellow
    Write-Host "     Escolha a opção correspondente ao computador escolhido   " -ForegroundColor Green
    Write-Host "     de ENTER e uma janela vai abrir pedindo credenciais      " -ForegroundColor Green
    Write-Host "______________________________________________________________" -ForegroundColor Green
    Write-Host " Pressione ENTER para voltar...                               " -ForegroundColor Yellow
    [void] ((Read-Host).Trim()) 
}

# Abre o While
While ($true) { 
    clear-host 
    Write-Host "_________________________________________________________________________________________" -ForegroundColor Green
    Write-Host "                                  PS REMOTING ACCESS                                     " -ForegroundColor Green
    Write-Host "_________________________________________________________________________________________" -ForegroundColor Green
    Write-Host "                               Computadores para acesso:                                 " -ForegroundColor Green
    Write-Host "=========================================================================================" -ForegroundColor Green
    Write-Host "         (01) WORKSTATION_01                                                             " -ForegroundColor Green
    Write-Host "         (02) WORKSTATION_02                                                             " -ForegroundColor Green
    Write-Host "         (03) WORKSTATION_03                                                             " -ForegroundColor Green
    Write-Host "         (99) Servidor Principal                                                         " -ForegroundColor Green
    Write-Host "         (0)  Voltar                                                                     " -ForegroundColor Red
    Write-Host "_________________________________________________________________________________________" -ForegroundColor Green
    
    $Pergunta = Read-Host "Escolha uma das opções acima"
    
    Switch ($Pergunta) {
        "01" { WORKSTATION_01 }
        "02" { WORKSTATION_02 }
        "03" { WORKSTATION_03 }
        "99" { Server }
        "0" { Write-Host "Retornando ao Menu Principal..." -ForegroundColor Green; Start-Sleep 2; return}
        "HELP" {Write-Host "Abrindo a AJUDA..." -ForegroundColor Green; Start-Sleep 1; HELP}
        Default { Write-Host "Erro, selecione uma das opções listadas...`n" -ForegroundColor Red; Start-Sleep 1 }
    }
}