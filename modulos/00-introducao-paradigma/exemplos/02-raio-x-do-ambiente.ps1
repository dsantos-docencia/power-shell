<#
============================================================================
  Curso de PowerShell · Módulo 00 · Exemplo 02 — Raio-X do ambiente
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Descobrir ONDE você está rodando, usando as variáveis automáticas.
            É o primeiro script que todo administrador roda numa máquina nova.
  EXECUTE   pwsh ./02-raio-x-do-ambiente.ps1
============================================================================
#>
Set-StrictMode -Version Latest

# Função auxiliar para imprimir "rótulo: valor" alinhado.
function Mostrar($rotulo, $valor) {
    '  {0,-22} {1}' -f $rotulo, ($valor ?? '(indisponível)') | Write-Output
}

Write-Output '=== Raio-X do ambiente PowerShell ==='

# $PSVersionTable é um objeto (hashtable) com os detalhes da versão.
Mostrar 'Versão'        $PSVersionTable.PSVersion.ToString()
Mostrar 'Edição'        $PSVersionTable.PSEdition           # Core = 7+ ; Desktop = 5.1
Mostrar 'Maior.Menor'   ('{0}.{1}' -f $PSVersionTable.PSVersion.Major, $PSVersionTable.PSVersion.Minor)

Write-Output ''
Write-Output 'Plataforma (as variáveis automáticas $IsWindows/$IsLinux/$IsMacOS):'
# Essas variáveis existem no PowerShell 7+. No 5.1 (só Windows) elas não existem,
# então checamos com cuidado para o script rodar em qualquer lugar.
$ehWindows = if (Test-Path variable:IsWindows) { $IsWindows } else { $true }
$ehLinux   = if (Test-Path variable:IsLinux)   { $IsLinux }   else { $false }
$ehMac     = if (Test-Path variable:IsMacOS)   { $IsMacOS }   else { $false }
Mostrar '  Windows?' $ehWindows
Mostrar '  Linux?'   $ehLinux
Mostrar '  macOS?'   $ehMac

Write-Output ''
Mostrar 'Usuário'     ($env:USER ?? $env:USERNAME)
Mostrar 'Diretório'   (Get-Location).Path
Mostrar 'Host'        $Host.Name                 # ex.: ConsoleHost, Visual Studio Code Host

Write-Output ''
Write-Output 'Dica: rode este script no Windows, no Linux e no macOS e compare.'
Write-Output 'O mesmo PowerShell 7 administra os três — essa é a grande virada.'
