# 🏋️ Exercícios — Módulo 08

Corrija com `./ferramentas/corrigir.ps1 08`. Soluções em [solucoes/](solucoes/).

### 01 — Hipotenusa com .NET · `01-hipotenusa.ps1`
Recebe `[double]$A` e `[double]$B` (catetos) e imprime a hipotenusa arredondada a 2 casas, usando `[Math]::Sqrt` e `[Math]::Round`.
```
PS> pwsh ./01-hipotenusa.ps1 -A 3 -B 4   # -> 5
```

### 02 — Classe Retângulo · `02-retangulo.ps1`
Defina uma `class Retangulo` com propriedades `[double]$Largura` e `[double]$Altura`, um construtor e um método `[double] Area()`. Receba `[double]$L` e `[double]$H`, crie o objeto e imprima a área.
```
PS> pwsh ./02-retangulo.ps1 -L 4 -H 5   # -> 20
```

### 03 — Extensão do arquivo · `03-extensao.ps1`
Recebe um caminho em `$Caminho` e imprime a extensão **sem o ponto**, em minúsculas, usando `[System.IO.Path]::GetExtension`. Ex.: `/a/FOTO.JPG` → `jpg`.
