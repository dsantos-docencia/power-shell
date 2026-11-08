# Testes do Projeto 03 — Health-Check
function Teste-StatusGeral {
    Invoke-Alvo
    Afirmar-Contem "geral=" $global:SAIDA
    Afirmar-Contem "Disco" $global:SAIDA
    Afirmar-Contem "Processos" $global:SAIDA
}
function Teste-DiscoAtencao {
    Invoke-Alvo -LimiteDiscoPct 1       # limite ridículo -> disco vira ATENCAO
    Afirmar-Contem "geral=ATENCAO" $global:SAIDA
}
function Teste-Json {
    Invoke-Alvo -Json
    Afirmar-Contem '"StatusGeral"' $global:SAIDA
    Afirmar-Contem '"Verificacoes"' $global:SAIDA
}
