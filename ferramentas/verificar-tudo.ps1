<#
============================================================================
  Curso de PowerShell · ferramentas/verificar-tudo.ps1 — Garantia de qualidade
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  A promessa do repositório: TODO exemplo aqui funciona. Roda localmente e no CI.

  Etapas:
    1. Sintaxe        — parser do PowerShell em todos os .ps1 (exceto scripts/)
    2. PSScriptAnalyzer — linter oficial (se instalado)
    3. Exemplos       — executa cada modulos/*/exemplos/NN-*.ps1 e exige exit 0
    4. Soluções       — roda o corretor contra as soluções oficiais
    5. Projetos       — roda os testes de cada projeto

  USO:  ./ferramentas/verificar-tudo.ps1 [-Rapido]   (-Rapido pula a etapa 3)
============================================================================
#>
[CmdletBinding()]
param([switch]$Rapido)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$raiz = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $raiz
Import-Module (Join-Path $PSScriptRoot 'lib/Teste.psm1') -Force -DisableNameChecking

$erros = 0
function Titulo($t) { Write-Host ("`n{0}== {1} =={2}" -f "`e[1m", $t, "`e[0m") }
function Ok($m)     { Write-Host ("  {0}✔{1} {2}" -f "`e[32m", "`e[0m", $m) }
function Falha($m)  { Write-Host ("  {0}✘{1} {2}" -f "`e[31m", "`e[0m", $m); $script:erros++ }
function Aviso($m)  { Write-Host ("  {0}!{1} {2}" -f "`e[33m", "`e[0m", $m) }

# Lista de .ps1 e .psm1 do curso (exclui o acervo em scripts/ e os ESQUELETOS
# de exercício, que são intencionalmente incompletos — o aluno é quem os completa;
# as soluções e os testes continuam sendo analisados).
$sep = [IO.Path]::DirectorySeparatorChar
$arquivos = Get-ChildItem -Path $raiz -Recurse -Include '*.ps1', '*.psm1' |
            Where-Object { $_.FullName -notmatch ([regex]::Escape($sep + 'scripts' + $sep)) } |
            Where-Object { $_.Directory.Name -ne 'exercicios' } |
            Sort-Object FullName

Titulo "1. Sintaxe (parser) — $($arquivos.Count) arquivos"
$n = 0
foreach ($a in $arquivos) {
    $errs = $null
    [System.Management.Automation.Language.Parser]::ParseFile($a.FullName, [ref]$null, [ref]$errs) | Out-Null
    if ($errs) { Falha ($a.FullName -replace [regex]::Escape($raiz), '.'); $errs | ForEach-Object { Write-Host "      $($_.Message)" } }
    else { $n++ }
}
Ok "$n arquivos com sintaxe válida"

Titulo "2. PSScriptAnalyzer"
if (Get-Module -ListAvailable PSScriptAnalyzer) {
    Import-Module PSScriptAnalyzer
    $settings = Join-Path $raiz 'PSScriptAnalyzerSettings.psd1'
    $diag = foreach ($a in $arquivos) {
        if (Test-Path $settings) { Invoke-ScriptAnalyzer -Path $a.FullName -Settings $settings -ErrorAction SilentlyContinue }
        else { Invoke-ScriptAnalyzer -Path $a.FullName -Severity Warning, Error -ErrorAction SilentlyContinue }
    }
    if ($diag) {
        Falha "PSScriptAnalyzer encontrou $(@($diag).Count) problema(s):"
        $diag | ForEach-Object { Write-Host ("      {0}:{1} [{2}] {3}" -f (Split-Path -Leaf $_.ScriptPath), $_.Line, $_.RuleName, $_.Message) }
    } else { Ok "nenhum aviso" }
} else {
    Aviso "PSScriptAnalyzer não instalado — etapa pulada (Install-Module PSScriptAnalyzer)"
}

if (-not $Rapido) {
    Titulo "3. Execução dos exemplos"
    $exemplos = Get-ChildItem -Path (Join-Path $raiz 'modulos') -Recurse -Filter '*.ps1' -ErrorAction SilentlyContinue |
                Where-Object { $_.Directory.Name -eq 'exemplos' -and $_.Name -match '^\d{2}-' } | Sort-Object FullName
    foreach ($ex in $exemplos) {
        $tmp = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
        New-Item -ItemType Directory -Path $tmp -Force | Out-Null
        $pwshExe = (Get-Process -Id $PID).Path
        $out = Join-Path $tmp 'o.txt'; $err = Join-Path $tmp 'e.txt'
        $p = Start-Process -FilePath $pwshExe -ArgumentList @('-NoProfile', '-NonInteractive', '-File', $ex.FullName) `
                -WorkingDirectory $tmp -NoNewWindow -PassThru -RedirectStandardOutput $out -RedirectStandardError $err
        if (-not $p.WaitForExit(90000)) { try { $p.Kill() } catch { Write-Verbose "processo já encerrado: $_" }; Falha "$($ex.Name) (timeout)"; }
        elseif ($p.ExitCode -ne 0) {
            Falha ($ex.FullName -replace [regex]::Escape($raiz), '.')
            Get-Content -Raw $err -EA SilentlyContinue | Select-Object -First 1 | ForEach-Object { Write-Host "      $_" }
        } else { Ok ($ex.FullName -replace [regex]::Escape($raiz), '.') }
        Remove-Item -Recurse -Force $tmp -EA SilentlyContinue
    }

    Titulo "3b. Testes Pester (se houver)"
    if (Get-Module -ListAvailable Pester) {
        $specs = Get-ChildItem -Path $raiz -Recurse -Filter '*.Tests.ps1' -EA SilentlyContinue
        if ($specs) {
            $cfg = New-PesterConfiguration
            $cfg.Run.Path = $specs.FullName
            $cfg.Output.Verbosity = 'None'
            $cfg.Run.PassThru = $true
            $res = Invoke-Pester -Configuration $cfg
            if ($res.FailedCount -eq 0) { Ok "$($res.PassedCount) testes Pester passaram" }
            else { Falha "$($res.FailedCount) teste(s) Pester falharam" }
        } else { Aviso "nenhum arquivo *.Tests.ps1 (Pester) encontrado" }
    } else { Aviso "Pester não instalado — etapa pulada" }
}

Titulo "4. Soluções oficiais contra os testes"
$corr = & (Join-Path $PSScriptRoot 'corrigir.ps1') -Todos -Solucao *>&1
if ($LASTEXITCODE -eq 0) { Ok "todas as soluções passam ($(@($corr | Select-String '✔').Count) casos)" }
else { Falha "alguma solução falhou"; $corr | Select-String '✘|▶' | ForEach-Object { Write-Host "    $_" } }

Titulo "5. Testes dos projetos"
$projTestes = Get-ChildItem -Path (Join-Path $raiz 'projetos') -Recurse -Filter '*.Testes.ps1' -EA SilentlyContinue
foreach ($t in $projTestes) {
    $alvo = Join-Path (Split-Path -Parent (Split-Path -Parent $t.FullName)) (($t.Name -replace '\.Testes\.ps1$', '') + '.ps1')
    if (Invoke-Testes -ArquivoTeste $t.FullName -Alvo $alvo) { Ok $t.Name } else { Falha $t.Name }
}

Write-Host ''
if ($erros -eq 0) { Write-Host ("{0}{1}Repositório íntegro.{2}" -f "`e[1m", "`e[32m", "`e[0m"); exit 0 }
Write-Host ("{0}{1}{2} problema(s) encontrado(s).{3}" -f "`e[1m", "`e[31m", $erros, "`e[0m"); exit 1
