function Teste-TamanhoKb {
    Set-Content grande.bin -Value ('x' * 2048)   # ~2 KB
    Invoke-Alvo -Caminho "$PWD"
    Afirmar-Contem "grande.bin=" $global:SAIDA
    Afirmar-Casa 'grande\.bin=[0-9]+(\.[0-9])?' $global:SAIDA
}
