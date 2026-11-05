#requires -Version 5.1
<#
.SYNOPSIS
Diagnostico e manutencao conservadora do Windows 11. Versao 1.0 - 18/09/2026.
.DESCRIPTION
Preparado para Daniel Santos. Execute no Windows PowerShell 5.1 de 64 bits.
Sem parametros: menu interativo. -Modo Diagnostico apenas coleta informacoes.
Os relatorios ficam em LOCALAPPDATA\ManutencaoWin11\data-hora.

REPARO PADRAO (-Modo Reparar, como administrador):
  1. Diagnostico e tentativa de ponto de restauracao (pode estar desabilitado).
  2. DISM /Online /Cleanup-Image /RestoreHealth e SFC /scannow.
  3. CHKDSK /scan nas unidades NTFS selecionadas (pode corrigir erros online).
  4. Otimizacao /O somente nas unidades cuja verificacao terminou sem erros.
  Padrao: somente a unidade do Windows. Para incluir outra: -Unidades C,D.
  Nao reinicia automaticamente. Feche aplicativos e salve seu trabalho antes.
  DISM pode usar Windows Update; mantenha internet e alimentacao estaveis.

ATALHOS:
  O diagnostico examina .lnk na area de trabalho, Menu Iniciar e atalhos fixados
  legados. O Windows 11 tambem tem fixacoes modernas que nao sao arquivos .lnk.
  Nao apaga links e nao adivinha onde um programa foi instalado.
  -Modo Atalho -Atalho 'C:\...\Programa.lnk' -JanelaNormal
  -Modo Atalho -Atalho 'C:\...\Programa.lnk' -NovoDestino 'C:\...\Programa.exe'
  -CorrigirIcone usa o executavel como icone, somente quando solicitado.
  Preserva argumentos. Confira-os: executaveis movidos podem exigir novos argumentos.
  Antes de alterar, salva o .lnk original e um JSON com os caminhos e hashes.
  Para desfazer: -Modo RestaurarAtalho -Backup 'C:\...\atalho-GUID.json'.

JANELAS ATRAS DE OUTRAS:
  WindowStyle=7 significa iniciar minimizado; -JanelaNormal muda para 1.
  Uma janela aberta atras de outra nao e necessariamente minimizada. O Windows
  limita roubo de foco, e aplicativos podem lembrar sua ultima posicao/estado.
  O diagnostico registra ajustes de foco e trechos das configuracoes do Terminal.
  Nao define ForegroundLockTimeout=0 nem forca janelas sempre no topo.
  No Terminal, teste Configuracoes > Inicializacao > nova janela e modo padrao.
  Teste tambem o Host do Console do Windows como aplicativo de terminal padrao.
  Se so o terminal falhar, compare iniciar powershell.exe -NoProfile e cmd.exe /d.
  /d ignora AutoRun do CMD; -NoProfile ignora perfis do PowerShell.

MEMORIA, HIBERNACAO E LIMPEZA:
  Mantem pagefile.sys/swapfile.sys, compressao de memoria, SysMain e indexacao.
  -Modo PaginacaoAutomatica habilita gerenciamento automatico; exige reinicio.
  Registra configuracao anterior. Para voltar a tamanhos personalizados use
  SystemPropertiesAdvanced.exe > Desempenho > Avancado > Memoria virtual.
  -Modo Hibernacao -Estado Desativar libera hiberfil.sys e desativa hibernacao,
  Inicializacao Rapida e a disponibilidade de suspensao hibrida. Nao e um ganho
  garantido de velocidade. -Estado Ativar reativa hibernacao; tamanho/tipo e
  configuracao de Inicializacao Rapida anteriores nao sao restaurados automaticamente.
  -Modo Limpeza abre a Limpeza de Disco: voce escolhe o que excluir. Nao marca
  categorias nem esvazia Downloads/Lixeira por conta propria. Exclusao e definitiva.
  Nao limpa Prefetch, caches de aplicativos, senhas, cookies ou Windows.old.

MENU INICIAR E CONTEXTO:
  -Modo MenuIniciar registra apenas o pacote StartMenuExperienceHost existente.
  Execute SEM elevacao, na conta afetada. Nao reinstala todos os aplicativos.
  Se estiver em uso e falhar, encerre a sessao, entre novamente e tente.
  Nao apaga fixacoes, bancos do Menu Iniciar nem configuracoes do Explorer.
  O inventario do menu de contexto inclui handlers COM legados e verbos shell;
  extensoes modernas empacotadas podem nao aparecer. Nao remove extensoes em massa.
  Para isolar uma extensao lenta: Sysinternals Autoruns, guia Explorer, ocultar
  entradas Microsoft, testar uma extensao de terceiro por vez e reativar depois.
  Preserve extensoes e servicos do Bitdefender. Nao use exclusoes amplas no antivirus.

LIMITES E RECUPERACAO:
  Ponto de restauracao nao e backup de dados e pode nao ser criado.
  DISM, SFC, CHKDSK e otimizacao nao possuem desfazer por este script.
  O script nao promete resolver falhas de hardware, drivers ou todo roubo de foco.
  Codigos de saida sao registrados; SFC exige ler a conclusao e o CBS.log.
  Relatorios podem conter nomes de usuario, caminhos e comandos de inicializacao.
  Nao envie os relatorios completos sem revisar seu conteudo.
  Nao altera Bitdefender, firewall, UAC, servicos, BCD ou plano de energia.
  Nao usa Win32_Product (que pode acionar reparos MSI) e nao limpa o Registro.

FONTES OFICIAIS:
  https://learn.microsoft.com/windows-hardware/manufacture/desktop/repair-a-windows-image
  https://learn.microsoft.com/windows-server/administration/windows-commands/defrag
  https://learn.microsoft.com/troubleshoot/windows-client/performance/introduction-to-the-page-file
  https://learn.microsoft.com/windows/win32/api/winuser/nf-winuser-setforegroundwindow
  https://learn.microsoft.com/windows/terminal/customize-settings/startup
  https://learn.microsoft.com/troubleshoot/windows-client/shell-experience/troubleshoot-start-menu-errors
  https://learn.microsoft.com/sysinternals/downloads/autoruns
.EXAMPLE
.\Manutencao_Windows11_Daniel_v1.ps1 -Modo Diagnostico
.EXAMPLE
.\Manutencao_Windows11_Daniel_v1.ps1 -Modo Reparar -Unidades C,D
#>
[CmdletBinding()]
param(
    [ValidateSet('Menu','Diagnostico','Reparar','Otimizar','Atalho','RestaurarAtalho',
        'MenuIniciar','PaginacaoAutomatica','Hibernacao','Limpeza')]
    [string]$Modo = 'Menu',
    [ValidatePattern('^[A-Za-z]$')][string[]]$Unidades,
    [string]$Atalho,
    [string]$NovoDestino,
    [switch]$JanelaNormal,
    [switch]$CorrigirIcone,
    [string]$Backup,
    [ValidateSet('Ativar','Desativar')][string]$Estado,
    [switch]$Ajuda
)

if ($Ajuda) { Get-Help $PSCommandPath -Full; return }
if ($env:OS -ne 'Windows_NT') { throw 'Este script requer Windows 11.' }
if (-not [Environment]::Is64BitProcess -or $PSVersionTable.PSEdition -ne 'Desktop') {
    throw 'Use Windows PowerShell 5.1 de 64 bits (powershell.exe), nao PowerShell 7/pwsh ou x86.'
}
$ErrorActionPreference = 'Stop'
$script:Issues = New-Object 'System.Collections.Generic.List[string]'
$script:NativeResults = New-Object 'System.Collections.Generic.List[object]'
$script:SafeVolumes = @()
$script:HasSnapshotAttempt = $false
$script:Report = Join-Path $env:LOCALAPPDATA ('ManutencaoWin11\' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
New-Item -ItemType Directory -Path $script:Report -Force | Out-Null
$script:Admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $Unidades) { $Unidades = @($env:SystemDrive.TrimEnd(':')) }
$Unidades = @($Unidades | ForEach-Object { $_.ToUpperInvariant() } | Select-Object -Unique)

function Note([string]$Text) {
    Write-Host $Text -ForegroundColor Cyan
    Add-Content -LiteralPath (Join-Path $script:Report 'andamento.txt') -Value ('{0} {1}' -f (Get-Date -Format s),$Text) -Encoding UTF8
}
function Problem([string]$Text) {
    $script:Issues.Add($Text)
    Write-Warning $Text
    Add-Content -LiteralPath (Join-Path $script:Report 'avisos.txt') -Value $Text -Encoding UTF8
}
function Step([string]$Name,[scriptblock]$Action) {
    Note $Name
    try { & $Action } catch { Problem ($Name + ': ' + $_.Exception.Message) }
}
function Save-Table([string]$Name,$Rows) {
    @($Rows) | Export-Csv -LiteralPath (Join-Path $script:Report ($Name + '.csv')) -NoTypeInformation -Encoding UTF8 -Delimiter ';'
}
function Need-Admin {
    if (-not $script:Admin) { throw 'Abra Windows PowerShell como administrador usando a mesma conta afetada.' }
}
function Native([string]$Name,[string]$Exe,[string[]]$Arguments) {
    Note ($Exe + ' ' + ($Arguments -join ' '))
    $log = Join-Path $script:Report ($Name + '.txt')
    $binary = Join-Path $env:windir ('System32\' + $Exe)
    if (-not (Test-Path -LiteralPath $binary -PathType Leaf)) { throw ('Utilitario ausente: ' + $binary) }
    # Windows PowerShell pode transformar stderr nativo em ErrorRecord. Continue
    # durante o comando e verifique explicitamente LASTEXITCODE em seguida.
    $previous = $ErrorActionPreference
    $code = $null
    try {
        $ErrorActionPreference = 'Continue'
        $LASTEXITCODE = $null
        & $binary @Arguments 2>&1 |
            ForEach-Object { $line = $_.ToString(); Write-Host $line; Add-Content -LiteralPath $log -Value $line -Encoding UTF8 }
        $code = $LASTEXITCODE
    } finally { $ErrorActionPreference = $previous }
    $script:NativeResults.Add([pscustomobject]@{Etapa=$Name;Executavel=$Exe;Codigo=$code;Log=$log})
    if ($null -eq $code) { throw 'Nao foi possivel obter o codigo de saida.' }
    if ($code -eq 3010) { Problem ($Name + ': reinicio solicitado pelo utilitario (3010).') }
    elseif ($code -ne 0) { Problem ($Name + ': codigo ' + $code + '. Consulte o log; nao considerar reparado.') }
    return [int]$code
}
function Snapshot {
    if ($script:HasSnapshotAttempt) { return }
    $script:HasSnapshotAttempt = $true
    Step 'Registrando configuracao anterior' {
        Get-CimInstance Win32_ComputerSystem | Select-Object AutomaticManagedPagefile |
            ConvertTo-Json | Set-Content -LiteralPath (Join-Path $script:Report 'paginacao-anterior.json') -Encoding UTF8
        Save-Table 'paginacao-tamanhos-anteriores' (Get-CimInstance Win32_PageFileSetting)
        Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' |
            Select-Object 'HibernateEnabled','HiberFileType','HiberFileSizePercent' |
            ConvertTo-Json | Set-Content -LiteralPath (Join-Path $script:Report 'hibernacao-anterior.json') -Encoding UTF8
    }
    Note 'Tentando criar ponto de restauracao (sem alterar a protecao do sistema).'
    try {
        $label = 'ManutencaoWin11-' + (Get-Date -Format 'yyyyMMdd-HHmmss')
        Checkpoint-Computer -Description $label -RestorePointType MODIFY_SETTINGS -WarningAction SilentlyContinue -ErrorAction Stop
        $found = @(Get-ComputerRestorePoint -ErrorAction Stop | Where-Object { $_.Description -eq $label })
        if ($found.Count -eq 0) { throw 'Ponto novo nao confirmado; protecao desabilitada ou limite de frequencia.' }
        Note 'Ponto de restauracao confirmado. Nao substitui backup de arquivos.'
    } catch { Problem ('Ponto de restauracao indisponivel: ' + $_.Exception.Message) }
}
function Walk-Files([string]$Root,[string]$Filter) {
    # Nao segue junctions, links simbolicos nem diretorios de rede.
    if (-not $Root -or $Root.StartsWith('\\') -or -not (Test-Path -LiteralPath $Root)) { return }
    $stack = New-Object 'System.Collections.Generic.Stack[string]'
    $stack.Push($Root)
    while ($stack.Count -gt 0) {
        $dir = $stack.Pop()
        foreach ($item in @(Get-ChildItem -LiteralPath $dir -Force -ErrorAction SilentlyContinue)) {
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) { continue }
            if ($item.PSIsContainer) { $stack.Push($item.FullName) }
            elseif ($item.Name -like $Filter) { $item }
        }
    }
}
function Shortcut-Report {
    $roots = @(
        [Environment]::GetFolderPath('Desktop'),[Environment]::GetFolderPath('CommonDesktopDirectory'),
        [Environment]::GetFolderPath('StartMenu'),[Environment]::GetFolderPath('CommonStartMenu'),
        (Join-Path $env:APPDATA 'Microsoft\Internet Explorer\Quick Launch\User Pinned')
    ) | Where-Object { $_ } | Select-Object -Unique
    $shell = New-Object -ComObject WScript.Shell
    try {
        $rows = @(foreach ($root in $roots) {
            foreach ($file in @(Walk-Files $root '*.lnk')) {
                $link = $null
                try {
                    $link = $shell.CreateShortcut($file.FullName)
                    $target = [Environment]::ExpandEnvironmentVariables($link.TargetPath)
                    $status = 'Especial ou sem destino simples: revisao manual'
                    if ($target -match '^[A-Za-z]:\\') {
                        $disk = Get-CimInstance Win32_LogicalDisk -Filter ("DeviceID='" + $target.Substring(0,2) + "'") -ErrorAction SilentlyContinue
                        if (-not $disk -or $disk.DriveType -ne 3) { $status = 'Unidade removivel/rede/indisponivel: nao validada' }
                        elseif (Test-Path -LiteralPath $target) { $status = 'Destino presente' }
                        else { $status = 'Destino nao localizado: pode ter sido movido ou removido' }
                    } elseif ($target.StartsWith('\\')) { $status = 'Rede: nao consultada' }
                    [pscustomobject]@{Atalho=$file.FullName;Destino=$target;Argumentos=$link.Arguments;
                        Diretorio=$link.WorkingDirectory;Icone=$link.IconLocation;WindowStyle=$link.WindowStyle;
                        Minimizado=($link.WindowStyle -eq 7);Situacao=$status}
                } catch { Problem ('Atalho nao inspecionado: ' + $file.FullName + ' - ' + $_.Exception.Message) }
                finally { if ($null -ne $link) { [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($link) } }
            }
        })
        Save-Table 'atalhos' $rows
        Note ('Atalhos: {0}; configurados minimizados: {1}; destino nao localizado: {2}.' -f $rows.Count,
            @($rows | Where-Object Minimizado).Count,@($rows | Where-Object { $_.Situacao -like 'Destino nao localizado*' }).Count)
    } finally { [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($shell) }
}
function Context-Report {
    $rows = @(foreach ($base in @('Registry::HKEY_CLASSES_ROOT\*','Registry::HKEY_CLASSES_ROOT\AllFileSystemObjects',
        'Registry::HKEY_CLASSES_ROOT\Directory','Registry::HKEY_CLASSES_ROOT\Directory\Background',
        'Registry::HKEY_CLASSES_ROOT\Folder','Registry::HKEY_CLASSES_ROOT\Drive')) {
        foreach ($branch in @('shellex\ContextMenuHandlers','shell')) {
            $path = Join-Path $base $branch
            if (-not (Test-Path -LiteralPath $path)) { continue }
            foreach ($key in @(Get-ChildItem -LiteralPath $path -ErrorAction SilentlyContinue)) {
                $value = [string]$key.GetValue('')
                $dll = ''
                $command = ''
                if ($branch -like 'shellex*') {
                    $clsid = $value
                    if ($clsid -notmatch '^\{[0-9a-fA-F-]{36}\}$') { $clsid = $key.PSChildName }
                    $server = 'Registry::HKEY_CLASSES_ROOT\CLSID\' + $clsid + '\InprocServer32'
                    if (Test-Path -LiteralPath $server) { $dll = [string](Get-Item -LiteralPath $server).GetValue('') }
                } else {
                    $cmdKey = Join-Path $key.PSPath 'command'
                    if (Test-Path -LiteralPath $cmdKey) { $command = [string](Get-Item -LiteralPath $cmdKey).GetValue('') }
                }
                [pscustomobject]@{Chave=$key.Name;Nome=$key.PSChildName;Valor=$value;DLL=$dll;Comando=$command}
            }
        }
    })
    Save-Table 'menu-contexto' $rows
}
function Diagnosis {
    Step 'Sistema, BIOS, RAM, video e paginacao' {
        $os = Get-CimInstance Win32_OperatingSystem
        $cs = Get-CimInstance Win32_ComputerSystem
        $info = [ordered]@{Data=(Get-Date -Format s);Usuario=[Security.Principal.WindowsIdentity]::GetCurrent().Name;
            Administrador=$script:Admin;Windows=$os.Caption;Build=$os.BuildNumber;UltimoBoot=$os.LastBootUpTime;
            RAM_GB=[math]::Round($cs.TotalPhysicalMemory/1GB,1);PaginacaoAutomatica=$cs.AutomaticManagedPagefile;
            CPU=@(Get-CimInstance Win32_Processor | Select-Object Name);
            BIOS=@(Get-CimInstance Win32_BIOS | Select-Object 'SMBIOSBIOSVersion','ReleaseDate');
            Video=@(Get-CimInstance Win32_VideoController | Select-Object 'Name','DriverVersion')}
        $info | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $script:Report 'sistema.json') -Encoding UTF8
        Save-Table 'paginacao-uso' (Get-CimInstance Win32_PageFileUsage | Select-Object 'Name','AllocatedBaseSize','CurrentUsage','PeakUsage')
        if (-not $cs.AutomaticManagedPagefile) { Problem 'Paginacao nao automatica. Revise a configuracao; 64 GB de RAM nao tornam o pagefile obsoleto.' }
    }
    Step 'Unidades e saude reportada pelos dispositivos' {
        Save-Table 'discos-fisicos' (Get-PhysicalDisk | Select-Object 'FriendlyName','MediaType','BusType','HealthStatus','OperationalStatus','Size')
        $volumes = @(Get-Volume | Where-Object DriveLetter | Select-Object 'DriveLetter','FileSystem','DriveType','HealthStatus',
            @{n='TotalGB';e={[math]::Round($_.Size/1GB,1)}},@{n='LivreGB';e={[math]::Round($_.SizeRemaining/1GB,1)}},
            @{n='LivrePct';e={if ($_.Size) {[math]::Round(100*$_.SizeRemaining/$_.Size,1)} else {0}}})
        Save-Table 'volumes' $volumes
        foreach ($v in $volumes) { if ($v.DriveType -eq 'Fixed' -and $v.LivrePct -lt 15) { Problem ('Pouco espaco livre na unidade ' + $v.DriveLetter + ': ' + $v.LivrePct + '%.') } }
        Note 'HealthStatus e uma indicacao; nao substitui diagnostico completo do fabricante/SMART.'
    }
    Step 'Inicializacao, tarefas e consumo de memoria' {
        Save-Table 'inicializacao' (Get-CimInstance Win32_StartupCommand | Select-Object 'Name','Command','Location','User')
        Save-Table 'tarefas-terceiros' (Get-ScheduledTask | Where-Object { $_.TaskPath -notlike '\Microsoft\*' } |
            Select-Object 'TaskPath','TaskName','State',@{n='Acoes';e={($_.Actions | ForEach-Object {$_.Execute + ' ' + $_.Arguments}) -join ' | '}})
        Save-Table 'processos-memoria' (Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 30 'Name','Id',
            @{n='RAM_MB';e={[math]::Round($_.WorkingSet64/1MB,1)}},@{n='CPU_seg_acumulados';e={$_.CPU}})
        Note 'CPU no CSV e tempo acumulado, nao porcentagem instantanea nem prova de lentidao.'
    }
    Step 'Atalhos locais (incluindo configuracao de janela)' { Shortcut-Report }
    Step 'Extensoes legadas do menu de contexto' { Context-Report }
    Step 'Foco, CMD AutoRun e ajustes do Windows Terminal' {
        Get-ItemProperty 'HKCU:\Control Panel\Desktop' | Select-Object 'ForegroundLockTimeout','ForegroundFlashCount','MenuShowDelay' |
            ConvertTo-Json | Set-Content -LiteralPath (Join-Path $script:Report 'foco-e-menus.json') -Encoding UTF8
        $cmdRows = @(foreach ($key in @('HKCU:\Software\Microsoft\Command Processor','HKLM:\Software\Microsoft\Command Processor')) {
            if (Test-Path -LiteralPath $key) { [pscustomobject]@{Chave=$key;AutoRun=(Get-Item -LiteralPath $key).GetValue('AutoRun')} }
        })
        Save-Table 'cmd-autorun' $cmdRows
        $terminalFiles = @(
            (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'),
            (Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json'),
            (Join-Path $env:LOCALAPPDATA 'Microsoft\Windows Terminal\settings.json'))
        $terminal = @(foreach ($file in $terminalFiles) {
            if (Test-Path -LiteralPath $file) {
                Select-String -LiteralPath $file -Pattern '"(launchMode|windowingBehavior|firstWindowPreference|initialPosition|alwaysOnTop)"' |
                    Select-Object 'Path','LineNumber','Line'
            }
        })
        Save-Table 'terminal-trechos-para-revisao' $terminal
        Note 'Terminal: trechos textuais podem estar comentados no JSONC; nao sao diagnostico conclusivo.'
    }
    Step 'Falhas recentes do Windows (ultimos 7 dias, ate 150 por log)' {
        foreach ($log in @('System','Application')) {
            $events = @(Get-WinEvent -FilterHashtable @{LogName=$log;Level=1,2;StartTime=(Get-Date).AddDays(-7)} -MaxEvents 150 -ErrorAction SilentlyContinue)
            Save-Table ('eventos-' + $log) ($events | Select-Object 'TimeCreated','Id','ProviderName','LevelDisplayName','Message')
        }
    }
    Step 'Estado de reinicio pendente e Menu Iniciar' {
        $pending = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending',
            'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired') |
            Where-Object { Test-Path -LiteralPath $_ }
        if ($pending) { Problem 'Windows sinaliza reinicio pendente. Reinicie antes dos reparos de componentes.' }
        Save-Table 'menu-iniciar-pacote' (Get-AppxPackage -Name Microsoft.Windows.StartMenuExperienceHost | Select-Object 'Name','PackageFullName','InstallLocation','Status')
    }
    Step 'Energia e disponibilidade de hibernacao' { [void](Native 'energia' 'powercfg.exe' @('/a')) }
    if ($script:Admin) { Step 'Estado do TRIM (consulta, sem mudanca)' { [void](Native 'trim-consulta' 'fsutil.exe' @('behavior','query','DisableDeleteNotify')) } }
    Note ('Diagnostico salvo em ' + $script:Report)
}
function Disk-Maintenance {
    Need-Admin
    $script:SafeVolumes = @()
    foreach ($letter in $Unidades) {
        Step ('Verificacao da unidade ' + $letter) {
            $vol = Get-Volume -DriveLetter $letter
            if ($vol.DriveType -ne 'Fixed' -or $vol.FileSystem -ne 'NTFS') {
                Problem ($letter + ': ignorada; este fluxo trabalha apenas com unidades fixas NTFS.'); return
            }
            if ($vol.HealthStatus -ne 'Healthy') {
                Problem ($letter + ': saude do volume nao normal; nao executar otimizacao. Avalie backup e disco.'); return
            }
            # Nao usa /r, /f, desmontagem nem agenda reparo offline automaticamente.
            $code = Native ('chkdsk-' + $letter) 'chkdsk.exe' @(($letter + ':'),'/scan')
            if ($code -eq 0) { $script:SafeVolumes += $letter }
            else { Problem ($letter + ': otimizacao pulada. Leia CHKDSK antes de qualquer reparo offline.') }
        }
    }
    foreach ($letter in $script:SafeVolumes) {
        Step ('Otimizacao apropriada ao tipo de midia em ' + $letter) {
            # /O deixa o Windows escolher por midia. SATA pode ser SSD OU HDD.
            [void](Native ('otimizacao-' + $letter) 'defrag.exe' @(($letter + ':'),'/O','/U','/V'))
        }
    }
}
function Repair-Windows {
    Need-Admin
    Diagnosis
    $pending = @('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired') |
        Where-Object { Test-Path -LiteralPath $_ }
    if ($pending) { throw 'Reinicio pendente detectado. Reinicie e execute Reparar novamente.' }
    Snapshot
    $code = Native 'dism-reparo' 'dism.exe' @('/Online','/Cleanup-Image','/RestoreHealth')
    if ($code -eq 3010) { throw 'DISM pede reinicio. Reinicie antes de continuar o reparo.' }
    if ($code -ne 0) { Problem 'DISM falhou. SFC ainda sera executado, mas a origem dos arquivos pode estar comprometida.' }
    [void](Native 'sfc' 'sfc.exe' @('/scannow'))
    Note 'Confira a conclusao de sfc.txt. Codigo zero sozinho nao comprova ausencia de corrupcao.'
    Step 'Extraindo linhas SFC do log CBS' {
        Select-String -LiteralPath (Join-Path $env:windir 'Logs\CBS\CBS.log') -SimpleMatch '[SR]' |
            Select-Object -Last 250 | ForEach-Object { $_.Line } |
            Set-Content -LiteralPath (Join-Path $script:Report 'sfc-cbs-ultimas-linhas.txt') -Encoding UTF8
    }
    Disk-Maintenance
    Note 'Etapas de manutencao encerradas. Leia os resultados e reinicie manualmente apos salvar seu trabalho.'
}
function Repair-Shortcut {
    if (-not $Atalho -or [IO.Path]::GetExtension($Atalho) -ine '.lnk') { throw 'Informe -Atalho com o caminho completo de um .lnk existente.' }
    if (-not $JanelaNormal -and -not $NovoDestino -and -not $CorrigirIcone) { throw 'Escolha -JanelaNormal, -NovoDestino ou -CorrigirIcone.' }
    $path = (Get-Item -LiteralPath $Atalho).FullName
    if ($path.StartsWith('\\')) { throw 'Edite somente atalhos em unidade local.' }
    $bytes = [IO.File]::ReadAllBytes($path)
    if ($bytes.Length -lt 76 -or [BitConverter]::ToUInt32($bytes,0) -ne 76) { throw 'Arquivo .lnk invalido ou nao convencional.' }
    if (([BitConverter]::ToUInt32($bytes,20) -band 0x1000) -ne 0) { throw 'Atalho MSI anunciado: use Reparar no instalador do programa.' }
    if ($NovoDestino) {
        $NovoDestino = (Get-Item -LiteralPath $NovoDestino).FullName
        if ($NovoDestino -notmatch '^[A-Za-z]:\\' -or [IO.Path]::GetExtension($NovoDestino) -ine '.exe') {
            throw 'NovoDestino deve ser um executavel .exe local existente. Nao inclua argumentos no caminho.'
        }
    }
    $shell = New-Object -ComObject WScript.Shell
    $link = $null
    try {
        $link = $shell.CreateShortcut($path)
        if ($link.TargetPath -notmatch '^[A-Za-z]:\\') { throw 'Atalho especial/Store/rede. Recrie pelo proprio aplicativo ou por shell:AppsFolder.' }
        $effectiveTarget = $link.TargetPath
        if ($NovoDestino) { $effectiveTarget = $NovoDestino }
        if ($CorrigirIcone -and (-not (Test-Path -LiteralPath $effectiveTarget -PathType Leaf) -or [IO.Path]::GetExtension($effectiveTarget) -ine '.exe')) {
            throw 'Para corrigir o icone, o destino precisa ser um .exe existente.'
        }
        $id = [guid]::NewGuid().ToString('N')
        $copy = Join-Path $script:Report ('atalho-' + $id + '.lnk')
        $manifest = Join-Path $script:Report ('atalho-' + $id + '.json')
        Copy-Item -LiteralPath $path -Destination $copy
        $meta = [ordered]@{Tipo='BackupAtalho-v1';Original=$path;Copia=$copy;SHA256=(Get-FileHash -LiteralPath $copy).Hash;
            DestinoAnterior=$link.TargetPath;Argumentos=$link.Arguments;JanelaAnterior=$link.WindowStyle;Data=(Get-Date -Format s)}
        $meta | ConvertTo-Json | Set-Content -LiteralPath $manifest -Encoding UTF8
        if ($NovoDestino) {
            $oldDir = Split-Path -Parent $link.TargetPath
            $link.TargetPath = $NovoDestino
            if ($link.WorkingDirectory -eq $oldDir) { $link.WorkingDirectory = Split-Path -Parent $NovoDestino }
        }
        if ($JanelaNormal) { $link.WindowStyle = 1 }
        if ($CorrigirIcone) { $link.IconLocation = $effectiveTarget + ',0' }
        $link.Save()
        Note ('Atalho atualizado: ' + $path)
        Note ('Backup para desfazer: ' + $manifest)
        Note 'Teste o atalho. Se uma fixacao moderna continuar quebrada, desafixe e fixe novamente o aplicativo correto.'
    } finally {
        if ($null -ne $link) { [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($link) }
        [void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($shell)
    }
}
function Restore-Shortcut {
    if (-not $Backup) { throw 'Informe -Backup com o JSON gerado na correcao do atalho.' }
    $meta = Get-Content -LiteralPath $Backup -Raw | ConvertFrom-Json
    if ($meta.Tipo -ne 'BackupAtalho-v1' -or [IO.Path]::GetExtension($meta.Original) -ine '.lnk' -or
        [IO.Path]::GetExtension($meta.Copia) -ine '.lnk' -or $meta.Original -notmatch '^[A-Za-z]:\\') { throw 'Manifesto de backup invalido.' }
    if ((Get-FileHash -LiteralPath $meta.Copia).Hash -ne $meta.SHA256) { throw 'Hash do backup nao confere; restauracao cancelada.' }
    if (Test-Path -LiteralPath $meta.Original) {
        Copy-Item -LiteralPath $meta.Original -Destination (Join-Path $script:Report ('antes-restauracao-' + [guid]::NewGuid().ToString('N') + '.lnk'))
    }
    Copy-Item -LiteralPath $meta.Copia -Destination $meta.Original -Force
    Note ('Atalho restaurado: ' + $meta.Original)
}
function Repair-Start {
    if ($script:Admin) { throw 'MenuIniciar: abra PowerShell SEM administrador, na conta que apresenta o problema.' }
    $manifest = Join-Path $env:windir 'SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\AppxManifest.xml'
    if (-not (Test-Path -LiteralPath $manifest)) { throw 'Manifesto nativo ausente. Use DISM/SFC; nao baixe arquivos AppX de terceiros.' }
    Add-AppxPackage -Path $manifest -Register -DisableDevelopmentMode -ErrorAction Stop
    Note 'Registro do Menu Iniciar concluido para esta conta. Saia da sessao e entre novamente apos salvar seu trabalho.'
}
function Run-Mode([string]$Action) {
    switch ($Action) {
        'Diagnostico' { Diagnosis }
        'Reparar' { Repair-Windows }
        'Otimizar' { Need-Admin; Disk-Maintenance }
        'Atalho' { Repair-Shortcut }
        'RestaurarAtalho' { Restore-Shortcut }
        'MenuIniciar' { Repair-Start }
        'PaginacaoAutomatica' {
            Need-Admin; Snapshot
            Get-CimInstance Win32_ComputerSystem | Set-CimInstance -Property @{AutomaticManagedPagefile=$true}
            if (-not (Get-CimInstance Win32_ComputerSystem).AutomaticManagedPagefile) { throw 'Gerenciamento automatico nao foi confirmado.' }
            Note 'Paginacao automatica ativada. Reinicie manualmente para aplicar. Estado anterior salvo no relatorio.'
        }
        'Hibernacao' {
            Need-Admin
            if (-not $Estado) { throw 'Informe -Estado Ativar ou Desativar.' }
            Snapshot
            $flag = 'on'
            if ($Estado -eq 'Desativar') { $flag = 'off'; Note 'Desativando hibernacao: tambem afeta Inicializacao Rapida e suspensao hibrida.' }
            $code = Native 'hibernacao' 'powercfg.exe' @('/hibernate',$flag)
            if ($code -eq 0) { Note ('Comando de hibernacao concluido: ' + $Estado) }
        }
        'Limpeza' {
            Note 'Escolha manualmente as categorias. Exclusoes feitas pela Limpeza de Disco nao tem desfazer neste script.'
            Start-Process -FilePath (Join-Path $env:windir 'System32\cleanmgr.exe')
        }
    }
}

$transcribing = $false
try {
    try { Start-Transcript -Path (Join-Path $script:Report 'sessao.txt') -ErrorAction Stop | Out-Null; $transcribing = $true }
    catch { Problem ('Transcricao indisponivel: ' + $_.Exception.Message) }
    Note ('Manutencao Windows 11 | Usuario: ' + [Security.Principal.WindowsIdentity]::GetCurrent().Name + ' | Administrador: ' + $script:Admin)
    Note ('Relatorios: ' + $script:Report)
    if ($Modo -eq 'Menu') {
        do {
            Write-Host @'

  1  Diagnostico (sem reparos)
  2  Reparar Windows + verificar/otimizar unidade(s) [administrador]
  3  Verificar/otimizar unidade(s) [administrador]
  4  Corrigir um atalho (copia de seguranca automatica)
  5  Restaurar um atalho usando seu JSON de backup
  6  Registrar Menu Iniciar [SEM administrador]
  7  Ativar paginacao automatica [administrador]
  8  Desativar hibernacao e Inicializacao Rapida [administrador]
  9  Reativar hibernacao [administrador]
 10  Abrir Limpeza de Disco (voce escolhe o que excluir)
 11  Abrir configuracoes de aplicativos de inicializacao
 12  Abrir pasta de relatorios
 13  Ler instrucoes completas
  0  Sair
'@
            Write-Host ('  Unidades selecionadas: ' + ($Unidades -join ', ') + ' (mude com -Unidades C,D)')
            $option = Read-Host 'Opcao'
            try {
                switch ($option) {
                    '1' { Run-Mode 'Diagnostico' }
                    '2' { Run-Mode 'Reparar' }
                    '3' { Run-Mode 'Otimizar' }
                    '4' {
                        $Atalho = (Read-Host 'Caminho completo do .lnk').Trim('"')
                        $NovoDestino = (Read-Host 'Novo .exe, ou ENTER para manter o destino').Trim('"')
                        $JanelaNormal = (Read-Host 'Definir janela normal? S/N') -ieq 'S'
                        $CorrigirIcone = (Read-Host 'Usar icone do executavel? S/N') -ieq 'S'
                        Run-Mode 'Atalho'
                    }
                    '5' { $Backup = (Read-Host 'Caminho do JSON de backup do atalho').Trim('"'); Run-Mode 'RestaurarAtalho' }
                    '6' { Run-Mode 'MenuIniciar' }
                    '7' { Run-Mode 'PaginacaoAutomatica' }
                    '8' { $Estado = 'Desativar'; Run-Mode 'Hibernacao' }
                    '9' { $Estado = 'Ativar'; Run-Mode 'Hibernacao' }
                    '10' { Run-Mode 'Limpeza' }
                    '11' { Start-Process 'ms-settings:startupapps' }
                    '12' { Start-Process -FilePath (Join-Path $env:windir 'explorer.exe') -ArgumentList ('"' + $script:Report + '"') }
                    '13' { Get-Help $PSCommandPath -Full | Out-Host }
                    '0' { }
                    default { Write-Host 'Escolha uma opcao da lista.' }
                }
            } catch { Problem $_.Exception.Message }
        } while ($option -ne '0')
    } else { Run-Mode $Modo }
} catch {
    Problem ('Operacao interrompida: ' + $_.Exception.Message)
    throw
} finally {
    Save-Table 'comandos-resultados' $script:NativeResults.ToArray()
    @(
        'Execucao encerrada: ' + (Get-Date -Format s)
        'Modo: ' + $Modo
        'Avisos registrados: ' + $script:Issues.Count
        'Consulte andamento.txt, avisos.txt, comandos-resultados.csv e os logs individuais.'
        'Conclusao tecnica de SFC: sfc.txt e sfc-cbs-ultimas-linhas.txt; nao inferir apenas pelo codigo.'
        'Etapas com erro nao devem ser consideradas bem-sucedidas. Nenhum reinicio automatico.'
        'Atalhos nao localizados exigem verificar instalacao, unidade, destino e argumentos.'
        'Menu de contexto: inventario em menu-contexto.csv; nenhuma extensao removida automaticamente.'
    ) | Set-Content -LiteralPath (Join-Path $script:Report 'LEIA-ME-RESULTADOS.txt') -Encoding UTF8
    Write-Host ('Relatorios e backups: ' + $script:Report) -ForegroundColor Green
    if ($transcribing) { Stop-Transcript | Out-Null }
}
