# Testes do Projeto 02 — Limpeza
function Novo-Cenario {
    $d = Join-Path ([System.IO.Path]::GetTempPath()) ("lmp_" + [guid]::NewGuid().ToString('N').Substring(0,6))
    New-Item -ItemType Directory -Path $d -Force | Out-Null
    $velho = Join-Path $d 'velho.log'; 'x' | Set-Content $velho
    (Get-Item $velho).LastWriteTime = (Get-Date).AddDays(-100)
    $novo = Join-Path $d 'novo.log'; 'y' | Set-Content $novo
    return $d
}
function Teste-SimulaNaoApaga {
    $d = Novo-Cenario
    Invoke-Alvo -Caminho $d -Dias 30
    $aindaExiste = Test-Path (Join-Path $d 'velho.log')
    Remove-Item $d -Recurse -Force
    Afirmar-Contem "simulados=1" $global:SAIDA
    if (-not $aindaExiste) { throw "arquivo foi apagado no modo simulação!" }
}
function Teste-ExecutaApaga {
    $d = Novo-Cenario
    Invoke-Alvo -Caminho $d -Dias 30 -Executar
    $velhoSumiu = -not (Test-Path (Join-Path $d 'velho.log'))
    $novoFicou  = Test-Path (Join-Path $d 'novo.log')
    Remove-Item $d -Recurse -Force
    Afirmar-Contem "removidos=1" $global:SAIDA
    if (-not $velhoSumiu) { throw "o arquivo velho deveria ter sido removido" }
    if (-not $novoFicou)  { throw "o arquivo novo NAO deveria ter sido tocado" }
}
function Teste-Idempotente {
    $d = Novo-Cenario
    Invoke-Alvo -Caminho $d -Dias 30 -Executar | Out-Null
    Invoke-Alvo -Caminho $d -Dias 30 -Executar   # 2a passada: nada a fazer
    Remove-Item $d -Recurse -Force
    Afirmar-Contem "removidos=0" $global:SAIDA
}
