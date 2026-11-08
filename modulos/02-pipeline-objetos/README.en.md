# Module 02 — The Object Pipeline

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Spotted a slip or have a better wording? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues) — see [traducoes/](../../traducoes/README.en.md).*

> *"This is the module that transforms you. If the object pipeline makes sense, PowerShell makes sense."*

**Suggested load:** 8–10 h · **Level:** beginner+ · **Prerequisite:** [Module 01](../01-navegacao-cmdlets/README.en.md)

## 🎯 Objectives

- Understand how **objects** (not text) flow through the `|` pipeline
- Master the single most important cmdlet: **`Get-Member`**
- Filter with `Where-Object`, select with `Select-Object`, sort with `Sort-Object`
- Group and measure with `Group-Object` and `Measure-Object`
- Format the output (`Format-Table`/`Format-List`) — and the **golden rule** of `Format-*`
- Export to JSON, CSV, and XML

---

## 1. The pipeline passes objects, not text

In Bash, `command1 | command2` passes the **text** that `command1` printed. In PowerShell, `|` passes the **objects** that `command1` produced — whole, with properties and methods.

```powershell
Get-Process | Where-Object CPU -gt 10 | Sort-Object CPU -Descending | Select-Object Name, CPU
#    process        filters by the      sorts by the             picks 2
#    objects        CPU PROPERTY        CPU PROPERTY             properties
```

Each `|` hands objects to the next cmdlet, which works on the **properties** — never slicing text. That's why the system language, the screen width, or the format doesn't matter: the object is the same.

---

## 2. `Get-Member`: the most important cmdlet in PowerShell

If you can only remember **one** cmdlet, make it `Get-Member` (alias `gm`). It answers: *"what does this object have? What can I do with it?"*

```powershell
Get-Process | Get-Member
# shows ALL properties (Name, Id, CPU, WorkingSet...) and methods (Kill()...)
```

```powershell
Get-ChildItem | Get-Member -MemberType Property    # only the properties
(Get-Date) | Get-Member -MemberType Method          # only the methods
```

> 💡 **The PowerShell secret isn't memorizing cmdlets — it's inspecting objects.** Flow: run a cmdlet → pipe it to `Get-Member` → discover the properties → use them in `Select-Object`/`Where-Object`. With that you can solve anything without having to "know it by heart."

---

## 3. Filter: `Where-Object`

Keeps only the objects that pass a condition.

```powershell
# Simplified syntax (PS3+), readable for simple comparisons:
Get-ChildItem | Where-Object Length -gt 1kb

# Script-block syntax { }, for complex conditions ($_ = current object):
Get-ChildItem | Where-Object { $_.Length -gt 1kb -and $_.Extension -eq '.log' }
```

The automatic variable **`$_`** (or `$PSItem`) is "the current pipeline object." Inside the `{ }`, you access its properties with `$_.Property`.

| Operator | Means |
|---|---|
| `-eq` `-ne` | equal / not equal |
| `-gt` `-ge` `-lt` `-le` | greater / greater-or-equal / less / less-or-equal |
| `-like` | wildcard (`*`, `?`): `-like '*.log'` |
| `-match` | regular expression |
| `-in` `-contains` | belongs to a collection |

> ⚠️ Comparisons are **case-insensitive** by default. To tell upper/lowercase apart, prefix with `c`: `-ceq`, `-clike`, `-cmatch`.

---

## 4. Select: `Select-Object`

Picks **which properties** to keep, or how many objects.

```powershell
Get-Process | Select-Object Name, Id, CPU          # only those 3 properties
Get-Process | Select-Object -First 5               # the first 5
Get-Process | Select-Object -Last 3                # the last 3
Get-ChildItem | Select-Object -ExpandProperty Name # only the Name values (plain strings)
Get-Process | Select-Object -Unique                # removes duplicates
```

**Calculated properties** — create a property on the fly, with a hashtable `@{Name=...; Expression={...}}`:
```powershell
Get-ChildItem | Select-Object Name, @{Name='KB'; Expression={ [math]::Round($_.Length / 1kb, 1) }}
#                                    └ new column name       └ how to compute it (from current object $_)
```

---

## 5. Sort, group, measure

```powershell
Get-Process | Sort-Object CPU -Descending               # sorts by the property
Get-ChildItem | Sort-Object Length -Descending | Select-Object -First 3   # top 3 largest

Get-ChildItem | Group-Object Extension                   # groups by extension
# counts how many files of each extension there are

Get-ChildItem -File | Measure-Object Length -Sum -Average -Maximum
# sum, average, and max of the size — statistics out of the box
```

> 💡 `Group-Object` + `Measure-Object` replace whole reports that in Bash would need `sort | uniq -c | awk`. And the result is **objects**, ready for the next step.

---

## 6. Format: the Golden Rule

The `Format-*` cmdlets make the output pretty for a **human** — but they turn objects into formatting instructions. That's why:

> 🔴 **GOLDEN RULE: the `Format-*` are always the LAST in the line.** After a `Format-Table`, what flows through the pipe is no longer your objects — it's "formatting text." Any cmdlet after it (a `Where-Object`, an `Export-Csv`) will get lost.

```powershell
Get-Process | Sort-Object CPU -Descending | Format-Table Name, CPU   # ✔ Format-* last
Get-Process | Format-Table | Where-Object CPU -gt 10                 # ✘ NEVER — breaks
```

| Cmdlet | Shows |
|---|---|
| `Format-Table` (`ft`) | table (columns) — good for many objects with few properties |
| `Format-List` (`fl`) | list (one property per line) — good to see everything about one object |
| `Format-Wide` (`fw`) | a single property, in several columns |

---

## 7. Export and convert

Here the object model shines: because the data is structured, converting is trivial.

```powershell
Get-Process | Select-Object Name, Id, CPU | Export-Csv -Path proc.csv -NoTypeInformation
Get-Process | Select-Object Name, Id | ConvertTo-Json
Get-ChildItem | Export-Clixml -Path itens.xml      # serialization that PRESERVES the object
$dados = Import-Csv -Path proc.csv                 # reads it back as objects
```

| To… | Use |
|---|---|
| spreadsheet / another system | `Export-Csv -NoTypeInformation` |
| API / configuration | `ConvertTo-Json` / `ConvertFrom-Json` |
| save and restore the PowerShell object | `Export-Clixml` / `Import-Clixml` |
| view in a graphical window (Windows) | `Out-GridView` |

> 💡 `ConvertTo-Json` + `Invoke-RestMethod` (Module 09) is the duo for talking to REST APIs. PowerShell turns the response JSON into navigable **objects** automatically.

---

## 🧪 Examples in this module

| File | Demonstrates |
|---|---|
| [01-get-member.ps1](exemplos/01-get-member.ps1) | Inspecting objects: properties and methods — the key skill |
| [02-filtrar-selecionar-ordenar.ps1](exemplos/02-filtrar-selecionar-ordenar.ps1) | `Where/Select/Sort` + calculated property, over real files |
| [03-agrupar-e-exportar.ps1](exemplos/03-agrupar-e-exportar.ps1) | `Group-Object`, `Measure-Object`, and exporting to JSON/CSV |

## ⚠️ Module pitfalls

- Putting a cmdlet **after** a `Format-*` (the golden rule)
- Forgetting that comparisons are case-insensitive (use `-ceq` when you need it)
- Trying to slice text out of the output instead of using `Select-Object`/properties
- `Export-Csv` without `-NoTypeInformation` (generates an unwanted `#TYPE` header line — on PS7 omitting it is already the default, but confirm)

## 🏋️ Exercises

See [exercicios/README.en.md](exercicios/README.en.md). Grade with `./ferramentas/corrigir.ps1 02`.

## ✅ Mastery checklist

- [ ] I can explain why the pipeline passes objects, not text
- [ ] I use `Get-Member` to discover what an object has
- [ ] I chain `Where-Object | Sort-Object | Select-Object` naturally
- [ ] I create a calculated property with `@{Name=...; Expression={...}}`
- [ ] I know the golden rule of `Format-*` and export to JSON/CSV

---

⬅️ [Module 01](../01-navegacao-cmdlets/README.en.md) · ➡️ [Module 03 — Scripting and Variables](../03-scripting-variaveis/README.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · Text under [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Code under [PolyForm NC](../../LICENSE)</sub>
