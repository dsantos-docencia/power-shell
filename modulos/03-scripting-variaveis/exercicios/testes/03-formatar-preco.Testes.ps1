function Teste-Formato {
    Invoke-Alvo -Produto Mouse -Preco 79.9
    Afirmar-Contem "Mouse" $global:SAIDA
    Afirmar-Contem 'R$' $global:SAIDA
    # 79,90 ou 79.90 conforme a cultura — aceitamos ambos
    Afirmar-Casa 'Mouse\s+R\$\s+79[.,]90' $global:SAIDA
}
