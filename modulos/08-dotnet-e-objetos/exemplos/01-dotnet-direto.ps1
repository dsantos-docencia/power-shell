<#
============================================================================
  Curso de PowerShell · Módulo 08 · Exemplo 01 — Chamando o .NET direto
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Usar classes .NET estáticas quando não há (ou não vale) um cmdlet.
  EXECUTE   pwsh ./01-dotnet-direto.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) [Math] — matemática que não tem cmdlet:'
"   Round(3.14159, 2) = $([Math]::Round(3.14159, 2))" | Write-Output
"   Sqrt(144)         = $([Math]::Sqrt(144))"          | Write-Output
"   Max(10, 20)       = $([Math]::Max(10, 20))"        | Write-Output
"   PI                = $([Math]::Round([Math]::PI, 4))" | Write-Output

Write-Output ''
Write-Output '2) [Guid] e [DateTime]:'
"   NewGuid()         = $([Guid]::NewGuid())"                       | Write-Output
"   Parse de data     = $(([DateTime]::Parse('2026-01-15')).DayOfWeek)" | Write-Output

Write-Output ''
Write-Output '3) [System.IO.Path] — manipular caminhos SEM tocar no disco:'
$caminho = '/var/log/app/relatorio.final.txt'
"   GetExtension           = $([System.IO.Path]::GetExtension($caminho))"                 | Write-Output
"   GetFileName            = $([System.IO.Path]::GetFileName($caminho))"                   | Write-Output
"   GetFileNameWithoutExt  = $([System.IO.Path]::GetFileNameWithoutExtension($caminho))"  | Write-Output

Write-Output ''
Write-Output '4) [Convert] — bases numéricas:'
"   255 em hexadecimal = $([Convert]::ToString(255, 16))"  | Write-Output
"   '1010' binário     = $([Convert]::ToInt32('1010', 2))" | Write-Output

Write-Output ''
Write-Output '5) Descobrindo o que uma classe oferece (como Get-Member, mas estático):'
$metodos = [Math] | Get-Member -Static -MemberType Method |
    Select-Object -ExpandProperty Name -First 6
"   alguns métodos de [Math]: $($metodos -join ', ')" | Write-Output

Write-Output ''
Write-Output 'Quando não houver cmdlet, lembre: o .NET inteiro está disponível com [Classe]::Metodo().'
