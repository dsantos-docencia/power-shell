# consolidar-novos.ps1
# Move projetos de Downloads para Nao-Gitados\Novos, mantendo TUDO intocado.
# Estrategia: flat move (cada item vira uma pasta/arquivo na raiz de Novos\).
# EXCECOES agrupadas:
#   - dia01..dia10.html => Novos\curso-por-dias\
#   - curso-html*.html  => Novos\curso-html\
#
# Uso:
#   powershell -ExecutionPolicy Bypass -File .\consolidar-novos.ps1              # dry-run
#   powershell -ExecutionPolicy Bypass -File .\consolidar-novos.ps1 -Execute     # executa

param(
    [string]$Src = "C:\Users\Iconne\Downloads",
    [string]$Dst = $null,
    [switch]$Execute
)

$ErrorActionPreference = "Stop"

if (-not $Dst) {
    $atil = [char]0xE3
    $Dst = "C:\Users\Iconne\Documents\Projects\N${atil}o-Gitados\Novos"
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$logPath = Join-Path $scriptDir "consolidar-novos-log.md"
$planPath = Join-Path $scriptDir "consolidar-novos-plano.md"

$excludePatterns = @(
    '^takeout-','^Photos-','^Comparativo ','^Jimi\.Hendrix','^Marco76',
    '^metasploitable-linux','^ventoy-','^ZoomIt','^AutoLogon','^TUF-GAMING',
    '^packer_','^SW_ASUS','^VirtualBoxSDK','^Bazarr','^Plex Media Server',
    '^Windows 11 v23H2 Security Baseline','^Manual_OPSS','^Conversa do WhatsApp',
    '^blacklists_for_dansguardian','^Kit_Investigacao','^CID10XML',
    '^documento(\s|\.zip|\s\(\d+\))','^2024 conclu','^2025-2025','^8e372862',
    '^his_enterprise_hardening','^ilovepdf','^base44_mvp_mockup_pack',
    '^sqlite-dll-win-x64','^UI mockups request'
)

function Is-Excluded {
    param([string]$name)
    foreach ($p in $excludePatterns) {
        if ($name -match "(?i)$p") { return $true }
    }
    return $false
}

function Get-ItemCategory {
    param([System.IO.FileSystemInfo]$item)
    if ($item.PSIsContainer) { return "folder" }
    $ext = $item.Extension.ToLower()
    if ($ext -eq ".html") { return "html" }
    if ($item.Name -match "(?i)\.tar\.gz$") { return "zip" }
    if ($ext -in ".zip",".rar",".7z",".tar",".gz") { return "zip" }
    return $null
}

# Retorna o SUBFOLDER dentro de Novos onde o item deve ir. String vazia = raiz de Novos.
function Get-SubFolder {
    param([string]$name)
    if ($name -match '(?i)^dia(0[1-9]|10)\.html$') { return "curso-por-dias" }
    if ($name -match '(?i)^curso-html') { return "curso-html" }
    return ""
}

function Is-ProjectItem {
    param([System.IO.FileSystemInfo]$item, [string]$category)

    if (Is-Excluded $item.Name) { return $false }

    if ($category -eq "html") {
        $sizeKB = $item.Length / 1KB
        if ($sizeKB -lt 5) { return $false }
        $suggestive = $item.Name -match "(?i)dashboard|app|mockup|prototype|artifact|admin|panel|editor|builder|analytics|report|widget|calculator|tool|template|landing"
        if ($sizeKB -gt 20 -or $suggestive) { return $true }
        return $false
    }
    if ($category -eq "folder") {
        $signals = 0
        if (Test-Path (Join-Path $item.FullName "package.json")) { $signals++ }
        if (Test-Path (Join-Path $item.FullName ".git")) { $signals++ }
        if (Test-Path (Join-Path $item.FullName "src")) { $signals++ }
        if (Test-Path (Join-Path $item.FullName "README.md")) { $signals++ }
        if (Test-Path (Join-Path $item.FullName "index.html")) { $signals++ }
        if (Test-Path (Join-Path $item.FullName "requirements.txt")) { $signals++ }
        if (Test-Path (Join-Path $item.FullName "pyproject.toml")) { $signals++ }
        if (Test-Path (Join-Path $item.FullName ".gitignore")) { $signals++ }
        if (Test-Path (Join-Path $item.FullName "tsconfig.json")) { $signals++ }
        if ($signals -eq 0) {
            $codeFiles = Get-ChildItem -Path $item.FullName -File -ErrorAction SilentlyContinue |
                Where-Object { $_.Extension -in ".py",".js",".jsx",".ts",".tsx",".go",".rs",".java",".rb",".php" }
            if ($codeFiles.Count -gt 0) { $signals++ }
        }
        return ($signals -gt 0)
    }
    if ($category -eq "zip") {
        return $true
    }
    return $false
}

Write-Host "Escaneando $Src ..." -ForegroundColor Cyan
$candidates = @()

Get-ChildItem -Path $Src -File | ForEach-Object {
    $cat = Get-ItemCategory $_
    if ($cat -and (Is-ProjectItem $_ $cat)) {
        $candidates += [PSCustomObject]@{
            Name = $_.Name
            FullPath = $_.FullName
            Category = $cat
            Modified = $_.LastWriteTime
            SizeMB = [math]::Round($_.Length / 1MB, 2)
            SubFolder = Get-SubFolder $_.Name
        }
    }
}
Get-ChildItem -Path $Src -Directory | ForEach-Object {
    if (Is-ProjectItem $_ "folder") {
        $totalSize = 0
        try {
            $totalSize = (Get-ChildItem -Path $_.FullName -Recurse -File -ErrorAction SilentlyContinue |
                Measure-Object -Property Length -Sum).Sum
        } catch {}
        $candidates += [PSCustomObject]@{
            Name = $_.Name
            FullPath = $_.FullName
            Category = "folder"
            Modified = $_.LastWriteTime
            SizeMB = if ($totalSize) { [math]::Round($totalSize / 1MB, 2) } else { 0 }
            SubFolder = ""
        }
    }
}

$totalItems = $candidates.Count
Write-Host "Total de itens a mover: $totalItems" -ForegroundColor Cyan

# --- Escreve plano em Markdown ---
$md = @()
$md += "# Plano de consolidacao - Downloads para Novos (flat move)"
$md += ""
$md += "Data: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$md += "Fonte: ``$Src``"
$md += "Destino: ``$Dst``"
$md += ""
$md += "Total de itens: $totalItems"
$md += "Estrategia: flat move; excecoes -> curso-por-dias\ e curso-html\"
$md += "Modo: $(if ($Execute) { 'EXECUTAR' } else { 'DRY-RUN' })"
$md += ""

$md += "## Itens na raiz de Novos\ (ordenados por data mais recente)"
$md += ""
$md += "| Nome | Categoria | Tamanho (MB) | Modificado |"
$md += "|------|-----------|-------------:|-----------|"
foreach ($c in ($candidates | Where-Object { $_.SubFolder -eq "" } | Sort-Object -Property Modified -Descending)) {
    $md += "| $($c.Name) | $($c.Category) | $($c.SizeMB) | $($c.Modified.ToString('yyyy-MM-dd HH:mm')) |"
}
$md += ""

$subFolders = $candidates | Where-Object { $_.SubFolder -ne "" } | Group-Object -Property SubFolder
foreach ($sf in $subFolders) {
    $md += "## Novos\$($sf.Name)\ ($($sf.Count) itens)"
    $md += ""
    $md += "| Nome | Categoria | Tamanho (MB) | Modificado |"
    $md += "|------|-----------|-------------:|-----------|"
    foreach ($c in ($sf.Group | Sort-Object -Property Modified -Descending)) {
        $md += "| $($c.Name) | $($c.Category) | $($c.SizeMB) | $($c.Modified.ToString('yyyy-MM-dd HH:mm')) |"
    }
    $md += ""
}

$md -join "`r`n" | Out-File -FilePath $planPath -Encoding UTF8
Write-Host "Plano gravado em: $planPath" -ForegroundColor Yellow

if (-not $Execute) {
    Write-Host ""
    Write-Host "DRY-RUN. Nada foi movido." -ForegroundColor Yellow
    Write-Host "Revise $planPath e rode com -Execute para mover." -ForegroundColor Yellow
    exit 0
}

# --- EXECUCAO ---
Write-Host ""
Write-Host "Executando $totalItems movimentacoes..." -ForegroundColor Green

if (-not (Test-Path $Dst)) {
    New-Item -ItemType Directory -Path $Dst -Force | Out-Null
    Write-Host "Pasta destino criada: $Dst" -ForegroundColor Yellow
}

$logLines = @()
$logLines += "# Log - consolidar-novos"
$logLines += ""
$logLines += "Data: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$logLines += "Fonte: ``$Src``"
$logLines += "Destino: ``$Dst``"
$logLines += ""
$logLines += "| Nome | Categoria | Origem | Destino | Status |"
$logLines += "|------|-----------|--------|---------|--------|"

$success = 0
$fail = 0

foreach ($c in $candidates) {
    if ($c.SubFolder -ne "") {
        $targetDir = Join-Path $Dst $c.SubFolder
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
    } else {
        $targetDir = $Dst
    }
    $destPath = Join-Path $targetDir $c.Name
    $finalDest = $destPath
    try {
        $i = 0
        while (Test-Path $finalDest) {
            $i++
            if ($c.Category -eq "folder") {
                $finalDest = "$destPath -de-Downloads-$i"
            } else {
                $baseName = [System.IO.Path]::GetFileNameWithoutExtension($c.Name)
                $ext = [System.IO.Path]::GetExtension($c.Name)
                if ($c.Name -match "(?i)\.tar\.gz$") {
                    $baseName = $c.Name -replace "(?i)\.tar\.gz$", ""
                    $ext = ".tar.gz"
                }
                $finalDest = Join-Path $targetDir ("$baseName-de-Downloads-$i$ext")
            }
        }
        Move-Item -LiteralPath $c.FullPath -Destination $finalDest
        $status = "OK"
        if ($finalDest -ne $destPath) { $status = "OK (colisao renomeada)" }
        $success++
    } catch {
        $errMsg = $_.Exception.Message
        $status = "ERRO: $errMsg"
        $fail++
    }
    $logLines += "| $($c.Name) | $($c.Category) | $($c.FullPath) | $finalDest | $status |"
}

$logLines += ""
$logLines += "**Sucesso:** $success"
$logLines += "**Falhas:** $fail"
$logLines -join "`r`n" | Out-File -FilePath $logPath -Encoding UTF8

Write-Host ""
Write-Host "Concluido. Sucesso: $success, Falhas: $fail" -ForegroundColor Green
Write-Host "Log: $logPath" -ForegroundColor Yellow
