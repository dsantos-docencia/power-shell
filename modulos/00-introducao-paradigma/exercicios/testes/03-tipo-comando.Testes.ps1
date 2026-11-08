function Teste-Cmdlet {
    Invoke-Alvo -Nome Get-ChildItem
    Afirmar-Igual "Cmdlet" $global:SAIDA
    Afirmar-Status 0
}
function Teste-Inexistente {
    Invoke-Alvo -Nome comando_que_nao_existe_xyz
    Afirmar-Igual "desconhecido" $global:SAIDA
    Afirmar-Status 1
}
