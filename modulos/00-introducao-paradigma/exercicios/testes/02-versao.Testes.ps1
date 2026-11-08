function Teste-FormatoDaVersao {
    Invoke-Alvo
    $v = $PSVersionTable.PSVersion
    Afirmar-Igual "PowerShell $($v.Major).$($v.Minor)" $global:SAIDA
}
function Teste-NaoUsaTextoFixo {
    Invoke-Alvo
    Afirmar-Casa '^PowerShell [0-9]+\.[0-9]+$' $global:SAIDA "só maior.menor, lido do objeto"
}
