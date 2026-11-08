function Teste-Pester { Invoke-Alvo -Modulo "Pester" -Comando "Invoke-Pester"; Afirmar-Igual 'Pester\Invoke-Pester' $global:SAIDA }
function Teste-Simples { Invoke-Alvo -Modulo "Utils" -Comando "Get-Foo"; Afirmar-Igual 'Utils\Get-Foo' $global:SAIDA }
