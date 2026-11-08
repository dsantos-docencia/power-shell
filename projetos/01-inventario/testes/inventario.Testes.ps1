# Testes do Projeto 01 — Inventário
function Teste-Resumo {
    $d = Join-Path ([System.IO.Path]::GetTempPath()) ("inv_" + [guid]::NewGuid().ToString('N').Substring(0,6))
    New-Item -ItemType Directory -Path $d -Force | Out-Null
    'a' | Set-Content (Join-Path $d 'um.txt')
    'b' | Set-Content (Join-Path $d 'dois.txt')
    'c' | Set-Content (Join-Path $d 'log.log')
    Invoke-Alvo -Caminho $d -Resumo
    Remove-Item $d -Recurse -Force
    Afirmar-Contem "arquivos=3" $global:SAIDA
    Afirmar-Contem "extensoes=2" $global:SAIDA
}
function Teste-Json {
    $d = Join-Path ([System.IO.Path]::GetTempPath()) ("inv_" + [guid]::NewGuid().ToString('N').Substring(0,6))
    New-Item -ItemType Directory -Path $d -Force | Out-Null
    'conteudo' | Set-Content (Join-Path $d 'arq.txt')
    Invoke-Alvo -Caminho $d -Formato json
    Remove-Item $d -Recurse -Force
    Afirmar-Contem "arq.txt" $global:SAIDA
    Afirmar-Contem "Extensao" $global:SAIDA
}
