function Teste-WhatIfNaoRemove {
    Set-Content alvo.txt -Value 'x'
    & $global:ALVO -Caminho (Join-Path $PWD 'alvo.txt') -WhatIf | Out-Null
    Afirmar-Arquivo "alvo.txt" "com -WhatIf o arquivo NÃO pode ser removido"
}
function Teste-RemoveDeVerdade {
    Set-Content alvo.txt -Value 'x'
    $r = & $global:ALVO -Caminho (Join-Path $PWD 'alvo.txt')
    Afirmar-Igual "removido" ([string]$r)
    Afirmar-Igual "0" ([string](@(Get-ChildItem -Filter alvo.txt).Count))
}
