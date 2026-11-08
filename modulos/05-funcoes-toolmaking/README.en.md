# Module 05 — Functions and Custom "Cmdlets" (Toolmaking)

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Spotted a slip or have a better wording? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues) — see [traducoes/](../../traducoes/README.en.md).*

> *"Here you stop writing scripts and start building tools. Your functions begin to behave like real cmdlets."*

**Suggested load:** 8–10 h · **Level:** intermediate+ · **Prerequisite:** [Module 04](../04-controle-de-fluxo/README.en.md)

## 🎯 Objectives

- Write functions with named, typed parameters
- Turn functions into **advanced functions** with `[CmdletBinding()]`
- Validate input with `[Parameter(Mandatory)]`, `[ValidateSet]`, `[ValidateRange]`…
- Make functions that **accept the pipeline** (`ValueFromPipeline` + `process`)
- Implement `-WhatIf`/`-Confirm` with `SupportsShouldProcess`

---

## 1. Basic functions

```powershell
function Get-Saudacao {
    param(
        [string]$Nome,
        [string]$Periodo = 'day'
    )
    "Good $Periodo, $Nome!"
}

Get-Saudacao -Nome 'Ana'                    # named parameters
Get-Saudacao -Nome 'Bia' -Periodo 'afternoon'
Get-Saudacao 'Caio' 'evening'               # positional (works, but named is clearer)
```

> 💡 **Name your functions Verb-Noun**, like the cmdlets (`Get-Saudacao`, not `Saudacao`). Use an approved verb (`Get-Verb`). That way your tool is discovered by `Get-Command` and fits into the ecosystem.

> ⚠️ **Every emitted output becomes a return value.** In PowerShell, any object the function "drops" into the pipeline is returned. `$x = 5` returns nothing, but `$x` alone on a line, or `"text"`, or a cmdlet without capturing its output — all of that goes to the return. Watch out for accidental output (assign to `$null` or `[void]` whatever shouldn't return).

---

## 2. Advanced functions: `[CmdletBinding()]`

Adding `[CmdletBinding()]` above the `param()` turns your function into an **advanced function** — it gains, for free, the common parameters (`-Verbose`, `-Debug`, `-ErrorAction`…) and starts behaving like a compiled cmdlet.

```powershell
function Get-Quadrado {
    [CmdletBinding()]
    param([int]$N)

    Write-Verbose "computing the square of $N"   # appears only with -Verbose
    $N * $N
}

Get-Quadrado -N 5 -Verbose     # now -Verbose works automatically
```

---

## 3. Parameter validation

PowerShell validates input **before** the function runs — you declare the rules as attributes. This eliminates a pile of checking `if`s.

```powershell
function New-Usuario {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]            # required; prompts if missing
        [string]$Nome,

        [ValidateSet('admin', 'editor', 'reader')] # only accepts one of these
        [string]$Papel = 'reader',

        [ValidateRange(18, 120)]                   # only in this range
        [int]$Idade,

        [ValidateNotNullOrEmpty()]                 # can't be empty
        [string]$Email,

        [ValidatePattern('^\d{5}-\d{3}$')]         # must match the regex
        [string]$Cep
    )
    "Created: $Nome ($Papel)"
}
```

| Attribute | Guarantees |
|---|---|
| `[Parameter(Mandatory=$true)]` | the parameter was provided |
| `[ValidateSet(...)]` | the value is in the allowed list |
| `[ValidateRange(min,max)]` | number within the range |
| `[ValidateNotNullOrEmpty()]` | not null and not empty |
| `[ValidatePattern('regex')]` | matches the regular expression |
| `[ValidateScript({...})]` | passes a custom test |

> 💡 `[ValidateSet(...)]` provides **Tab autocompletion** at the console. Whoever uses your function just presses Tab and sees the options. Professionalism for free.

---

## 4. Functions that accept the pipeline

This is the hallmark of a real tool: accepting objects through the pipeline, like the native cmdlets. You mark the parameter with `ValueFromPipeline` and process each item in the `process` block.

```powershell
function Get-Dobro {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [int]$Numero
    )
    begin   { $total = 0 }                  # runs ONCE, at the start
    process { $Numero * 2; $total += $Numero }  # runs FOR EACH pipeline item
    end     { Write-Verbose "processed sum=$total" }  # runs ONCE, at the end
}

1, 2, 3 | Get-Dobro         # 2, 4, 6 — processed each one
```

| Block | When it runs |
|---|---|
| `begin` | once, before the first item (initialization) |
| `process` | once **for each** pipeline object (`$_` or the parameter) |
| `end` | once, after the last item (finalization) |

> 💡 There's also `ValueFromPipelineByPropertyName` — the parameter receives the value of a same-named **property** of the object coming through the pipeline. That's how `Get-Process | Stop-Process` works: the `Id` flows by property name.

---

## 5. `-WhatIf` and `-Confirm`: simulate before acting

Remember `Remove-Item`'s `-WhatIf` (Module 01)? You can give that superpower to **your** functions with `SupportsShouldProcess`.

```powershell
function Remove-Log {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param([Parameter(Mandatory)][string]$Caminho)

    if ($PSCmdlet.ShouldProcess($Caminho, 'Remove log file')) {
        Remove-Item -Path $Caminho
    }
}

Remove-Log -Caminho app.log -WhatIf    # only shows "What if:..."; does NOT delete
Remove-Log -Caminho app.log -Confirm   # asks before deleting
Remove-Log -Caminho app.log            # deletes
```

> 💡 `$PSCmdlet.ShouldProcess(...)` returns `$false` when the user passed `-WhatIf` (or answered "no" to `-Confirm`), so the action block doesn't run. **Every function that changes state** (deletes, modifies, restarts) should implement this. It's the difference between an amateur tool and a professional one — and the safety net Bash lacks.

---

## 🧪 Examples in this module

| File | Demonstrates |
|---|---|
| [01-funcao-avancada.ps1](exemplos/01-funcao-avancada.ps1) | `[CmdletBinding()]`, `Mandatory`, `ValidateSet`, `ValidateRange` |
| [02-pipeline-input.ps1](exemplos/02-pipeline-input.ps1) | `ValueFromPipeline` + `begin/process/end` |
| [03-whatif.ps1](exemplos/03-whatif.ps1) | `SupportsShouldProcess` and `ShouldProcess()` |

## ⚠️ Module pitfalls

- Accidental output: a stray line that ends up in the function's return
- Forgetting the `process` block (without it, only the last pipeline item is processed)
- Not validating input with attributes and filling the function with `if`s
- Changing state (deleting/modifying) without implementing `SupportsShouldProcess`

## 🏋️ Exercises

See [exercicios/README.en.md](exercicios/README.en.md). Grade with `./ferramentas/corrigir.ps1 05`.

## ✅ Mastery checklist

- [ ] I write Verb-Noun functions with a typed `param()`
- [ ] I use `[CmdletBinding()]` and get `-Verbose` for free
- [ ] I validate input with `ValidateSet`/`ValidateRange`/`Mandatory`
- [ ] I make pipeline-accepting functions with `ValueFromPipeline` + `process`
- [ ] I implement `-WhatIf` with `SupportsShouldProcess`

---

⬅️ [Module 04](../04-controle-de-fluxo/README.en.md) · ➡️ [Module 06 — Data and Objects](../06-dados-e-objetos/README.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · Text under [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Code under [PolyForm NC](../../LICENSE)</sub>
