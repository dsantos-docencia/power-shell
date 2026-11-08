function Teste-SomaPorVendedor {
    @'
Vendedor,Valor
Ana,100
Bia,50
Ana,250
'@ | Set-Content vendas.csv
    Invoke-Alvo -Csv (Join-Path $PWD 'vendas.csv')
    Afirmar-Igual "Ana: 350`nBia: 50" $global:SAIDA
}
