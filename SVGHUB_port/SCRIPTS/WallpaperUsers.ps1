[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# --- Definindo as Variaveis (Sanitizadas para o Portfólio) ---
$TodosUsuarios = @(
    "WORKSTATION_01",
    "WORKSTATION_02",
    "WORKSTATION_03",
    "WORKSTATION_04",
    "WORKSTATION_05"
)

$UserName = "[USUARIO_ADMIN]" 
$Password = Read-Host -Prompt "Digite a senha para o usuario ${UserName}:" -AsSecureString
$Credencial = New-Object System.Management.Automation.PSCredential($UserName, $Password)

$CaminhoOrigem = "\\[SERVIDOR_IP]\Share_TI\Wallpaper_Corp.PNG"
$DimensaoWallpaper = 2 # 2=Esticado/Ampliado

# --- Ações do Script --- 
Write-Host "Iniciando com a conexão nos computadores..." -ForegroundColor Green

foreach ($Computador in $TodosUsuarios) { 
    Write-Host "--------------------------------------"
    Write-Host "Conectando em: $Computador" -NoNewline
    try {
        if (-not (Test-Connection -ComputerName $Computador -Count 1 -Quiet -ErrorAction Stop)) {
            throw "Host Inacessível"       
        }
        Invoke-Command -ComputerName $Computador -Credential $Credencial -ScriptBlock {
            param ($img, $estilo)
                         
            Write-Output " > Conectado. Iniciando varredura..."
            
            # --- Lógica de Usuários Online (HKCU via SID) ---
            $registryPathBase = "Registry::HKEY_USERS"
            $loggedSIDs = Get-ChildItem -Path $registryPathBase | Where-Object { $_.PSChildName -match '^S-1-5-21-.*$' }
                         
            foreach ($sid in $loggedSIDs) {
                $path = "$registryPathBase\$($sid.PSChildName)\Control Panel\Desktop"
                if (Test-Path $path) {
                    Set-ItemProperty -Path $path -Name Wallpaper -Value $img -Force
                    Set-ItemProperty -Path $path -Name WallpaperStyle -Value $estilo -Force
                    Set-ItemProperty -Path $path -Name TileWallpaper -Value 0 -Force
                    Write-Output "   [OK] Alterado perfil ONLINE: $($sid.PSChildName)"
                }
            }
            
            # --- Lógica de Usuários Offline (Carregando NTUSER.DAT) ---
            $usersFolder = Get-ChildItem "C:\Users" -Directory | Where-Object { $_.Name -notin "Public", "Default", "All Users", "Default User" }
            
            foreach ($folder in $usersFolder) {
                $hivePath = "$($folder.FullName)\NTUSER.DAT"
                $tempKeyName = "TempHive_$($folder.Name)"
                                 
                if (Test-Path $hivePath) {
                    reg load "HKU\$tempKeyName" "$hivePath" 2>$null | Out-Null
                                         
                    if (Test-Path "Registry::HKEY_USERS\$tempKeyName") {
                        try {
                            $offlinePath = "Registry::HKEY_USERS\$tempKeyName\Control Panel\Desktop"
                            if (Test-Path $offlinePath) {
                                Set-ItemProperty -Path $offlinePath -Name Wallpaper -Value $img -Force
                                Set-ItemProperty -Path $offlinePath -Name WallpaperStyle -Value $estilo -Force
                                Set-ItemProperty -Path $offlinePath -Name TileWallpaper -Value 0 -Force
                                Write-Output "   [OK] Alterado perfil OFFLINE: $($folder.Name)"
                            }
                        }
                        finally {
                            [gc]::Collect() # Força limpeza de memória para soltar o arquivo
                            reg unload "HKU\$tempKeyName" | Out-Null
                        }
                    }
                }
            }
                         
            # Força a atualização visual para o usuário logado
            RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
            
        } -ArgumentList $CaminhoOrigem, $DimensaoWallpaper 
                 
        Write-Host " -> Concluído com sucesso." -ForegroundColor Green
    }
    catch {
        Write-Host " -> ERRO: $_" -ForegroundColor Red
    }
}
Write-Host "Pressione Enter para retornar para o Menu." -ForegroundColor Green
Start-Sleep 2
Read-Host