# 🏋️ Exercises — Module 08

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*
>
> ⚠️ **The expected outputs below are kept in Portuguese on purpose** — the grader checks them literally.

Grade with `./ferramentas/corrigir.ps1 08`. Solutions in [solucoes/](solucoes/).

### 01 — Hypotenuse with .NET · `01-hipotenusa.ps1`
Receives `[double]$A` and `[double]$B` (legs) and prints the hypotenuse rounded to 2 decimals, using `[Math]::Sqrt` and `[Math]::Round`.
```
PS> pwsh ./01-hipotenusa.ps1 -A 3 -B 4   # -> 5
```

### 02 — Rectangle class · `02-retangulo.ps1`
Define a `class Retangulo` with properties `[double]$Largura` and `[double]$Altura`, a constructor, and a method `[double] Area()`. Receive `[double]$L` and `[double]$H`, create the object, and print the area.
```
PS> pwsh ./02-retangulo.ps1 -L 4 -H 5   # -> 20
```

### 03 — File extension · `03-extensao.ps1`
Receives a path in `$Caminho` and prints the extension **without the dot**, in lowercase, using `[System.IO.Path]::GetExtension`. E.g.: `/a/FOTO.JPG` → `jpg`.

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
