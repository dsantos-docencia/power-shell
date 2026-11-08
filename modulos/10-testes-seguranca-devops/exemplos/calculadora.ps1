<#
============================================================================
  Curso de PowerShell · Módulo 10 · calculadora.ps1
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  Uma ferramenta simples (soma/subtrai/multiplica/divide dois números),
  usada como ALVO dos testes Pester (calculadora.Tests.ps1).
  USO:  pwsh ./calculadora.ps1 -A 2 -B 3 -Op Somar
============================================================================
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][double]$A,
    [Parameter(Mandatory)][double]$B,
    [ValidateSet('Somar', 'Subtrair', 'Multiplicar', 'Dividir')]
    [string]$Op = 'Somar'
)

$ErrorActionPreference = 'Stop'

switch ($Op) {
    'Somar'       { Write-Output ($A + $B) }
    'Subtrair'    { Write-Output ($A - $B) }
    'Multiplicar' { Write-Output ($A * $B) }
    'Dividir'     {
        if ($B -eq 0) { throw 'divisão por zero' }
        Write-Output ($A / $B)
    }
}
