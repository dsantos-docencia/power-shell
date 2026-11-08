# 🏋️ Exercises — Module 03

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*
>
> ⚠️ **The expected outputs below are kept in Portuguese on purpose** — the grader checks them literally.

Grade with `./ferramentas/corrigir.ps1 03`. Solutions in [solucoes/](solucoes/).

### 01 — Interpolated greeting · `01-saudacao.ps1`
Receives `$Nome` and prints exactly `Olá, NOME! (N letras)`, where N is the number of characters in the name. Use interpolation with `$( )`.
```
PS> pwsh ./01-saudacao.ps1 -Nome Ana   # -> Olá, Ana! (3 letras)
```

### 02 — Validate CEP · `02-valida-cep.ps1`
Receives `$Cep` and prints `valido` if it matches the format `00000-000`, otherwise `invalido` (exit 1). Use `-match` with the regex `^\d{5}-\d{3}$`. (`CEP` is the Brazilian postal code.)

### 03 — Format price · `03-formatar-preco.ps1`
Receives `$Produto` and `[double]$Preco` and prints, with the `-f` operator, one line: the product left-aligned in 12 columns, then `R$ ` and the price with 2 decimals. Format: `'{0,-12} R$ {1,8:N2}'`.
```
PS> pwsh ./03-formatar-preco.ps1 -Produto Mouse -Preco 79.9   # -> Mouse        R$    79,90
```

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
