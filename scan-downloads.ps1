# scan-downloads.ps1
# Escaneia C:\Users\Iconne\Downloads e classifica itens em 3 categorias:
#   1) HTMLs soltos que parecem projeto
#   2) Pastas de projeto (package.json, .git, src, README, .py/.js/.tsx)
#   3) Arquivos zipados (.zip .rar .7z .tar .tar.gz) que aparentam ser projeto
# NAO MOVE NADA. Gera scan-downloads-report.md e scan-downloads-manifest.json na mesma pasta do script.

param(
    [string]$DownloadsPath = "C:\Users\Iconne\Downloads"
)

$ErrorActionPreference = "Continue"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$reportPath = Join-Path $scriptDir "scan-downloads-report.md"
$manifestPath = Join-Path $scriptDir "scan-downloads-manifest.json"

if (-not (Test-Path $DownloadsPath)) {
    Write-Error "Pasta nao encontrada: $DownloadsPath"
    exit 1
}

Write-Host "Escaneando $DownloadsPath ..." -ForegroundColor Cyan

$htmls = @()
$folders = @()
$zips = @()

# --- 1) HTMLs soltos ---
Get-ChildItem -Path $DownloadsPath -File -Filter *.html -ErrorAction SilentlyContinue | ForEach-Object {
    $sizeKB = [math]::Round($_.Length / 1KB, 1)
    $isProject = $false
    $reason = ""

    # Heuristicas: tamanho > 20KB, ou nome sugestivo, ou script/style embutido
    $suggestive = $_.Name -match "(?i)dashboard|app|mockup|prototype|artifact|admin|panel|editor|builder|analytics|report|widget|calculator|tool|game|demo|template|landing"

    if ($sizeKB -gt 20) {
        $isProject = $true
        $reason = "tamanho $sizeKB KB"
    }
    if ($suggestive) {
        $isProject = $true
        if ($reason) { $reason += "; " }
        $reason += "nome sugestivo"
    }

    # Confirma com sniff: tem <script> extenso ou <style> extenso?
    if ($isProject -or $sizeKB -gt 5) {
        try {
            $content = Get-Content -Path $_.FullName -Raw -ErrorAction SilentlyContinue
            if ($content) {
                $scriptMatches = ([regex]"<script[\s>]").Matches($content).Count
                $styleMatches = ([regex]"<style[\s>]").Matches($content).Count
                if ($scriptMatches -ge 1 -and $content.Length -gt 20000) {
                    $isProject = $true
                    if ($reason -notmatch "JS embutido") {
                        if ($reason) { $reason += "; " }
                        $reason += "JS embutido"
                    }
                }
                if ($styleMatches -ge 1 -and $content.Length -gt 20000) {
                    if ($reason -notmatch "CSS embutido") {
                        if ($reason) { $reason += "; " }
                        $reason += "CSS embutido"
                    }
                }
            }
        } catch {}
    }

    if ($isProject) {
        $htmls += [PSCustomObject]@{
            Name = $_.Name
            SizeKB = $sizeKB
            Modified = $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
            Reason = $reason
            FullPath = $_.FullName
        }
    }
}

# --- 2) Pastas de projeto ---
Get-ChildItem -Path $DownloadsPath -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $folder = $_
    $signals = @()

    if (Test-Path (Join-Path $folder.FullName "package.json")) { $signals += "package.json" }
    if (Test-Path (Join-Path $folder.FullName ".git")) { $signals += ".git" }
    if (Test-Path (Join-Path $folder.FullName "src")) { $signals += "src/" }
    if (Test-Path (Join-Path $folder.FullName "README.md")) { $signals += "README" }
    if (Test-Path (Join-Path $folder.FullName "requirements.txt")) { $signals += "requirements.txt" }
    if (Test-Path (Join-Path $folder.FullName "pyproject.toml")) { $signals += "pyproject.toml" }
    if (Test-Path (Join-Path $folder.FullName "index.html")) { $signals += "index.html" }
    if (Test-Path (Join-Path $folder.FullName "Cargo.toml")) { $signals += "Cargo.toml" }
    if (Test-Path (Join-Path $folder.FullName "go.mod")) { $signals += "go.mod" }
    if (Test-Path (Join-Path $folder.FullName ".gitignore")) { $signals += ".gitignore" }
    if (Test-Path (Join-Path $folder.FullName "tsconfig.json")) { $signals += "tsconfig.json" }

    # Codigo na raiz da pasta
    $codeFiles = Get-ChildItem -Path $folder.FullName -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Extension -in ".py",".js",".jsx",".ts",".tsx",".go",".rs",".java",".rb",".php" }
    if ($codeFiles.Count -gt 0) { $signals += "codigo($($codeFiles.Count))" }

    if ($signals.Count -gt 0) {
        $totalSize = 0
        try {
            $totalSize = (Get-ChildItem -Path $folder.FullName -Recurse -File -ErrorAction SilentlyContinue |
                Measure-Object -Property Length -Sum).Sum
        } catch {}
        $sizeMB = if ($totalSize) { [math]::Round($totalSize / 1MB, 1) } else { 0 }

        $folders += [PSCustomObject]@{
            Name = $folder.Name
            SizeMB = $sizeMB
            Modified = $folder.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
            Reason = ($signals -join ", ")
            FullPath = $folder.FullName
        }
    }
}

# --- 3) Zipados ---
$zipExts = @(".zip", ".rar", ".7z", ".tar", ".gz")
Get-ChildItem -Path $DownloadsPath -File -ErrorAction SilentlyContinue | Where-Object {
    $ext = $_.Extension.ToLower()
    $isZip = $ext -in $zipExts -or $_.Name -match "\.tar\.gz$"
    $isZip
} | ForEach-Object {
    $sizeMB = [math]::Round($_.Length / 1MB, 2)
    $suggestive = $_.Name -match "(?i)project|projeto|app|src|source|code|frontend|backend|dashboard|admin|api|repo|master|main|starter|template|scaffold|boilerplate|-v\d|-old|-copy|_v\d|-final"

    $reason = "arquivo compactado ($sizeMB MB)"
    if ($suggestive) { $reason += "; nome sugestivo de projeto" }

    # Nao filtra por conteudo aqui (nao extrai). Deixa todos os zips na lista mas marca os sugestivos.
    $zips += [PSCustomObject]@{
        Name = $_.Name
        SizeMB = $sizeMB
        Modified = $_.LastWriteTime.ToString("yyyy-MM-dd HH:mm")
        Reason = $reason
        Suggestive = [bool]$suggestive
        FullPath = $_.FullName
    }
}

# --- Gera relatorio Markdown ---
$md = @()
$md += "# Scan Downloads Report"
$md += ""
$md += "Data do scan: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$md += "Pasta escaneada: ``$DownloadsPath``"
$md += ""
$md += "## 1. HTMLs de projeto ($($htmls.Count))"
$md += ""
if ($htmls.Count -gt 0) {
    $md += "| Nome | Tamanho (KB) | Modificado | Motivo |"
    $md += "|------|-------------:|-----------|--------|"
    foreach ($h in ($htmls | Sort-Object Modified -Descending)) {
        $md += "| $($h.Name) | $($h.SizeKB) | $($h.Modified) | $($h.Reason) |"
    }
} else {
    $md += "_Nenhum HTML de projeto detectado._"
}
$md += ""
$md += "## 2. Pastas de projeto ($($folders.Count))"
$md += ""
if ($folders.Count -gt 0) {
    $md += "| Nome | Tamanho (MB) | Modificado | Sinais |"
    $md += "|------|-------------:|-----------|--------|"
    foreach ($f in ($folders | Sort-Object Modified -Descending)) {
        $md += "| $($f.Name) | $($f.SizeMB) | $($f.Modified) | $($f.Reason) |"
    }
} else {
    $md += "_Nenhuma pasta de projeto detectada._"
}
$md += ""
$md += "## 3. Arquivos zipados ($($zips.Count))"
$md += ""
if ($zips.Count -gt 0) {
    $md += "| Nome | Tamanho (MB) | Modificado | Sugestivo | Motivo |"
    $md += "|------|-------------:|-----------|:---------:|--------|"
    foreach ($z in ($zips | Sort-Object Modified -Descending)) {
        $sug = if ($z.Suggestive) { "sim" } else { "nao" }
        $md += "| $($z.Name) | $($z.SizeMB) | $($z.Modified) | $sug | $($z.Reason) |"
    }
} else {
    $md += "_Nenhum arquivo zipado detectado._"
}
$md += ""
$md += "---"
$md += ""
$md += "**Totais:** $($htmls.Count) HTMLs, $($folders.Count) pastas, $($zips.Count) zips."

$md -join "`n" | Out-File -FilePath $reportPath -Encoding UTF8

# --- Gera manifesto JSON (para a Fase 2) ---
$manifest = [PSCustomObject]@{
    scannedAt = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss")
    downloadsPath = $DownloadsPath
    htmls = $htmls
    folders = $folders
    zips = $zips
}
$manifest | ConvertTo-Json -Depth 5 | Out-File -FilePath $manifestPath -Encoding UTF8

Write-Host ""
Write-Host "Concluido." -ForegroundColor Green
Write-Host "Relatorio: $reportPath" -ForegroundColor Yellow
Write-Host "Manifesto: $manifestPath" -ForegroundColor Yellow
Write-Host ""
Write-Host "Totais: $($htmls.Count) HTMLs, $($folders.Count) pastas, $($zips.Count) zips" -ForegroundColor Cyan
