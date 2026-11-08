# Module 07 — Error Handling and Debugging

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Spotted a slip or have a better wording? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues) — see [traducoes/](../../traducoes/README.en.md).*

> *"Resilient scripts don't break silently. They fail clearly, clean up the mess, and tell you what happened."*

**Suggested load:** 6–8 h · **Level:** intermediate+ · **Prerequisite:** [Module 06](../06-dados-e-objetos/README.en.md)

## 🎯 Objectives

- Understand **terminating errors** vs. **non-terminating errors** — the distinction that confuses everyone
- Control behavior with `$ErrorActionPreference` and `-ErrorAction`
- Intercept exceptions with `try`/`catch`/`finally` and throw with `throw`
- Navigate the error history in `$Error`
- Debug with breakpoints and `Write-Debug`

---

## 1. PowerShell's error philosophy

PowerShell has **two kinds** of error, and knowing the difference is half the battle:

| | **Non-terminating** | **Terminating** |
|---|---|---|
| What it is | a problem the cmdlet reports but **keeps going** | an error that **stops** execution |
| Example | `Get-ChildItem` didn't find 1 of 5 files | syntax error, `throw`, division by zero |
| Does `try/catch` catch it? | **no** (by default!) | **yes** |
| How to make it terminating | `-ErrorAction Stop` or `$ErrorActionPreference='Stop'` | already is |

> ⚠️ **Gotcha #1:** a `try/catch` does **not catch** non-terminating errors by default. If you do `try { Get-Item nonexistent } catch { ... }`, the `catch` **doesn't run** — the error is non-terminating. To catch it, force it to be terminating with `-ErrorAction Stop`:
> ```powershell
> try { Get-Item 'nonexistent' -ErrorAction Stop } catch { "caught: $($_.Exception.Message)" }
> ```

---

## 2. `$ErrorActionPreference` and `-ErrorAction`

They control what happens when a **non-terminating** error occurs.

```powershell
$ErrorActionPreference = 'Stop'    # GLOBAL: every non-terminating error becomes terminating
Get-Item x -ErrorAction SilentlyContinue   # LOCAL (this command only): ignore and continue
```

| Value | Effect |
|---|---|
| `Continue` | shows the error and **continues** (default) |
| `Stop` | makes it terminating (stops / falls into the `catch`) |
| `SilentlyContinue` | **suppresses** the error and continues |
| `Ignore` | ignores it and doesn't even record it in `$Error` (only as `-ErrorAction`) |
| `Inquire` | asks the user what to do |

> 💡 **Professional pattern:** at the top of serious scripts, `$ErrorActionPreference = 'Stop'` — that way an unexpected error stops the script instead of continuing in a broken state. It's the equivalent of Bash's `set -e` (Module 07 of the Bash course), but more predictable.

---

## 3. `try` / `catch` / `finally` and `throw`

```powershell
try {
    $conteudo = Get-Content 'config.json' -ErrorAction Stop
    $dados = $conteudo | ConvertFrom-Json
}
catch {
    # $_ (or $PSItem) is the ErrorRecord of the caught error
    Write-Warning "Failed to read config: $($_.Exception.Message)"
    exit 1
}
finally {
    # ALWAYS runs (success or not) — ideal for cleanup
    Write-Verbose "closing"
}
```

**`throw`** raises a terminating error (your own or by re-wrapping):
```powershell
function Test-Idade([int]$Idade) {
    if ($Idade -lt 0) { throw "Age can't be negative: $Idade" }
    $Idade
}
```

**Catch specific** exception types (multiple `catch`):
```powershell
try { ... }
catch [System.IO.FileNotFoundException] { "the file vanished" }
catch [System.UnauthorizedAccessException] { "no permission" }
catch { "any other error: $($_.Exception.Message)" }   # generic last
```

> 💡 The error object (`$_`) is rich: `$_.Exception.Message` (the message), `$_.Exception.GetType().FullName` (the type), `$_.ScriptStackTrace` (where it happened), `$_.InvocationInfo.ScriptLineNumber` (the line). Use `Get-Member` on it.

---

## 4. `$Error`: the session history

`$Error` is an automatic array with the session's errors — the most recent in `$Error[0]`.

```powershell
$Error.Count          # how many errors have occurred
$Error[0]             # the last error
$Error.Clear()        # clears the history
$?                    # did the LAST command succeed? ($true/$false)
```

---

## 5. Debugging

```powershell
# Breakpoints (pause execution to inspect):
Set-PSBreakpoint -Script meu.ps1 -Line 10            # by line
Set-PSBreakpoint -Command 'Remove-Item'               # when a command is called
Set-PSBreakpoint -Variable 'config' -Mode Write       # when a variable changes

# Debug messages (only appear with -Debug or $DebugPreference='Continue'):
Write-Debug "value of x = $x"

# Execution trace (shows each line):
Set-PSDebug -Trace 1      # turns tracing on
Set-PSDebug -Trace 0      # off
```

> 💡 In practice, the best debugging experience is in **VS Code** with the PowerShell extension: visual breakpoints (by clicking the margin), variable inspection (Watch), and the Call Stack. `Set-PSBreakpoint` is the engine behind it — good to know for debugging on servers without a GUI.

---

## 🧪 Examples in this module

| File | Demonstrates |
|---|---|
| [01-try-catch.ps1](exemplos/01-try-catch.ps1) | `try`/`catch`/`finally`, `throw`, catching specific types |
| [02-terminante-vs-nao.ps1](exemplos/02-terminante-vs-nao.ps1) | Why the `catch` sometimes doesn't fire, and how `-ErrorAction Stop` fixes it |
| [03-erro-estruturado.ps1](exemplos/03-erro-estruturado.ps1) | Inspecting the ErrorRecord and writing an error log |

## ⚠️ Module pitfalls

- Thinking `try/catch` catches non-terminating errors (it needs `-ErrorAction Stop`)
- Forgetting `finally` for cleanup (remember Bash's `trap`?)
- A generic `catch` swallowing errors without logging anything
- Using `-ErrorAction SilentlyContinue` and hiding a real problem

## 🏋️ Exercises

See [exercicios/README.en.md](exercicios/README.en.md). Grade with `./ferramentas/corrigir.ps1 07`.

## ✅ Mastery checklist

- [ ] I can explain the difference between a terminating and a non-terminating error
- [ ] I use `-ErrorAction Stop` to make an error catchable in the `catch`
- [ ] I write `try`/`catch`/`finally` and throw with `throw`
- [ ] I inspect `$_.Exception.Message` and catch specific types
- [ ] I know what `$Error`, `$?`, and `Set-PSBreakpoint` are

---

⬅️ [Module 06](../06-dados-e-objetos/README.en.md) · ➡️ [Module 08 — Objects and .NET](../08-dotnet-e-objetos/README.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · Text under [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Code under [PolyForm NC](../../LICENSE)</sub>
