function Teste-Soma {
    @'
Produto,Valor
A,100
B,250
C,50
'@ | Set-Content dados.csv
    Invoke-Alvo -Csv (Join-Path $PWD 'dados.csv')
    Afirmar-Igual "400" $global:SAIDA
}
