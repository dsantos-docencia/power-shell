<#
============================================================================
  Curso de PowerShell · Módulo 00 · Exemplo 01 — Objeto vs. Texto
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Ver, na prática, a ideia central do PowerShell: comandos devolvem
            OBJETOS com propriedades, não texto para recortar.
  EXECUTE   pwsh ./01-objeto-vs-texto.ps1
  SEGURO    Cria arquivos só numa pasta temporária, removida no fim.
============================================================================
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Monta um laboratório descartável e garante a limpeza com try/finally.
$lab = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
New-Item -ItemType Directory -Path $lab | Out-Null
try {
    # Cria 3 arquivos de tamanhos diferentes.
    Set-Content -Path (Join-Path $lab 'pequeno.txt')  -Value ('a' * 50)
    Set-Content -Path (Join-Path $lab 'medio.txt')    -Value ('b' * 2000)
    Set-Content -Path (Join-Path $lab 'grande.txt')   -Value ('c' * 10000)

    Write-Output '1) Get-ChildItem NÃO devolve texto — devolve OBJETOS de arquivo.'
    Write-Output '   Cada objeto tem propriedades como .Name e .Length (um número real):'
    $arquivos = Get-ChildItem -Path $lab
    foreach ($a in $arquivos) {
        # Acessamos PROPRIEDADES do objeto. Nada de recortar colunas de texto.
        '   {0,-14} {1,6} bytes' -f $a.Name, $a.Length | Write-Output
    }

    Write-Output ''
    Write-Output '2) "Os 2 maiores" = ordenar pela PROPRIEDADE Length e pegar os 2 primeiros:'
    Get-ChildItem -Path $lab |
        Sort-Object -Property Length -Descending |
        Select-Object -First 2 -Property Name, Length |
        ForEach-Object { '   {0} ({1} bytes)' -f $_.Name, $_.Length | Write-Output }

    Write-Output ''
    Write-Output '3) Como o Length é um NÚMERO (não texto), dá para fazer conta direto:'
    $total = ($arquivos | Measure-Object -Property Length -Sum).Sum
    Write-Output ("   soma dos tamanhos = {0} bytes ({1:N1} KB)" -f $total, ($total / 1KB))

    Write-Output ''
    Write-Output 'No Bash, você recortaria colunas da saída do "ls -l" com awk/cut e'
    Write-Output 'torceria para o formato não mudar. Aqui, você pergunta ao objeto.'
}
finally {
    Remove-Item -Recurse -Force -LiteralPath $lab -ErrorAction SilentlyContinue
}
