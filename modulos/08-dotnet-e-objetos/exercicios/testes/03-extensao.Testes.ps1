function Teste-Jpg { Invoke-Alvo -Caminho "/a/FOTO.JPG"; Afirmar-Igual "jpg" $global:SAIDA }
function Teste-Md  { Invoke-Alvo -Caminho "readme.MD";   Afirmar-Igual "md" $global:SAIDA }
