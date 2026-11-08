# Module 06 — Data and Objects

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Spotted a slip or have a better wording? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues) — see [traducoes/](../../traducoes/README.en.md).*

> *"The foundation of any modern PowerShell report is the `[PSCustomObject]`. Mastering collections and objects is mastering data."*

**Suggested load:** 8–10 h · **Level:** intermediate+ · **Prerequisite:** [Module 05](../05-funcoes-toolmaking/README.en.md)

## 🎯 Objectives

- Work with **arrays** and **hashtables** (dictionaries) — and avoid the `+=` trap
- Create structured objects with **`[PSCustomObject]`**
- Manipulate strings with .NET methods and operators (`-split`, `-join`, `-replace`, `-f`)
- Convert to/from **JSON, CSV, and XML**

---

## 1. Arrays

```powershell
$arr = @(1, 2, 3)              # array
$arr = 1, 2, 3                 # the same (the comma creates an array)
$arr[0]                        # first (index starts at 0)
$arr[-1]                       # last
$arr[1..2]                     # slice (indices 1 and 2)
$arr.Count                     # count
$arr += 4                      # "appends"... see the trap below
```

> ⚠️ **The `+=` trap in loops (O(n²)).** Arrays in PowerShell have a **fixed size**. `$arr += $x` does **not** append: it creates a **new** array, copies everything, and adds the item. In a big loop, that gets quadratically slow (it copies a growing array n times). To accumulate in loops, use a **list** `[System.Collections.Generic.List[T]]`:
> ```powershell
> $lista = [System.Collections.Generic.List[int]]::new()
> foreach ($n in 1..100000) { $lista.Add($n) }   # fast: adds in place
> ```
> Or **collect through the pipeline** (idiomatic): `$resultado = 1..100000 | ForEach-Object { $_ * 2 }`. `Measure-Command` lays the difference bare (see example 01).

## 2. Hashtables (dictionaries)

Key→value pairs, with instant access by the key.

```powershell
$pessoa = @{ Nome = 'Ana'; Idade = 30 }
$pessoa['Nome']               # Ana
$pessoa.Idade                 # 30 (dot access works too)
$pessoa['Email'] = 'a@x.com'  # add/update
$pessoa.Keys                  # the keys
$pessoa.ContainsKey('Nome')   # $true
```

> 💡 Hashtables are great for **counting** (histograms), **mapping** (from→to), and **configuring**. Unlike arrays, adding to a hashtable is cheap. To keep insertion **order**, use `[ordered]@{ ... }`.

## 3. `[PSCustomObject]` — the star of reports

Creates an object with named properties. That's how you produce structured data "from scratch" — the foundation of every report and every function that returns objects (Module 05).

```powershell
$usuario = [pscustomobject]@{
    Nome   = 'Daniel'
    Papel  = 'admin'
    Ativo  = $true
}
$usuario.Nome                 # Daniel
$usuario | Get-Member         # it's a real object, inspectable

# A COLLECTION of PSCustomObject becomes a "table" ready for pipeline/export:
$relatorio = @(
    [pscustomobject]@{ Servico = 'web';   Status = 'ok'      }
    [pscustomobject]@{ Servico = 'db';    Status = 'stopped' }
)
$relatorio | Where-Object Status -eq 'stopped'    # filters like any object
$relatorio | Export-Csv relatorio.csv -NoTypeInformation
```

> 💡 Why not a hashtable? Because `[PSCustomObject]` flows through the pipeline as an object with real properties — `Select-Object`, `Where-Object`, `Sort-Object`, `Export-Csv`, and `Format-Table` work perfectly. A hashtable is for lookup; PSCustomObject is for **tabular data**.

## 4. String manipulation

Strings are .NET objects — they have methods — and PowerShell adds operators on top.

```powershell
$t = '  Daniel Santos  '
$t.Trim()                     # 'Daniel Santos' (strips edge spaces)
$t.ToUpper()                  # '  DANIEL SANTOS  '
$t.Replace('Santos', 'Silva') # .NET method
'a,b,c'.Split(',')            # array @('a','b','c') — .NET method
```

PowerShell operators (more powerful, with regex):
```powershell
'a,b,c' -split ','            # splits (accepts regex)
@('a','b','c') -join '-'      # 'a-b-c'
'teste123' -replace '\d', '#' # 'teste###' (regex)
'{0} is {1} years old' -f 'Ana', 30   # formatting
```

| Operator | Does | vs. method |
|---|---|---|
| `-split` | splits (regex) | `.Split()` is literal, simpler |
| `-join` | joins a collection | — |
| `-replace` | replaces (regex) | `.Replace()` is literal |
| `-f` | formats | — |

## 5. JSON, CSV, and XML

The object nature makes conversion trivial.

```powershell
# JSON (great for APIs and config)
$obj | ConvertTo-Json -Depth 5
'{ "nome": "Ana", "idade": 30 }' | ConvertFrom-Json    # becomes a navigable object

# CSV (spreadsheets, other systems)
$dados | Export-Csv -Path saida.csv -NoTypeInformation
$lidos = Import-Csv -Path saida.csv                     # becomes a collection of objects

# XML
[xml]$doc = '<raiz><item>1</item><item>2</item></raiz>'
$doc.raiz.item                                          # navigates like an object
```

> 💡 `ConvertFrom-Json` and `Import-Csv` return **objects** — you immediately start filtering with `Where-Object` and selecting with `Select-Object`. It's the PowerShell cycle: bring data in from any format → turn it into objects → manipulate in the pipeline.

---

## 🧪 Examples in this module

| File | Demonstrates |
|---|---|
| [01-colecoes.ps1](exemplos/01-colecoes.ps1) | Arrays, the `+=` trap vs `List[T]`, hashtables |
| [02-pscustomobject.ps1](exemplos/02-pscustomobject.ps1) | Building objects and tabular reports |
| [03-strings-e-formatos.ps1](exemplos/03-strings-e-formatos.ps1) | `-split`/`-join`/`-replace`/`-f` and JSON/CSV |

## ⚠️ Module pitfalls

- `$arr += $x` inside a big loop (O(n²)) — use `List[T]` or collect in the pipeline
- Using a hashtable where `[PSCustomObject]` (tabular data) would be right
- Confusing `-split`/`-replace` (regex) with `.Split()`/`.Replace()` (literal)
- `ConvertTo-Json` without enough `-Depth` (cuts nested objects; default is 2)

## 🏋️ Exercises

See [exercicios/README.en.md](exercicios/README.en.md). Grade with `./ferramentas/corrigir.ps1 06`.

## ✅ Mastery checklist

- [ ] I know why `+=` on an array is slow and I use `List[T]` or the pipeline
- [ ] I use hashtables for lookup and `[PSCustomObject]` for tabular data
- [ ] I manipulate strings with `-split`/`-join`/`-replace`/`-f`
- [ ] I convert to/from JSON and CSV and immediately manipulate as objects

---

⬅️ [Module 05](../05-funcoes-toolmaking/README.en.md) · ➡️ [Module 07 — Errors and Debugging](../07-erros-e-debugging/README.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · Text under [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Code under [PolyForm NC](../../LICENSE)</sub>
