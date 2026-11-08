function Teste-ResolveGci {
    Invoke-Alvo -Alias gci
    Afirmar-Igual "Get-ChildItem" $global:SAIDA
    Afirmar-Status 0
}
function Teste-NaoAlias {
    Invoke-Alvo -Alias naoexiste_zzz
    Afirmar-Igual "nao-e-alias" $global:SAIDA
    Afirmar-Status 1
}
