#Requires -Version 7.0
<#
============================================================================
  Módulo Iconne.Infra — utilitários de infraestrutura
  Projeto 05 · Curso de PowerShell · Prof. Daniel Santos
  github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
  ---------------------------------------------------------------------------
  Aplica o Módulo 11: funções reutilizáveis, públicas e privadas separadas,
  empacotadas com manifesto (.psd1). Importe e use em qualquer script da casa.
============================================================================
#>
Set-StrictMode -Version Latest

function Convert-ParaTamanhoLegivel {
    <#
    .SYNOPSIS
        Converte bytes em texto legível (KB, MB, GB...).
    .EXAMPLE
        Convert-ParaTamanhoLegivel -Bytes 1536   # -> "1.5 KB"
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param([Parameter(Mandatory)][long]$Bytes)

    if ($Bytes -lt 0) { throw "Bytes não pode ser negativo." }
    $unidades = 'B', 'KB', 'MB', 'GB', 'TB', 'PB'
    $valor = [double]$Bytes
    $i = 0
    while ($valor -ge 1024 -and $i -lt ($unidades.Count - 1)) {
        $valor = $valor / 1024
        $i++
    }
    if ($i -eq 0) { return "$Bytes B" }
    return ('{0:N1} {1}' -f $valor, $unidades[$i])
}

function Test-NomeRecurso {
    <#
    .SYNOPSIS
        Valida um nome de recurso no padrão da casa: tudo minúsculo,
        no formato "tipo-identificador" (ex.: "srv-web01", "db-vendas").
    .EXAMPLE
        Test-NomeRecurso -Nome 'srv-web01'   # -> $true
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param([Parameter(Mandatory)][string]$Nome)

    return [bool]($Nome -cmatch '^[a-z]+-[a-z0-9]+$')
}

function New-IdRecurso {
    <#
    .SYNOPSIS
        Gera um id curto e único para um recurso: "<prefixo>-<6 hex>".
    .EXAMPLE
        New-IdRecurso -Prefixo 'vm'   # -> "vm-a1b2c3"
    #>
    [CmdletBinding()]
    [OutputType([string])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Gera um id em memória, como New-Guid; não altera estado.')]
    param([Parameter(Mandatory)][string]$Prefixo)

    if (-not (Test-SufixoValido $Prefixo)) { throw "Prefixo inválido: use só letras minúsculas." }
    $hex = [guid]::NewGuid().ToString('N').Substring(0, 6)
    return "$Prefixo-$hex"
}

# ---- Função PRIVADA (não exportada): ajudante interno ----------------------
function Test-SufixoValido {
    param([string]$Texto)
    return [bool]($Texto -cmatch '^[a-z]+$')
}

Export-ModuleMember -Function Convert-ParaTamanhoLegivel, Test-NomeRecurso, New-IdRecurso
