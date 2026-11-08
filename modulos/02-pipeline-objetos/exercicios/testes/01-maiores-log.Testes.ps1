function Teste-OrdenaLogs {
    Set-Content a.log -Value ('x' * 100)
    Set-Content b.log -Value ('x' * 5000)
    Set-Content c.txt -Value ('x' * 9000)   # não é .log, deve ser ignorado
    Invoke-Alvo -Caminho "$PWD"
    Afirmar-Igual "b.log`na.log" $global:SAIDA
    Afirmar-NaoContem "c.txt" $global:SAIDA
}
