<#
============================================================================
  Curso de PowerShell · Módulo 07 · Exemplo 01 — try/catch/finally e throw
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Interceptar exceções, limpar com finally, lançar com throw e
            capturar tipos específicos.
  EXECUTE   pwsh ./01-try-catch.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) try/catch básico (divisão por zero é um erro terminante):'
try {
    $null = 10 / 0
}
catch {
    "   peguei o erro: $($_.Exception.Message)" | Write-Output
}

Write-Output ''
Write-Output '2) finally roda SEMPRE (como o trap EXIT do Bash):'
function Processar {
    try {
        Write-Output '   - abrindo recurso'
        throw 'falha simulada no meio'
    }
    catch {
        "   - catch: $($_.Exception.Message)" | Write-Output
    }
    finally {
        Write-Output '   - finally: recurso liberado (sempre)'
    }
}
Processar

Write-Output ''
Write-Output '3) throw para validar e lançar seu próprio erro:'
function Test-Positivo([int]$N) {
    if ($N -lt 0) { throw "valor negativo não permitido: $N" }
    $N
}
try { Test-Positivo -N -5 }
catch { "   ✔ rejeitado: $($_.Exception.Message)" | Write-Output }

Write-Output ''
Write-Output '4) Capturar TIPOS específicos de exceção (do mais específico ao genérico):'
function Ler-Numero([string]$Texto) {
    try {
        $n = [int]::Parse($Texto)
        "   convertido: $n" | Write-Output
    }
    catch [System.FormatException] {
        "   ✔ FormatException: '$Texto' não é um número" | Write-Output
    }
    catch {
        "   erro genérico: $($_.Exception.Message)" | Write-Output
    }
}
Ler-Numero '42'
Ler-Numero 'abc'
