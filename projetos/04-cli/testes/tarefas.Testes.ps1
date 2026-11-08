# Testes do Projeto 04 — CLI de tarefas
function Novo-Arq {
    $f = Join-Path ([System.IO.Path]::GetTempPath()) ("trf_" + [guid]::NewGuid().ToString('N').Substring(0,6) + ".json")
    return $f
}
function Teste-AddLista {
    $f = Novo-Arq
    Invoke-Alvo add "Primeira" -Arquivo $f
    Afirmar-Contem "add ok id=1" $global:SAIDA
    Invoke-Alvo add "Segunda" -Arquivo $f
    Afirmar-Contem "add ok id=2" $global:SAIDA
    Invoke-Alvo listar -Arquivo $f
    Afirmar-Contem "total=2" $global:SAIDA
    Afirmar-Contem "Primeira" $global:SAIDA
    Remove-Item $f -Force
}
function Teste-Concluir {
    $f = Novo-Arq
    Invoke-Alvo add "Tarefa" -Arquivo $f | Out-Null
    Invoke-Alvo concluir 1 -Arquivo $f
    Afirmar-Contem "concluir ok id=1" $global:SAIDA
    Invoke-Alvo listar -Arquivo $f
    Afirmar-Contem "x] #1 Tarefa" $global:SAIDA
    Remove-Item $f -Force
}
function Teste-Remover {
    $f = Novo-Arq
    Invoke-Alvo add "A" -Arquivo $f | Out-Null
    Invoke-Alvo add "B" -Arquivo $f | Out-Null
    Invoke-Alvo remover 1 -Arquivo $f
    Afirmar-Contem "restam=1" $global:SAIDA
    Remove-Item $f -Force
}
function Teste-Ajuda {
    Invoke-Alvo ajuda
    Afirmar-Contem "ajuda" $global:SAIDA
}
