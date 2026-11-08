function Teste-Imagem { Invoke-Alvo -Arquivo foto.jpg; Afirmar-Igual "imagem" $global:SAIDA }
function Teste-Script { Invoke-Alvo -Arquivo app.ps1;  Afirmar-Igual "script" $global:SAIDA }
function Teste-Outro  { Invoke-Alvo -Arquivo dados.xyz; Afirmar-Igual "outro" $global:SAIDA }
