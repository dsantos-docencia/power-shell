# 🧭 Asking for help: discover and inspect

**🌍 Idioma / Language:** [Português](pedir-ajuda.md) · **English**

The PowerShell professional doesn't memorize cmdlets — they **discover** and **inspect**. With three cmdlets you can figure out anything on your own. See [Module 00](../modulos/00-introducao-paradigma/README.en.md).

## The three-cmdlet flow

```
Get-Command  →  Get-Help  →  Get-Member
(find)          (how to use)  (what the object has)
```

## `Get-Help` — the documentation

```powershell
Update-Help -ErrorAction SilentlyContinue   # downloads the help (do it once on a new machine)
Get-Help Get-ChildItem                      # synopsis, syntax, parameters
Get-Help Get-ChildItem -Examples            # ONLY the examples — start here
Get-Help Get-ChildItem -Full                # everything
Get-Help Get-ChildItem -Online              # opens the docs in the browser
Get-Help about_Functions                    # conceptual topics (about_*)
```

> 💡 `Get-Help <cmdlet> -Examples` is the most productive shortcut in PowerShell. And `Get-Help about_*` lists dozens of conceptual guides (`about_Operators`, `about_Splatting`, `about_Regular_Expressions`…).

## `Get-Command` — discover cmdlets

```powershell
Get-Command -Verb Get                 # everything starting with Get-
Get-Command -Noun Process             # everything dealing with Process (Get/Start/Stop...)
Get-Command *service*                 # search by approximate name
Get-Command -Module Microsoft.PowerShell.Management   # from a specific module
Get-Command Get-ChildItem -Syntax     # just the syntax, compact
Get-Verb                              # the approved verbs (Get, Set, New, Remove...)
```

> 💡 The **Verb-Noun** convention lets you *guess*: if `Get-Service` exists, then `Start-Service`, `Stop-Service`, `Restart-Service` probably do too. You deduce instead of memorizing.

## `Get-Member` — inspect the object (the most important)

```powershell
Get-Process | Get-Member               # ALL properties and methods of a process
Get-Process | Get-Member -MemberType Property   # only properties
(Get-Date)  | Get-Member -MemberType Method     # only methods
'texto'     | Get-Member                # even a string is an object, with methods
```

> 💡 **The PowerShell secret isn't memorizing cmdlets — it's inspecting objects.** Ran a cmdlet and don't know what to do with the output? Pipe it to `Get-Member`, discover the properties, use them in `Select-Object`/`Where-Object`. It solves anything.

## For builtins and topics

| Want to know… | Use |
|---|---|
| What a cmdlet does | `Get-Help <cmdlet>` |
| Ready-made examples | `Get-Help <cmdlet> -Examples` |
| Which cmdlets exist | `Get-Command` |
| What an object has | `Get-Member` |
| Concepts (operators, scope…) | `Get-Help about_<topic>` |
| A value's type | `$x.GetType().FullName` |
| A class's static methods | `[Math] \| Get-Member -Static` |

## Modern shortcuts

- `Get-Help <cmdlet> -ShowWindow` — opens the help in a searchable window (Windows).
- In **VS Code** with the PowerShell extension: autocompletion, hover help, and `Get-Member` is one `|` away.

<sub>© 2026 Prof. Daniel Santos and translators · CC BY-NC-SA 4.0</sub>
