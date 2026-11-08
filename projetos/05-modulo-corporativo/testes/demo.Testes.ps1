# Teste do framework do curso — Projeto 05 (demo do módulo)
function Teste-Demo {
    Invoke-Alvo
    Afirmar-Contem "tamanho=1.0 MB" $global:SAIDA
    Afirmar-Contem "valido=True" $global:SAIDA
    Afirmar-Contem "invalido=False" $global:SAIDA
    Afirmar-Contem "id_ok=True" $global:SAIDA
}
