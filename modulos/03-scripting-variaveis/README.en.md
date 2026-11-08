# Module 03 — Scripting and Variables

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Spotted a slip or have a better wording? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues) — see [traducoes/](../../traducoes/README.en.md).*

> *"Up to here you've used PowerShell. Now you start programming it."*

**Suggested load:** 6–8 h · **Level:** beginner+ · **Prerequisite:** [Module 02](../02-pipeline-objetos/README.en.md)

## 🎯 Objectives

- Create and type variables, and understand scopes
- Master PowerShell's **comparison operators** (`-eq`, `-like`, `-match`…)
- Understand the **output streams** and the famous **"Write-Host rule"**
- Interact with the user (`Read-Host`) and interpolate strings
- Learn about `$PROFILE` to customize your environment

---

## 1. Variables and types

Variables start with `$`. PowerShell is **dynamically typed**, but underneath every value is a **.NET type**.

```powershell
$nome = "Daniel"              # String
$idade = 38                   # Int32
$pi = 3.14                    # Double
$ativo = $true                # Boolean ($true / $false)
$nada = $null                 # null
$lista = @(1, 2, 3)           # array
$mapa = @{ Nome = "Ana"; Idade = 30 }   # hashtable (dictionary)
```

You can **force the type** (strong typing), which validates input:
```powershell
[int]$quantidade = 10         # only accepts integers
[datetime]$nascimento = "1986-05-20"   # converts text into a real date
$nascimento.Year              # 1986 — now it's a DateTime object, with properties
```

> 💡 Discover the type of anything: `$nome.GetType().Name` or `(Get-Item .).GetType().FullName`. Remember Module 02: every value is an object — use `Get-Member`.

### Scopes
```powershell
$global:config = "x"     # visible across the whole session
$script:contador = 0     # visible in the entire script
function f { $local:temp = 1 }   # only inside the function (default)
```

### Automatic variables (PowerShell fills them in)
| Variable | Is |
|---|---|
| `$_` / `$PSItem` | the current object in the pipeline |
| `$?` | did the last command succeed? (`$true`/`$false`) |
| `$LASTEXITCODE` | exit code of the last external program |
| `$PSVersionTable` | version details |
| `$args` | unnamed arguments |
| `$PROFILE` | path to your profile script |

---

## 2. Comparison operators

Here PowerShell diverges from almost every language: comparison does **not** use `>` `<` `==` (the `>` is redirection!). It uses operators with `-`:

| Operator | Means | Example |
|---|---|---|
| `-eq` `-ne` | equal / not equal | `$x -eq 10` |
| `-gt` `-ge` `-lt` `-le` | greater / greater-or-equal / less / less-or-equal | `$x -gt 5` |
| `-like` | wildcard (`*`, `?`) | `$nome -like 'Dan*'` |
| `-notlike` | negation of like | |
| `-match` | regular expression | `$cep -match '^\d{5}-\d{3}$'` |
| `-replace` | replace via regex | `$t -replace '\d', '#'` |
| `-in` / `-contains` | belongs to a collection | `3 -in @(1,2,3)` |
| `-and` `-or` `-not` (`!`) | logical | `$a -gt 0 -and $a -lt 10` |

> ⚠️ **Comparisons are case-insensitive by default.** `'ABC' -eq 'abc'` is `$true`. To tell upper/lowercase apart, prefix with `c`: `-ceq`, `-clike`, `-cmatch`. (There's an explicit `i` too: `-ieq`.)

> ⚠️ **`-eq` with arrays FILTERS instead of comparing.** `@(1,2,3,2) -eq 2` returns `@(2,2)` (the equal elements), not `$true`. To test membership use `-contains`/`-in`. And to compare against `$null`, put the `$null` on the **left**: `$null -eq $x` (avoids a treacherous behavior when `$x` is an array — subject of [Module 07](../07-erros-e-debugging/README.en.md)).

---

## 3. Output: the streams and the "Write-Host rule"

This is a topic that separates amateurs from professionals in PowerShell. There are **several output streams**, each with a purpose:

| Cmdlet | Stream | What for |
|---|---|---|
| `Write-Output` | **Success (1)** | **the data** — what goes down the pipeline |
| `Write-Host` | Information (6) | messages for the **human** at the console |
| `Write-Verbose` | Verbose (4) | details (only appear with `-Verbose`) |
| `Write-Warning` | Warning (3) | warnings |
| `Write-Error` | Error (2) | non-terminating errors |
| `Write-Debug` | Debug (5) | debugging (only with `-Debug`) |

### 🔴 The Write-Host rule

```powershell
function Get-Dobro($n) {
    Write-Host "Calculating..."    # ❌ does this "pollute" the data output?
    Write-Output ($n * 2)          # ✔ this is the data it returns
}
$resultado = Get-Dobro 21          # $resultado = 42 (the Write-Host does NOT land here)
```

Historically, `Write-Host` was an **anti-pattern** because it wrote straight to the screen and couldn't be captured or redirected — if you used `Write-Host` to "return" a value, it was lost. Since PowerShell 5, `Write-Host` writes to the **Information** stream (6), so it *can* be captured, but the lesson stands:

> **Use `Write-Output` (or simply emit the object) for DATA. Use `Write-Host` only for messages to the user at the console** (a menu, a textual progress bar, colors). In a function that produces data for the pipeline, `Write-Host` in the middle is almost always a design error. To "talk to the operator" without polluting the data, prefer `Write-Verbose`/`Write-Information`.

> 💡 In PowerShell, a function **returns everything it emits** — it doesn't need `Write-Output` or `return`. `$n * 2` alone on a line already goes to the pipeline. That's powerful and dangerous (accidental output) — subject of [Module 05](../05-funcoes-toolmaking/README.en.md).

---

## 4. Input and interpolation

```powershell
$nome = Read-Host "What's your name"         # asks and reads (string)
$senha = Read-Host "Password" -AsSecureString  # protected input (SecureString)

# Interpolation: inside DOUBLE QUOTES, $var is expanded:
Write-Output "Hello, $nome!"
# For expressions/properties, use $( ):
Write-Output "You have $($nome.Length) letters in your name"
Write-Output "Now: $(Get-Date -Format 'HH:mm')"

# SINGLE quotes are literal (no expansion):
Write-Output 'This prints $literal, without expanding'
```

**Format operator `-f`** (like `printf`):
```powershell
'{0,-10} {1,6:N2}' -f 'Café', 4.5        # Café         4.50
'{0:X}' -f 255                            # FF (hex)
'{0:P0}' -f 0.8                           # 80% (percentage)
```

**Here-strings** (text blocks, useful for JSON/SQL/templates):
```powershell
$texto = @"
Line 1 with $nome expanded
Line 2
"@
```

---

## 5. The `$PROFILE`

`$PROFILE` is a script that runs every time you open PowerShell — where you put aliases, functions, and personal settings.

```powershell
$PROFILE                          # shows the path to your profile
Test-Path $PROFILE                # does it exist?
New-Item -ItemType File -Path $PROFILE -Force   # create it
# edit and add, for example:  function ll { Get-ChildItem -Force }
```

---

## 🧪 Examples in this module

| File | Demonstrates |
|---|---|
| [01-variaveis-e-tipos.ps1](exemplos/01-variaveis-e-tipos.ps1) | Dynamic vs. strong typing; .NET types underneath |
| [02-streams-de-saida.ps1](exemplos/02-streams-de-saida.ps1) | `Write-Output` vs `Write-Host` and why it matters (the rule) |
| [03-operadores.ps1](exemplos/03-operadores.ps1) | `-eq`/`-like`/`-match`, case-sensitivity, and the array trap |

## ⚠️ Module pitfalls

- Using `Write-Host` to "return" data from a function (use `Write-Output`)
- Forgetting that comparisons are case-insensitive (`-ceq` when you need it)
- `$x -eq $null` instead of `$null -eq $x` (the right way is `$null` on the left)
- Interpolating a property without `$( )`: `"$obj.Nome"` comes out wrong; use `"$($obj.Nome)"`
- Using `>` thinking it compares (it's redirection!)

## 🏋️ Exercises

See [exercicios/README.en.md](exercicios/README.en.md). Grade with `./ferramentas/corrigir.ps1 03`.

## ✅ Mastery checklist

- [ ] I type variables with `[int]`/`[datetime]` and can see the type with `Get-Member`
- [ ] I use the `-eq`/`-like`/`-match` operators correctly
- [ ] I can explain the Write-Host rule and use `Write-Output` for data
- [ ] I interpolate with `$( )` and format with `-f`
- [ ] I know what the `$PROFILE` is

---

⬅️ [Module 02](../02-pipeline-objetos/README.en.md) · ➡️ [Module 04 — Control Flow](../04-controle-de-fluxo/README.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · Text under [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Code under [PolyForm NC](../../LICENSE)</sub>
