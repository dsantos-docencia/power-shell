# consolidar-nao-gitados.ps1
# Move duas duplicatas confirmadas da raiz de Nao-Gitados para _versoes-antigas
# dentro das versoes vencedoras.

$ErrorActionPreference = "Continue"

$atil = [char]0xE3
$root = "C:\Users\Iconne\Documents\Projects\N${atil}o-Gitados"

Write-Host ""
Write-Host "=== Consolidacao Nao-Gitados ===" -ForegroundColor Cyan
Write-Host "Raiz: $root" -ForegroundColor Yellow
Write-Host ""

$grupos = @(
    @{
        Nome = "qualidade"
        Origem = Join-Path $root "qualidade"
        DestinoPai = Join-Path $root "qualidade-copy\_versoes-antigas"
        Destino = Join-Path $root "qualidade-copy\_versoes-antigas\qualidade"
    },
    @{
        Nome = "onboardpro"
        Origem = Join-Path $root "onboardpro"
        DestinoPai = Join-Path $root "onboardpro-copy\_versoes-antigas"
        Destino = Join-Path $root "onboardpro-copy\_versoes-antigas\onboardpro"
    }
)

$ok = 0
$pular = 0
$erro = 0
$i = 0
foreach ($g in $grupos) {
    $i++
    Write-Host "[$i/$($grupos.Count)] Grupo: $($g.Nome)"
    if (-not (Test-Path $g.Origem)) {
        Write-Host "  [PULAR] Origem nao existe: $($g.Origem)" -ForegroundColor Yellow
        $pular++
        continue
    }
    if (Test-Path $g.Destino) {
        Write-Host "  [PULAR] Destino ja existe: $($g.Destino)" -ForegroundColor Yellow
        $pular++
        continue
    }
    try {
        if (-not (Test-Path $g.DestinoPai)) {
            New-Item -ItemType Directory -Path $g.DestinoPai -Force | Out-Null
        }
        Move-Item -LiteralPath $g.Origem -Destination $g.Destino
        Write-Host "  [OK] $($g.Origem) -> $($g.Destino)" -ForegroundColor Green
        $ok++
    } catch {
        Write-Host "  [ERRO] $($_.Exception.Message)" -ForegroundColor Red
        $erro++
    }
}

Write-Host ""
Write-Host "=== Concluido ===" -ForegroundColor Cyan
Write-Host "OK: $ok  Pulados: $pular  Erros: $erro"
