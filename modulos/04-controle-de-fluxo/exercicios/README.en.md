# 🏋️ Exercises — Module 04

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*
>
> ⚠️ **The expected outputs below are kept in Portuguese on purpose** — the grader checks them literally.

Grade with `./ferramentas/corrigir.ps1 04`. Solutions in [solucoes/](solucoes/).

### 01 — FizzBuzz · `01-fizzbuzz.ps1`
Receives `[int]$N` and prints from 1 to N (one per line). Multiples of 3 → `Fizz`, of 5 → `Buzz`, of both → `FizzBuzz`.
```
PS> pwsh ./01-fizzbuzz.ps1 -N 5
1
2
Fizz
4
Buzz
```

### 02 — Classify with switch · `02-classificar-arquivo.ps1`
Receives `$Arquivo` (a name) and prints the category via `switch -Wildcard`: `*.jpg`/`*.png` → `imagem`, `*.ps1` → `script`, `*.txt`/`*.md` → `texto`, anything else → `outro`.

### 03 — Sum via pipeline · `03-somar-pipeline.ps1`
Receives `[int]$N` and prints the sum from 1 to N using `1..N | ForEach-Object` with an accumulator (don't use Gauss's formula). E.g.: `-N 10` → `55`.

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
