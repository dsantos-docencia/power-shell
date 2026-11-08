<#
============================================================================
  Curso de PowerShell · Módulo 02 · Exemplo 01 — Get-Member
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Usar Get-Member para DESCOBRIR o que um objeto tem — a habilidade
            que substitui "decorar". Objetos não são texto: têm estrutura.
  EXECUTE   pwsh ./01-get-member.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Um objeto de data/hora (Get-Date) não é texto — tem PROPRIEDADES:'
Get-Date | Get-Member -MemberType Property |
    Select-Object -ExpandProperty Name -First 8 |
    ForEach-Object { "   .$_" | Write-Output }

Write-Output ''
Write-Output '   ...e MÉTODOS (coisas que o objeto sabe fazer):'
Get-Date | Get-Member -MemberType Method |
    Select-Object -ExpandProperty Name |
    Where-Object { $_ -like 'Add*' } |
    Select-Object -First 5 |
    ForEach-Object { "   .$_()" | Write-Output }

Write-Output ''
Write-Output '2) Por conhecer as propriedades/métodos, usamos tudo diretamente:'
$agora = Get-Date
"   Ano atual:        $($agora.Year)"                | Write-Output
"   Daqui a 10 dias:  $($agora.AddDays(10).ToString('yyyy-MM-dd'))" | Write-Output
"   É fim de semana?  $($agora.DayOfWeek -in 'Saturday','Sunday')"  | Write-Output

Write-Output ''
Write-Output '3) O MESMO Get-Member funciona com QUALQUER objeto. Um número:'
(42).GetType().Name | ForEach-Object { "   42 é do tipo: $_" | Write-Output }
'   (42) tem o método .ToString("X") → ' + (255).ToString('X') + ' (hex de 255)' | Write-Output

Write-Output ''
Write-Output 'Fluxo profissional: rode um cmdlet → | Get-Member → descubra →'
Write-Output 'use as propriedades no Select-Object/Where-Object. Nunca fique preso.'
