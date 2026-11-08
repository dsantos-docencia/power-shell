<#
============================================================================
  Curso de PowerShell · Módulo 09 · Exemplo 03 — Remoting (padrão conceitual)
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Mostrar o PADRÃO do Invoke-Command/$Using: SEM precisar de máquinas
            remotas — usamos Invoke-Command localmente para ilustrar.
  EXECUTE   pwsh ./03-remoting-conceitual.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Invoke-Command roda um bloco e devolve OBJETOS (aqui, localmente):'
# Em produção: Invoke-Command -ComputerName srv01, srv02 -ScriptBlock { ... }
# Aqui, sem -ComputerName, roda local — mas o PADRÃO é idêntico.
$resultado = Invoke-Command -ScriptBlock {
    [pscustomobject]@{ Maquina = $env:COMPUTERNAME ?? (hostname); Hora = (Get-Date -Format 'HH:mm:ss') }
}
"   voltou um objeto: Maquina=$($resultado.Maquina)" | Write-Output

Write-Output ''
Write-Output '2) $Using: leva uma variável LOCAL para dentro do bloco remoto:'
$servico = 'nginx'
$msg = Invoke-Command -ScriptBlock { "consultaria o serviço: $using:servico" }
"   $msg" | Write-Output

Write-Output ''
Write-Output '3) Em massa: o MESMO bloco em várias máquinas de uma vez (padrão):'
Write-Output '   Invoke-Command -ComputerName srv01, srv02, srv03 -ScriptBlock { Get-Service }'
Write-Output '   -> traz os OBJETOS de serviço das 3 máquinas; você filtra tudo com um pipeline:'
Write-Output '      ... | Where-Object Status -eq "Stopped"'

Write-Output ''
Write-Output '4) Transportes: WinRM (Windows) ou SSH (multiplataforma, PS7):'
Write-Output '   New-PSSession -HostName srv01 -UserName admin   # sessão via SSH'
Write-Output ''
Write-Output 'O que volta são OBJETOS desserializados — não texto. Por isso você'
Write-Output 'administra 100 servidores (Windows e Linux) com um único pipeline.'
