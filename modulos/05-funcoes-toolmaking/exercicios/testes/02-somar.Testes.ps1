function Teste-SomaPipeline {
    # Invoke-Alvo não injeta pipeline; validamos chamando o script com entrada via stdin? 
    # Em vez disso, o script também aceita execução direta: testamos via um wrapper.
    $alvo = $global:ALVO
    $r = 10, 20, 30 | & $alvo
    Afirmar-Igual "60" ([string]$r)
}
