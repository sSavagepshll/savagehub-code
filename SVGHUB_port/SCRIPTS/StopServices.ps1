# Inicio do Script

function Stop-ERP-Service-01 {
    $ComandoICM = "try { Invoke-Command -ComputerName [NOME_DO_SERVIDOR] -Credential (Get-Credential Administrator) -ScriptBlock { Stop-Service '[ERP_DBAccess]' -ErrorAction Stop } -ErrorAction Stop; Write-Host '`n[+] Serviço iniciado com sucesso!' -ForegroundColor Green; Start-Sleep -Seconds 2 } catch { Write-Host '`n[-] O SERVIDOR RETORNOU O SEGUINTE ERRO:' `$_.Exception.Message -ForegroundColor Red; Read-Host '`nPressione ENTER para fechar' }"
    Start-Process pwsh -ArgumentList "-NoProfile -Command `"$ComandoICM`""
}

function Stop-ERP-Service-02 {
    $ComandoICM = "try { Invoke-Command -ComputerName [NOME_DO_SERVIDOR] -Credential (Get-Credential Administrator) -ScriptBlock { Stop-Service '[ERP_AppServer_Master]' -ErrorAction Stop } -ErrorAction Stop; Write-Host '`n[+] Serviço iniciado com sucesso!' -ForegroundColor Green; Start-Sleep -Seconds 2 } catch { Write-Host '`n[-] O SERVIDOR RETORNOU O SEGUINTE ERRO:' `$_.Exception.Message -ForegroundColor Red; Read-Host '`nPressione ENTER para fechar' }"
    Start-Process pwsh -ArgumentList "-NoProfile -Command `"$ComandoICM`""
}

function Stop-ERP-Service-03 {
    $ComandoICM = "try { Invoke-Command -ComputerName [NOME_DO_SERVIDOR] -Credential (Get-Credential Administrator) -ScriptBlock { Stop-Service '[ERP_RestHttp]' -ErrorAction Stop } -ErrorAction Stop; Write-Host '`n[+] Serviço iniciado com sucesso!' -ForegroundColor Green; Start-Sleep -Seconds 2 } catch { Write-Host '`n[-] O SERVIDOR RETORNOU O SEGUINTE ERRO:' `$_.Exception.Message -ForegroundColor Red; Read-Host '`nPressione ENTER para fechar' }"
    Start-Process pwsh -ArgumentList "-NoProfile -Command `"$ComandoICM`""
}

while ($true) {
    Clear-Host
    Write-Host "__________________________________________________" -ForegroundColor Green
    Write-Host "             Menu de Iniciar Serviços             " -ForegroundColor Green
    Write-Host "__________________________________________________" -ForegroundColor Green
    Write-Host "==================================================" -ForegroundColor Green
    Write-Host " [  1 ] - ERP DBAccess                            " -ForegroundColor Green
    Write-Host " [  2 ] - ERP AppServer Master                    " -ForegroundColor Green
    Write-Host " [  3 ] - ERP RestHttp                            " -ForegroundColor Green
    Write-Host " [  0 ] - Voltar para o menu principal            " -ForegroundColor Red
    Write-Host "==================================================" -ForegroundColor Green
         
    Write-Host "`nSelecione um dos serviços para parar (Separe por vírgula para mais de um)" -ForegroundColor Green
    $pergunta = (Read-Host).Trim()
    $ListaDeServicos = $pergunta -split ","
    
    foreach ($item In $ListaDeServicos) {
        switch ($item.Trim()) {
            "0"  {Write-Host "Voltando ao menu principal" -ForegroundColor Green; Start-Sleep 2; Return}
            '1'  { Stop-ERP-Service-01 }
            '2'  { Stop-ERP-Service-02 }
            '3'  { Stop-ERP-Service-03 }
            default { Write-Host "`n[-] Opção inválida!" -ForegroundColor Red; Start-Sleep -Seconds 2 }
        }
    }
}