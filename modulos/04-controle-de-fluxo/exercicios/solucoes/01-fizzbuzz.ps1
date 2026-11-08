#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 04.01 — testa múltiplo de 15 (3 e 5) ANTES dos individuais.
param([int]$N)
foreach ($i in 1..$N) {
    if     ($i % 15 -eq 0) { Write-Output "FizzBuzz" }
    elseif ($i % 3  -eq 0) { Write-Output "Fizz" }
    elseif ($i % 5  -eq 0) { Write-Output "Buzz" }
    else                    { Write-Output $i }
}
