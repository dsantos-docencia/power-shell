<#
============================================================================
  Curso de PowerShell · Módulo 01 · Exemplo 03 — Providers e PSDrives
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Ver que não só o disco é navegável: variáveis de ambiente, aliases
            e funções também são "drives", via providers — o mesmo Get-ChildItem.
  EXECUTE   pwsh ./03-providers.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Get-PSDrive mostra TODOS os "drives" (não só C:/):'
Get-PSDrive |
    Select-Object -ExpandProperty Name |
    Sort-Object |
    ForEach-Object { "   $_" | Write-Output }

Write-Output ''
Write-Output '2) O drive Env: expõe as variáveis de ambiente como se fossem arquivos:'
Get-ChildItem Env: |
    Select-Object -First 5 Name, Value |
    ForEach-Object { "   {0,-16} {1}" -f $_.Name, ($_.Value -replace '(.{40}).*', '$1…') | Write-Output }

Write-Output ''
Write-Output '3) E dá para ler uma variável específica como se fosse um arquivo:'
$caminho = Get-Content Env:PATH
"   Env:PATH tem $($caminho.Split([IO.Path]::PathSeparator).Count) entradas" | Write-Output

Write-Output ''
Write-Output '4) O mesmo Get-ChildItem funciona no drive Function: (as funções carregadas):'
"   há $((Get-ChildItem Function: | Measure-Object).Count) funções carregadas nesta sessão" | Write-Output

Write-Output ''
Write-Output 'No Windows, você navegaria HKLM:\ (Registro) e Cert:\ (certificados)'
Write-Output 'do mesmo jeito. Um conceito (provider), muitos mundos.'
