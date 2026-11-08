<#
============================================================================
  Curso de PowerShell · Módulo 10 · Exemplo 01 — PSScriptAnalyzer na prática
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Ver o PSScriptAnalyzer apontar problemas num código ruim de propósito.
  EXECUTE   pwsh ./01-analise-estatica.ps1
  NOTA      Requer o módulo PSScriptAnalyzer (Install-Module PSScriptAnalyzer).
============================================================================
#>
Set-StrictMode -Version Latest

if (-not (Get-Module -ListAvailable PSScriptAnalyzer)) {
    Write-Output 'PSScriptAnalyzer não está instalado. Instale com:'
    Write-Output '   Install-Module PSScriptAnalyzer -Scope CurrentUser'
    return
}
Import-Module PSScriptAnalyzer

# Um script RUIM de propósito, escrito num arquivo temporário para analisarmos.
$lab = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $lab | Out-Null
try {
    $ruim = Join-Path $lab 'ruim.ps1'
    @'
function Connect-Servico {
    param([string]$Password)      # senha em texto puro: má prática de segurança
    $naoUsada = 42                # variável atribuída e nunca usada
    ls C:\ | ? { $_.Length -gt 10 }   # aliases (ls, ?) em vez dos cmdlets
}
'@ | Set-Content -Path $ruim

    Write-Output 'Analisando um script escrito com más práticas de propósito:'
    Write-Output ''
    $achados = Invoke-ScriptAnalyzer -Path $ruim
    foreach ($a in $achados) {
        "   [{0}] linha {1}: {2}" -f $a.Severity, $a.Line, $a.RuleName | Write-Output
    }

    Write-Output ''
    "   total de problemas apontados: $(@($achados).Count)" | Write-Output
    Write-Output '   (senha em texto puro, variável não usada, aliases ls/?...)'
}
finally {
    Remove-Item -Recurse -Force -LiteralPath $lab -ErrorAction SilentlyContinue
}

Write-Output ''
Write-Output 'Integre ao VS Code (extensão PowerShell) para ver isso enquanto digita.'
