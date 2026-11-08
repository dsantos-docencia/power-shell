function Teste-Interpola {
    Invoke-Alvo -Nome Ana
    Afirmar-Igual "Olá, Ana! (3 letras)" $global:SAIDA
}
function Teste-OutroNome {
    Invoke-Alvo -Nome Daniel
    Afirmar-Igual "Olá, Daniel! (6 letras)" $global:SAIDA
}
