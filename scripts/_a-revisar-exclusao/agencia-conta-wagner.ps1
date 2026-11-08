# Script de Auditoria de Sistema Transparente
# Este script coleta informações básicas e salva no diretório de execução atual.

Write-Host "Iniciando coleta de informações do sistema..." -ForegroundColor Cyan

# Definir o caminho do arquivo de saída no diretório atual de execução
$OutputPath = ".\Relatorio_Sistema.txt"

# Verificar se temos permissão de gravação no diretório atual
try {
    "Teste" | Out-File -FilePath $OutputPath -ErrorAction Stop
    Remove-Item -Path $OutputPath -ErrorAction Stop
} catch {
    Write-Host "Erro: Sem permissão para gravar neste diretório. Execute o PowerShell como Administrador ou mude para uma pasta como 'Documentos'." -ForegroundColor Red
    exit
}

# Iniciar o relatório com data e hora
"=== RELATÓRIO DE AUDITORIA DO SISTEMA ===" | Out-File -FilePath $OutputPath
"Data e Hora: $(Get-Date)" | Out-File -FilePath $OutputPath -Append
"Diretório de Execução: $PWD" | Out-File -FilePath $OutputPath -Append
"========================================`n" | Out-File -FilePath $OutputPath -Append

# 1. Informações do Sistema Operacional
Write-Host "Coletando dados do Sistema Operacional..." -ForegroundColor Yellow
$OS = Get-CimInstance Win32_OperatingSystem
"--- SISTEMA OPERACIONAL ---" | Out-File -FilePath $OutputPath -Append
"Nome: $($OS.Caption)" | Out-File -FilePath $OutputPath -Append
"Versão: $($OS.Version)" | Out-File -FilePath $OutputPath -Append
"Arquitetura: $($OS.OSArchitecture)" | Out-File -FilePath $OutputPath -Append
"Último Reinício: $($OS.LastBootUpTime)" | Out-File -FilePath $OutputPath -Append
"`n" | Out-File -FilePath $OutputPath -Append

# 2. Informações de Hardware (CPU e RAM)
Write-Host "Coletando dados de Hardware..." -ForegroundColor Yellow
$CPU = Get-CimInstance Win32_Processor
$RAM = Get-CimInstance Win32_ComputerSystem
"--- HARDWARE ---" | Out-File -FilePath $OutputPath -Append
"Processador: $($CPU.Name)" | Out-File -FilePath $OutputPath -Append
"Núcleos Lógicos: $($CPU.NumberOfLogicalProcessors)" | Out-File -FilePath $OutputPath -Append
"Memória RAM Total: $([math]::Round($RAM.TotalPhysicalMemory / 1GB, 2)) GB" | Out-File -FilePath $OutputPath -Append
"Fabricante do Sistema: $($RAM.Manufacturer)" | Out-File -FilePath $OutputPath -Append
"`n" | Out-File -FilePath $OutputPath -Append

# 3. Informações de Rede (IP Local e Público)
Write-Host "Coletando dados de Rede..." -ForegroundColor Yellow
"--- REDE ---" | Out-File -FilePath $OutputPath -Append

# IP Local (IPv4)
$LocalIP = Get-NetIPAddress -AddressFamily IPv4 | Where-Object InterfaceAlias -notmatch "Loopback" | Select-Object -First 1
"IP Local: $($LocalIP.IPAddress)" | Out-File -FilePath $OutputPath -Append
"Interface de Rede: $($LocalIP.InterfaceAlias)" | Out-File -FilePath $OutputPath -Append

# IP Público (Requisição externa segura e comum)
try {
    $PublicIP = Invoke-RestMethod -Uri "https://api.ipify.org?format=json"
    "IP Público: $($PublicIP.ip)" | Out-File -FilePath $OutputPath -Append
} catch {
    "IP Público: Não foi possível obter (verifique sua conexão com a internet)." | Out-File -FilePath $OutputPath -Append
}
"`n" | Out-File -FilePath $OutputPath -Append

# 4. Licença do Windows (Status básico)
Write-Host "Verificando status da licença..." -ForegroundColor Yellow
$License = Get-CimInstance SoftwareLicensingProduct | Where-Object { $_.Name -like "Windows*" -and $_.LicenseStatus -eq 1 }
"--- LICENÇA ---" | Out-File -FilePath $OutputPath -Append
if ($License) {
    "Status: Ativado" | Out-File -FilePath $OutputPath -Append
} else {
    "Status: Não ativado ou não foi possível verificar via WMI." | Out-File -FilePath $OutputPath -Append
}
"`n" | Out-File -FilePath $OutputPath -Append

Write-Host "Concluído com sucesso!" -ForegroundColor Green
Write-Host "O relatório foi salvo em: $PWD\Relatorio_Sistema.txt" -ForegroundColor White
Write-Host "Você pode abrir este arquivo com o Bloco de Notas para revisar os dados." -ForegroundColor White