function Teste-Maior {
    Invoke-Alvo 3 9 2 7       # posicional: viram remaining args -> [int[]]$Numeros
    Afirmar-Igual "9" $global:SAIDA
}
function Teste-Dois {
    Invoke-Alvo 5 1
    Afirmar-Igual "5" $global:SAIDA
}
