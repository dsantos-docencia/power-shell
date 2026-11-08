#!/usr/bin/env pwsh
<#  Curso de PowerShell · Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)  #>
# Solução 08.02
param([double]$L, [double]$H)
class Retangulo {
    [double]$Largura
    [double]$Altura
    Retangulo([double]$largura, [double]$altura) {
        $this.Largura = $largura
        $this.Altura = $altura
    }
    [double] Area() { return $this.Largura * $this.Altura }
}
$r = [Retangulo]::new($L, $H)
Write-Output $r.Area()
