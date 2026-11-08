<#
============================================================================
  Curso de PowerShell — Do Zero à Automação Corporativa
  ferramentas/lib/Teste.psm1 — Mini framework de testes em PowerShell puro

  Autor: Prof. Daniel Santos · https://github.com/dsantos-docencia/power-shell
  © 2026 Daniel Santos — Código sob PolyForm Noncommercial 1.0.0 (veja LICENSE)
============================================================================

  POR QUE UM FRAMEWORK PRÓPRIO?
  ----------------------------------------------------------------------------
  O padrão de mercado para testar PowerShell é o Pester — e ele é ensinado
  no Módulo 10. Mas exigir instalação logo na primeira aula cria atrito.
  Este módulo não tem dependências e é ele mesmo material de estudo.

  COMO UM ARQUIVO DE TESTE É ESCRITO
  ----------------------------------------------------------------------------
    function Teste-SaudacaoPadrao {
        Invoke-Alvo                 # roda o script do aluno sem argumentos
        Afirmar-Status 0
        Afirmar-Igual "Olá, mundo!" $global:SAIDA
    }

  Toda função cujo nome começa com "Teste-" é descoberta e executada, cada
  uma num diretório temporário próprio.

  VARIÁVEIS DISPONÍVEIS DENTRO DE UM TESTE (escopo global)
    $ALVO    caminho do script sendo testado
    $SAIDA   stdout da última chamada a Invoke-Alvo (linhas unidas por \n)
    $ERRO    stderr da última chamada
    $STATUS  código de saída da última chamada
============================================================================
#>

Set-StrictMode -Version Latest

# Tempo máximo (segundos) de cada execução do script do aluno.
if (-not (Test-Path variable:global:TempoLimite)) { $global:TempoLimite = 20 }

$global:SAIDA  = ''
$global:ERRO   = ''
$global:STATUS = 0

# ----------------------------------------------------------------------------
# Invoke-Alvo [args...]
#   Roda $ALVO num processo pwsh ISOLADO, capturando stdout, stderr e exit code.
# ----------------------------------------------------------------------------
function Invoke-Alvo {
    param([Parameter(ValueFromRemainingArguments = $true)] $Args)

    $pwshExe = (Get-Process -Id $PID).Path   # o mesmo pwsh que está rodando

    # Usamos ProcessStartInfo.ArgumentList: ele CITA cada argumento corretamente,
    # inclusive os que têm espaços (um Start-Process -ArgumentList não faz isso).
    $psi = [System.Diagnostics.ProcessStartInfo]::new()
    $psi.FileName = $pwshExe
    foreach ($a in @('-NoProfile', '-NonInteractive', '-File', $global:ALVO)) { $psi.ArgumentList.Add([string]$a) }
    if ($Args) { foreach ($a in $Args) { $psi.ArgumentList.Add([string]$a) } }
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError  = $true
    $psi.UseShellExecute = $false

    $p = [System.Diagnostics.Process]::Start($psi)
    # ReadToEnd bloqueia até o processo fechar o stream — padrão para saída limitada.
    $out = $p.StandardOutput.ReadToEnd()
    $err = $p.StandardError.ReadToEnd()
    if (-not $p.WaitForExit($global:TempoLimite * 1000)) {
        try { $p.Kill() } catch { Write-Verbose "processo já encerrado: $_" }
        Falhar "o script passou de $($global:TempoLimite)s (laço infinito? Read-Host esperando teclado?)"
    }
    $global:STATUS = $p.ExitCode
    $global:SAIDA  = ($out ?? '').TrimEnd("`r", "`n")
    $global:ERRO   = ($err ?? '').TrimEnd("`r", "`n")
}

# ----------------------------------------------------------------------------
# Asserções — cada uma lança (throw) com uma explicação didática ao falhar.
# ----------------------------------------------------------------------------
function Afirmar-Igual {
    param($Esperado, $Obtido, [string]$Mensagem = 'valores diferentes')
    if ("$Esperado" -ceq "$Obtido") { return }
    Falhar $Mensagem "esperado: «$Esperado»" "obtido:   «$Obtido»"
}

function Afirmar-Contem {
    param([string]$Trecho, [string]$Texto, [string]$Mensagem = 'trecho não encontrado')
    if ($Texto -like "*$Trecho*") { return }
    Falhar $Mensagem "procurado: «$Trecho»" "no texto:  «$Texto»"
}

function Afirmar-NaoContem {
    param([string]$Trecho, [string]$Texto, [string]$Mensagem = 'trecho não deveria aparecer')
    if ($Texto -notlike "*$Trecho*") { return }
    Falhar $Mensagem "trecho: «$Trecho»"
}

function Afirmar-Casa {
    param([string]$Regex, [string]$Texto, [string]$Mensagem = 'texto não casa com o padrão')
    if ($Texto -match $Regex) { return }
    Falhar $Mensagem "regex: $Regex" "texto: «$Texto»"
}

function Afirmar-Status {
    param([int]$Codigo, [string]$Mensagem = 'código de saída inesperado')
    if ($global:STATUS -eq $Codigo) { return }
    Falhar $Mensagem "esperado: $Codigo" "obtido:   $($global:STATUS)" "stderr:   «$($global:ERRO)»"
}

function Afirmar-StatusDiferenteDeZero {
    param([string]$Mensagem = 'o script deveria falhar (status != 0), mas terminou com 0')
    if ($global:STATUS -ne 0) { return }
    Falhar $Mensagem
}

function Afirmar-Arquivo {
    param([string]$Caminho, [string]$Mensagem = 'arquivo não existe')
    if (Test-Path -LiteralPath $Caminho -PathType Leaf) { return }
    Falhar $Mensagem "caminho: $Caminho"
}

function Afirmar-Diretorio {
    param([string]$Caminho, [string]$Mensagem = 'diretório não existe')
    if (Test-Path -LiteralPath $Caminho -PathType Container) { return }
    Falhar $Mensagem "caminho: $Caminho"
}

# ----------------------------------------------------------------------------
# Internos
# ----------------------------------------------------------------------------
function Falhar {
    param([string]$Motivo, [Parameter(ValueFromRemainingArguments = $true)] [string[]]$Detalhes)
    $msg = "ASSERCAO_FALHOU::$Motivo"
    if ($Detalhes) { $msg += "`n" + (($Detalhes | ForEach-Object { "        $_" }) -join "`n") }
    throw $msg
}

# Invoke-Testes -ArquivoTeste <caminho> -Alvo <caminho>
#   Carrega o arquivo de teste, descobre funções Teste-* e executa cada uma.
#   Retorna $true se todas passarem.
function Invoke-Testes {
    param([string]$ArquivoTeste, [string]$Alvo)

    $esc = @{ Verde = "`e[32m"; Vermelho = "`e[31m"; Amarelo = "`e[33m"; Negrito = "`e[1m"; Apagado = "`e[2m"; Reset = "`e[0m" }
    if (-not [Console]::IsOutputRedirected -eq $false) { }  # cores sempre (o terminal entende)

    $global:ALVO = (Resolve-Path -LiteralPath $Alvo).Path

    # Carrega as funções de teste no escopo atual.
    . $ArquivoTeste

    $testes = Get-Command -CommandType Function -Name 'Teste-*' -ErrorAction SilentlyContinue |
              Where-Object { $_.ScriptBlock.File -eq (Resolve-Path -LiteralPath $ArquivoTeste).Path }
    # fallback: se o filtro por arquivo não achar (dot-source muda File), pega todas Teste-*
    if (-not $testes) { $testes = Get-Command -CommandType Function -Name 'Teste-*' -ErrorAction SilentlyContinue }

    $total = 0; $ok = 0
    foreach ($t in $testes) {
        $total++
        $dirTmp = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
        New-Item -ItemType Directory -Path $dirTmp -Force | Out-Null
        $anterior = Get-Location
        try {
            Set-Location -LiteralPath $dirTmp
            & $t.Name
            $ok++
            Write-Host ("    {0}✔{1} {2}" -f $esc.Verde, $esc.Reset, ($t.Name -replace '^Teste-', ''))
        }
        catch {
            $linhas = ($_.Exception.Message -replace '^ASSERCAO_FALHOU::', '')
            Write-Host ("    {0}✘ {1}{2}" -f $esc.Vermelho, ($t.Name -replace '^Teste-', ''), $esc.Reset)
            foreach ($l in ($linhas -split "`n")) {
                Write-Host ("      {0}{1}{2}" -f $esc.Apagado, $l, $esc.Reset)
            }
        }
        finally {
            Set-Location -LiteralPath $anterior
            Remove-Item -LiteralPath $dirTmp -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item ("Function:\" + $t.Name) -ErrorAction SilentlyContinue
        }
    }

    if ($total -eq 0) {
        Write-Host ("    {0}Nenhum teste encontrado em {1}{2}" -f $esc.Amarelo, $ArquivoTeste, $esc.Reset)
        return $false
    }
    if ($ok -eq $total) {
        Write-Host ("  {0}{1}{2}/{3} testes passaram — mandou bem!{4}" -f $esc.Negrito, $esc.Verde, $ok, $total, $esc.Reset)
        return $true
    }
    Write-Host ("  {0}{1}{2}/{3} testes passaram — leia as dicas acima e tente de novo.{4}" -f $esc.Negrito, $esc.Amarelo, $ok, $total, $esc.Reset)
    return $false
}

Export-ModuleMember -Function Invoke-Alvo, Invoke-Testes, Afirmar-Igual, Afirmar-Contem,
    Afirmar-NaoContem, Afirmar-Casa, Afirmar-Status, Afirmar-StatusDiferenteDeZero,
    Afirmar-Arquivo, Afirmar-Diretorio, Falhar
