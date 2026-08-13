# Projeto Programa CLI de Administração de TI - [NOME_DA_EMPRESA]
# Esse Programa tem o objetivo de facilitar a administração da area de TI na empresa
# ele vai centralizar todos os scripts da empresa

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Definindo Functions
function monitoramentoservicos {& "C:\SavageHub\Scripts\MonitoramentoServicos.ps1"}
function LOGS24H {& "C:\SavageHub\Scripts\LOGS24H.ps1"}
function LOGS-RdpCoreTS {& "C:\SavageHub\Scripts\LOGRDPCORETS.ps1"}
function WALLPAPERU {& "C:\SavageHub\Scripts\WallpaperUsers.ps1"}
function menupsr {& "C:\SavageHub\Scripts\Menupsr.ps1"}
function MENUSASV {& "C:\SavageHub\Scripts\StartServices.ps1"}
function MENUEXE {& "C:\SavageHub\Scripts\Servicesexe.ps1"}
function MENUSTPSV {& "C:\SavageHub\Scripts\Stopservices.ps1"}

function HELP { 
    Clear-Host
    Write-Host "___________________________________________________________________________" -ForegroundColor Green
    Write-Host "                        MENU HELP - SavageHub                              " -ForegroundColor Green
    Write-Host "===========================================================================" -ForegroundColor Green
    Write-Host "                            Versão: 1.3                                    " -ForegroundColor Green
    Write-Host "===========================================================================" -ForegroundColor Green
    Write-Host "       [!] COMO USAR:                                                      " -ForegroundColor Yellow
    Write-Host "        Digita o número da função desejada e pressione enter               " -ForegroundColor Green
    Write-Host "`n       [!] Dicas:                                                        " -ForegroundColor Yellow
    Write-Host "        Tenha as Credenciais de Administrador em mãos                      " -ForegroundColor Green
    Write-Host "___________________________________________________________________________" -ForegroundColor Green
    Write-Host " Pressione ENTER para voltar ao menu principal                             " -ForegroundColor Yellow
    [void]((Read-Host).Trim()) 
}

# Abrindo o While (loop)
while ($true) {
    # visual do Programa
    Clear-Host
    write-host "____________________________________________________________________________________________________________" -ForegroundColor Green
    Write-Host "                                  HUB SYSADMIN - [NOME_DA_EMPRESA] (BETA)                                   " -ForegroundColor Green
    Write-Host "____________________________________________________________________________________________________________" -ForegroundColor Green
    Write-Host "                                                  MENU:                                                     " -ForegroundColor Green
    Write-Host "____________________________________________________________________________________________________________" -ForegroundColor Green
    Write-Host "      (1) SCRIPT DE MONITORAMENTO DE SERVIÇOS                                                               " -ForegroundColor Green
    Write-Host "      (2) LOGS 24H do SERVER                                                                                " -ForegroundColor Green
    Write-Host "      (3) LOGS RdpCoreTS                                                                                    " -ForegroundColor Green
    Write-Host "      (4) MENU PS REMOTING                                                                                  " -ForegroundColor Green
    Write-Host "      (5) SCRIPT WALLPAPERS USUARIOS                                                                        " -ForegroundColor Green
    Write-Host "      (6) MENU START SERVICES                                                                               " -ForegroundColor Green
    Write-Host "      (7) MENU START SERVICES EXE                                                                           " -ForegroundColor Green
    Write-Host "      (8) MENU STOP SERVICES                                                                                " -ForegroundColor Green
    Write-Host "      (0) SAIR                                                                                              " -ForegroundColor Red
    Write-Host "____________________________________________________________________________________________________________" -ForegroundColor Green
    
    # Trava/Pergunta ao usuario
    Write-Host "Escolha uma das opções." -ForegroundColor Green
    $escolha = (Read-Host).Trim()
    
    # Definindo o SWITCH 
    switch ($escolha) {
        "1" {monitoramentoservicos}
        "2" {Write-Host "Carregando LOGS das ultimas 24h..." -ForegroundColor Green; Start-Sleep 1; LOGS24H}
        "3" {Write-Host "Carregando LOGS do RdpCoreTS" -ForegroundColor Green; Start-Sleep 1; LOGS-RdpCoreTS}
        "4" {Write-Host "Acessando o Menu de PS REMOTING..." -ForegroundColor Green; Start-Sleep 1; menupsr}
        "5" {Write-Host "Iniciando a mudança de Wallpapers..." -ForegroundColor Green; Start-Sleep 1; WALLPAPERU}
        "6" {Write-Host "Acessando o Menu Start Services..." -ForegroundColor Green; Start-Sleep 1; MENUSASV}
        "7" {Write-Host "Acessando o Menu Start Services EXE..." -ForegroundColor Green; Start-Sleep 1; MENUEXE}
        "8" {Write-Host "Acessando o Menu Stop Services..." -ForegroundColor Green; Start-Sleep 1; MENUSTPSV}
        "0" {Write-Host "Fechando o Hub..." -ForegroundColor Green; Start-Sleep 1; Write-Host "`nAté a proxima!" -ForegroundColor Green; Start-Sleep 2; return}
        "HELP" {Write-Host "Abrindo a AJUDA..." -ForegroundColor Green; Start-Sleep 1; HELP}
        Default {Write-Host "Opção Inválida! Escolha uma opção do Menu." -ForegroundColor Red; Start-Sleep 2}
    }
}