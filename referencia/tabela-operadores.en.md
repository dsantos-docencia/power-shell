# ⚙️ PowerShell operators table

**🌍 Idioma / Language:** [Português](tabela-operadores.md) · **English**

In PowerShell, comparison does **not** use `>` `<` `==` (the `>` is redirection!). It uses operators with `-`. See [Modules 03](../modulos/03-scripting-variaveis/README.en.md) and [04](../modulos/04-controle-de-fluxo/README.en.md).

## Comparison

| Operator | Means | Example → result |
|---|---|---|
| `-eq` | equal | `5 -eq 5` → `$true` |
| `-ne` | not equal | `5 -ne 3` → `$true` |
| `-gt` `-ge` | greater / greater or equal | `5 -gt 3` → `$true` |
| `-lt` `-le` | less / less or equal | `3 -lt 5` → `$true` |
| `-like` | wildcard (`*`, `?`) | `'gato' -like 'g*'` → `$true` |
| `-notlike` | negation of like | |
| `-match` | matches a regex (and fills `$matches`) | `'abc123' -match '\d+'` → `$true` |
| `-notmatch` | doesn't match the regex | |
| `-contains` | the collection contains the item | `@(1,2,3) -contains 2` → `$true` |
| `-in` | the item is in the collection | `2 -in @(1,2,3)` → `$true` |
| `-replace` | replaces via regex | `'a1b2' -replace '\d','#'` → `a#b#` |

> ⚠️ **Case-insensitive by default.** `'ABC' -eq 'abc'` is `$true`. To tell upper/lowercase apart, prefix with `c`: `-ceq`, `-clike`, `-cmatch`. There's an explicit `i` too (`-ieq`).

> ⚠️ **`-eq` with an array FILTERS instead of comparing.** `@(1,2,3,2) -eq 2` returns `@(2,2)`, not `$true`. For membership use `-contains`/`-in`. To compare against `$null`, put the `$null` on the **left**: `$null -eq $x`.

## Logical

| Operator | Means |
|---|---|
| `-and` | AND |
| `-or` | OR |
| `-not` or `!` | NOT |
| `-xor` | exclusive or |

```powershell
if ($idade -ge 18 -and $idade -lt 65) { 'adult' }
if (-not (Test-Path $arq)) { 'does not exist' }
```

## Arithmetic

| Operator | Does |
|---|---|
| `+` `-` `*` `/` | add, subtract, multiply, divide |
| `%` | remainder (modulo) |
| `[math]::Pow(b,e)` | power (there's no `**`) |
| `++` `--` | increment / decrement |

```powershell
7 % 3            # 1
[math]::Pow(2,10)   # 1024
$i++
```

## Size multipliers

PowerShell understands size suffixes directly:
```powershell
1KB     # 1024
5MB     # 5242880
2GB     # 2147483648
1TB  1PB
```

## Type and checking

| Operator | Does | |
|---|---|---|
| `-is` | is it the type? | `'x' -is [string]` → `$true` |
| `-isnot` | is it not the type? | |
| `-as` | converts to the type (or `$null`) | `'10' -as [int]` → `10` |

## Other useful ones

| Operator | Does | |
|---|---|---|
| `..` | range | `1..5` → `1 2 3 4 5` |
| `-f` | formats (like `printf`) | `'{0,-8} {1:N2}' -f 'café', 4.5` |
| `-join` | joins a collection | `@(1,2,3) -join '-'` → `1-2-3` |
| `-split` | splits (regex) | `'a,b,c' -split ','` |
| `&` | call operator | `& $nomeCmd args` |
| `.` | dot operator (runs in the current scope) | `. ./script.ps1` |

<sub>© 2026 Prof. Daniel Santos and translators · CC BY-NC-SA 4.0</sub>
