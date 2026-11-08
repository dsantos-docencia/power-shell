function Teste-AchaOMaior {
    Set-Content -Path pequeno.txt -Value ('a' * 10)
    Set-Content -Path grande.txt  -Value ('b' * 5000)
    Set-Content -Path medio.txt   -Value ('c' * 500)
    Invoke-Alvo -Caminho "$PWD"
    Afirmar-Igual "grande.txt" $global:SAIDA
}
