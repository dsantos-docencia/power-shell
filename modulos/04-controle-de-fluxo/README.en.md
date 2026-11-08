# Module 04 — Control Flow

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Spotted a slip or have a better wording? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues) — see [traducoes/](../../traducoes/README.en.md).*

> *"Decide and repeat. And one choice that changes your scripts' performance: `foreach` or `ForEach-Object`?"*

**Suggested load:** 8–10 h · **Level:** intermediate · **Prerequisite:** [Module 03](../03-scripting-variaveis/README.en.md)

## 🎯 Objectives

- Make decisions with `if`/`elseif`/`else` and PowerShell's **supercharged `switch`**
- Repeat with `for`, `foreach`, `while`, `do-while`/`do-until`
- Understand the **crucial** difference between `foreach` (statement) and `ForEach-Object` (pipeline)
- Control loops with `break`, `continue`, `return`
- Use the ternary operator (PowerShell 7+)

---

## 1. Conditionals

```powershell
if ($idade -ge 18) {
    "adult"
} elseif ($idade -ge 12) {
    "teenager"
} else {
    "child"
}
```

The condition **must** be between parentheses `( )` and the block between braces `{ }`.

**Ternary operator** (PowerShell 7+):
```powershell
$status = $idade -ge 18 ? "adult" : "minor"
```

---

## 2. The supercharged `switch`

PowerShell's `switch` is far more powerful than other languages'.

```powershell
switch ($valor) {
    1 { "one" }
    2 { "two" }
    default { "other" }
}
```

**Important differences:**

```powershell
# -Wildcard: compares with wildcards
switch -Wildcard ($arquivo) {
    '*.jpg' { "image" }
    '*.log' { "log" }
}

# -Regex: compares with regular expressions (and $matches becomes available)
switch -Regex ($texto) {
    '^\d+$'     { "numbers only" }
    '[A-Z]'     { "has an uppercase" }
}

# WITHOUT break, it tests ALL patterns (can match several!):
switch ('abc123') {
    { $_ -match '[a-z]' } { "has a letter" }
    { $_ -match '\d' }    { "has a number" }
    # prints BOTH, because there's no automatic break
}
```

> 💡 The `switch` accepts **condition blocks** `{ $_ -match ... }`, accepts arrays (tests each element), and accepts `-File` to process a file line by line. It's almost a language within the language. By default there is **no `break`** — add `break` if you want to stop at the first match.

---

## 3. Loops

### `for` — classic counter
```powershell
for ($i = 0; $i -lt 5; $i++) {
    Write-Output "i = $i"
}
```

### `foreach` (statement) — iterates a collection
```powershell
foreach ($fruta in @('apple', 'banana', 'grape')) {
    Write-Output $fruta
}
```

### `while` and `do`
```powershell
$i = 0
while ($i -lt 3) { $i++ }

do { $i-- } while ($i -gt 0)      # runs at least once
do { $i++ } until ($i -ge 3)      # repeats UNTIL the condition becomes true
```

### `break`, `continue`, `return`
```powershell
foreach ($n in 1..10) {
    if ($n -eq 5) { continue }    # skips 5
    if ($n -eq 8) { break }       # stops at 8
    Write-Output $n
}
```
> 💡 `1..10` is the **range operator**: it generates the sequence from 1 to 10. `10..1` counts backwards.

---

## 4. `foreach` vs. `ForEach-Object` — the difference that matters

There are **two** "foreach" in PowerShell, and mixing them up costs performance:

| | `foreach ($x in $col) { }` | `$col | ForEach-Object { }` |
|---|---|---|
| What it is | language **statement** | pipeline **cmdlet** (alias `%`) |
| How it processes | loads the **whole** collection into memory, then iterates | processes **one object at a time** (streaming) |
| Item variable | the name you gave (`$x`) | `$_` / `$PSItem` |
| Faster for | collections already in memory, known size | **pipelines**, large volumes, data arriving gradually |
| Blocks | — | `-Begin`, `-Process`, `-End` |

```powershell
# foreach statement: fast when the data is already in a variable
$arquivos = Get-ChildItem
foreach ($a in $arquivos) { $a.Name }

# ForEach-Object: ideal in a pipeline, processes as it receives
Get-ChildItem | ForEach-Object { $_.Name }
```

> 💡 **Rule of thumb:** if the data is **already in a variable** and you know it fits in memory, `foreach` (statement) is usually faster. If you're **in the middle of a pipeline** or processing a **large/continuous volume** (a huge log, output from a remote command), `ForEach-Object` streams and doesn't blow up memory. Measuring with `Measure-Command` settles it (see example 03).

> 💡 **"Pipeline first":** think pipeline before thinking loop. Instead of a `for` to filter files, prefer `Get-ChildItem | Where-Object ... | ForEach-Object ...`. It's more readable and idiomatic.

---

## 🧪 Examples in this module

| File | Demonstrates |
|---|---|
| [01-if-switch.ps1](exemplos/01-if-switch.ps1) | `if`/`elseif`, ternary, and the `switch` with `-Wildcard`/`-Regex` |
| [02-loops.ps1](exemplos/02-loops.ps1) | `for`, `foreach`, `while`, `do-until`, `break`/`continue`, `1..10` |
| [03-foreach-vs-foreachobject.ps1](exemplos/03-foreach-vs-foreachobject.ps1) | The difference and a measurement with `Measure-Command` |

## ⚠️ Module pitfalls

- Forgetting that `switch` has **no** automatic `break` (matches several patterns)
- Confusing `foreach` (statement) with `ForEach-Object` (pipeline) and losing performance
- Using `$_` inside a `foreach` statement (there the variable is the one you named)
- Using a loop where a `Where-Object`/`ForEach-Object` would be clearer

## 🏋️ Exercises

See [exercicios/README.en.md](exercicios/README.en.md). Grade with `./ferramentas/corrigir.ps1 04`.

## ✅ Mastery checklist

- [ ] I use `if`/`elseif`/`else` and the ternary `? :`
- [ ] I explore the `switch` with `-Wildcard`/`-Regex` and know there's no automatic break
- [ ] I write `for`/`foreach`/`while`/`do` and use `1..N`
- [ ] I can explain `foreach` vs `ForEach-Object` and choose by the situation
- [ ] I think "pipeline first"

---

⬅️ [Module 03](../03-scripting-variaveis/README.en.md) · ➡️ [Module 05 — Functions and Toolmaking](../05-funcoes-toolmaking/README.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · Text under [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Code under [PolyForm NC](../../LICENSE)</sub>
