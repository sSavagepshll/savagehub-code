# Savage Hub - CLI de Administração de TI Centralizada

**Autor:** Guilherme dos Anjos Luz  
**Tipo de Projeto:** Automação de Infraestrutura e Gerenciamento Remoto  
**Linguagem Principal:** PowerShell 7.x  

## 📌 O Problema
Em um ambiente corporativo sem o suporte de ferramentas caras de RMM (Remote Monitoring and Management) ou um controlador de domínio (Active Directory) estruturado para envio de políticas de grupo (GPOs), a administração de dezenas de estações de trabalho e o monitoramento de serviços críticos de ERP tornam-se tarefas manuais, lentas e reativas. A equipe de TI precisava de uma forma centralizada e ágil para gerenciar máquinas locais e servidores sem interromper o fluxo de trabalho.

## 💡 A Solução
Desenvolvimento do **Savage Hub**, uma aplicação modular de linha de comando (CLI) construída inteiramente em PowerShell 7. O sistema atua como um painel central de controle na máquina do administrador, utilizando WinRM (Windows Remote Management) para disparar comandos, monitorar instâncias e aplicar configurações em massa em estações de rede (Workgroup) e servidores.

## 🛠️ Tecnologias e Recursos Utilizados
*   **PowerShell 7 (Core) & PS 5.1 (Legacy):** Uso de pontes de compatibilidade (`-UseWindowsPowerShell`) para módulos clássicos do Windows.
*   **WinRM & PSSession:** Gerenciamento remoto seguro de estações e servidores.
*   **Manipulação de Registro do Windows (Regedit):** Edição avançada de colmeias (`NTUSER.DAT` / `HKU` / `HKCU`) para usuários offline e online.
*   **Integração com Event Viewer:** Criação de logs customizados no sistema e coleta remota de eventos.
*   **Automação de UI (Windows Forms):** Geração de pop-ups de alerta em tempo real no desktop do administrador.

## 🚀 Principais Módulos Desenvolvidos

1.  **Monitoramento Ativo de Serviços Críticos (Daemon):**
    *   Script em loop infinito que verifica o status de dezenas de serviços do ERP (AppServers, Bancos de Dados, WebServices) no servidor.
    *   Em caso de queda, o sistema registra um erro no Event Viewer local e dispara uma notificação visual (BalloonTip na bandeja do sistema) alertando a equipe instantaneamente.
2.  **Acesso Remoto Interativo (Menu PSR):**
    *   Interface via terminal que lista todas as estações da empresa. Ao selecionar uma máquina, o Hub dispara uma nova janela isolada via `Enter-PSSession`, permitindo suporte via linha de comando invisível ao usuário final.
3.  **Orquestração de Serviços (Start/Stop/Exec):**
    *   Módulo para reiniciar, parar ou forçar a execução de processos críticos no servidor remotamente, lidando com autenticação e tratamento de erros (Try/Catch).
4.  **Distribuição de Wallpaper em Massa (GPO Alternative):**
    *   *Destaque Técnico:* Sem um Active Directory para aplicar GPOs, o script varre todas as máquinas da rede. Para usuários logados, injeta chaves no `HKCU`. Para usuários deslogados, o script monta temporariamente o arquivo `NTUSER.DAT` (Registro Offline), injeta a configuração de papel de parede corporativo e desmonta a colmeia de forma segura, forçando a atualização visual via `RUNDLL32.EXE`.
5.  **Log Harvester:**
    *   Módulo de extração de logs do Event Viewer (`RdpCoreTS`, `System`, `Application`) das últimas 24 horas das máquinas alvo, facilitando o troubleshooting de quedas de conexão RDP.

## 📈 Resultados e Impacto
*   **Redução drástica no tempo de resposta (SLA):** Quedas de serviços do ERP passaram a ser notificadas imediatamente, permitindo ação da TI antes mesmo da abertura de chamados pelos usuários.
*   **Eficiência Operacional:** Tarefas que exigiam deslocamento físico até as estações (como troca de papel de parede corporativo ou checagem de logs) foram reduzidas a 2 ou 3 toques no teclado.
*   **Padronização:** Criação de um ambiente de TI mais auditável e controlado, mesmo operando em uma rede Workgroup.