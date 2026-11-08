<#
============================================================================
  Curso de PowerShell · Módulo 05 · Exemplo 03 — SupportsShouldProcess (-WhatIf)
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Dar às SUAS funções o superpoder do -WhatIf: simular antes de agir.
  EXECUTE   pwsh ./03-whatif.ps1
  SEGURO    Opera só em arquivos temporários.
============================================================================
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Remove-Temporario {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param([Parameter(Mandatory)][string]$Caminho)

    # ShouldProcess devolve $false quando o usuário passou -WhatIf: a ação é pulada.
    if ($PSCmdlet.ShouldProcess($Caminho, 'Remover arquivo')) {
        Remove-Item -LiteralPath $Caminho
        Write-Output "   removido: $Caminho"
    }
}

$lab = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $lab | Out-Null
try {
    $alvo = Join-Path $lab 'descartavel.txt'
    Set-Content -Path $alvo -Value 'conteudo'

    Write-Output '1) Com -WhatIf: apenas SIMULA, não apaga nada.'
    Remove-Temporario -Caminho $alvo -WhatIf 4>&1 2>&1 |
        ForEach-Object { "   [simulação] $_" | Write-Output }
    "   o arquivo ainda existe? $([bool](Test-Path $alvo))  <- continua lá" | Write-Output

    Write-Output ''
    Write-Output '2) Sem -WhatIf: executa de verdade.'
    Remove-Temporario -Caminho $alvo
    "   o arquivo ainda existe? $([bool](Test-Path $alvo))  <- removido" | Write-Output

    Write-Output ''
    Write-Output 'Regra profissional: TODA função que altera estado (apaga, modifica,'
    Write-Output 'reinicia) deveria ter SupportsShouldProcess. É a rede de segurança.'
}
finally {
    Remove-Item -Recurse -Force -LiteralPath $lab -ErrorAction SilentlyContinue
}
