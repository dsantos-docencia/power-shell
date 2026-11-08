function Teste-ImprimeOlaMundo {
    Invoke-Alvo
    Afirmar-Status 0
    Afirmar-Igual "Olá, mundo!" $global:SAIDA "a saída deve ser exatamente 'Olá, mundo!' (acento e vírgula)"
}
