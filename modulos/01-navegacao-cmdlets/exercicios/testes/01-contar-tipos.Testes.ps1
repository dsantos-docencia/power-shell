function Teste-ContaCerto {
    New-Item -ItemType Directory -Path a/b/c -Force | Out-Null
    New-Item -ItemType File -Path a/x.txt, a/b/y.txt | Out-Null   # 2 arquivos, 3 diretórios
    Invoke-Alvo -Caminho "$PWD"
    Afirmar-Contem "arquivos: 2" $global:SAIDA
    Afirmar-Contem "diretorios: 3" $global:SAIDA
}
