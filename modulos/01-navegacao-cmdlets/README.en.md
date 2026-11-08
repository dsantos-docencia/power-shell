# Module 01 — Navigation and Cmdlets

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Spotted a slip or have a better wording? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues) — see [traducoes/](../../traducoes/README.en.md).*

> *"In PowerShell you don't memorize commands: you guess them. The Verb-Noun convention is a superpower."*

**Suggested load:** 5–7 h · **Level:** beginner · **Prerequisite:** [Module 00](../00-introducao-paradigma/README.en.md)

## 🎯 Objectives

- Understand the **Verb-Noun** syntax and use it to **deduce** cmdlets
- Discover commands with `Get-Command` and learn with `Get-Help -Examples`
- Navigate and manipulate files with cmdlets (`Get-ChildItem`, `Copy-Item`…)
- Understand **Providers and PSDrives**: treating the Registry, environment variables, and certificates as "folders"
- Know what **aliases** are and why **not** to use them in scripts

---

## 1. The sacred syntax: Verb-Noun

Every PowerShell cmdlet has the form **`Verb-Noun`**, always singular:

```
Get-Process     Set-Location     New-Item     Remove-Item     Stop-Service
└┬┘ └──┬──┘
verb   noun
```

This isn't aesthetics — it's **predictability**. The verbs are standardized (there's an official list, see `Get-Verb`). So if you know the noun, you **guess** the operations:

| If this exists… | then probably so does… |
|---|---|
| `Get-Service` | `Start-Service`, `Stop-Service`, `Restart-Service` |
| `Get-Item` | `New-Item`, `Remove-Item`, `Copy-Item`, `Rename-Item` |
| `Get-Content` | `Set-Content`, `Add-Content`, `Clear-Content` |

**The most common verbs:**

| Verb | Means | Example |
|---|---|---|
| `Get` | obtain/read | `Get-ChildItem` |
| `Set` | change/define | `Set-Content` |
| `New` | create | `New-Item` |
| `Remove` | delete | `Remove-Item` |
| `Start` / `Stop` | start / stop | `Start-Service` |
| `Invoke` | execute/trigger | `Invoke-Command` |

> 💡 `Get-Verb` lists all approved verbs, grouped by type (Common, Data, Lifecycle…). Using a verb outside the list triggers a PSScriptAnalyzer warning — it's part of writing "idiomatic" code.

---

## 2. Discovering commands

You're never stuck: PowerShell is **self-documenting**.

```powershell
Get-Command -Verb Get -Noun *Item*     # all the Get-*Item*
Get-Command -Noun Process              # everything that deals with processes
Get-Command *network*                  # search by approximate name
Get-Help Get-ChildItem -Examples       # learn by example (the best shortcut)
Get-Alias ls                           # ls is an alias of what?
```

> 💡 The professional's discovery flow: **`Get-Command`** (find the cmdlet) → **`Get-Help -Examples`** (see how it's used) → run it → **`Get-Member`** (inspect what came back, Module 02).

---

## 3. Navigation and files

The navigation cmdlets have aliases that recall Unix/CMD, but in scripts we use the full names:

| Cmdlet | Aliases | Does |
|---|---|---|
| `Get-Location` | `pwd`, `gl` | where am I |
| `Set-Location` | `cd`, `sl` | change directory |
| `Get-ChildItem` | `ls`, `dir`, `gci` | list contents |
| `New-Item` | `ni` | create file/folder |
| `Copy-Item` | `cp`, `copy` | copy |
| `Move-Item` | `mv`, `move` | move/rename |
| `Remove-Item` | `rm`, `del` | delete |
| `Get-Content` | `cat`, `gc`, `type` | read contents |

```powershell
Get-ChildItem -Path . -Recurse -Filter *.log    # all .log recursively
New-Item -ItemType Directory -Path projeto/src -Force   # creates the folder chain
New-Item -ItemType File -Path projeto/README.md
Copy-Item -Path origem.txt -Destination backup.txt
Remove-Item -Path *.tmp                         # deletes (see the warning below)
```

> 🔥 **Beware `Remove-Item -Recurse -Force`.** Like Bash's `rm -rf`, it deletes with no recycle bin. PowerShell's big advantage: **`-WhatIf`** simulates without executing:
> ```powershell
> Remove-Item -Path C:\dados\* -Recurse -WhatIf    # only SHOWS what it would delete
> ```
> Build the habit of running with `-WhatIf` first. It's the safety net Bash doesn't have natively (subject of [Module 05](../05-funcoes-toolmaking/README.en.md)).

> ⚠️ **`-Filter` is faster than `-Include`.** `-Filter` is applied by the provider (on the "factory floor"); `Where-Object { $_.Name -like ... }` filters after fetching everything. Filtering early = faster (performance subject in [Module 09](../09-remoting-e-paralelismo/README.en.md)).

---

## 4. Providers and PSDrives: everything is a "drive"

Here's something Bash doesn't have. In PowerShell, **not only the disk** is navigable like folders — the Windows Registry, environment variables, certificates, even functions are exposed as **drives** through **providers**.

```powershell
Get-PSDrive                 # lists every "drive": C:, Env:, Function:, Alias:...
Get-ChildItem Env:          # the environment variables, as if they were files!
Get-Content Env:PATH        # the value of a variable
Set-Location Env:           # "enter" the environment variables
```

On **Windows**, you can literally browse the Registry:
```powershell
Set-Location HKLM:\SOFTWARE          # enters the Registry as if it were a folder
Get-ChildItem Cert:\CurrentUser\My   # the installed certificates
```

> 💡 This is the beauty of the object model: the same `Get-ChildItem` works on disk, in the Registry, in environment variables — because they're all exposed through the same "provider" interface. One concept, many uses.

| Provider / Drive | What it exposes | Cross-platform? |
|---|---|---|
| `C:`, `/` | the file system | yes |
| `Env:` | environment variables | yes |
| `Alias:` | the defined aliases | yes |
| `Function:` | the loaded functions | yes |
| `HKLM:`, `HKCU:` | Windows Registry | Windows only |
| `Cert:` | certificates | Windows only |

---

## 5. Aliases: handy in the console, forbidden in scripts

Aliases like `ls`, `cd`, `cat` exist to **make life easier for people coming from Unix/CMD** and for fast typing in the interactive console.

```powershell
ls          # = Get-ChildItem
cd ..       # = Set-Location ..
cat arq     # = Get-Content arq
gci | ? Length -gt 1kb | % Name    # ? = Where-Object, % = ForEach-Object
```

> ⚠️ **Never use aliases in scripts.** Three reasons: (1) aliases can be **redefined** (someone could do `Set-Alias ls Get-Process`!); (2) some don't exist on every platform (`ls` on Linux is the system's `ls`, not the alias); (3) readability — `Get-ChildItem | Where-Object Length -gt 1kb` reads clearly; `gci | ? Length -gt 1kb` doesn't. PSScriptAnalyzer warns (rule `PSAvoidUsingCmdletAliases`).

---

## 🧪 Examples in this module

| File | Demonstrates |
|---|---|
| [01-verbo-substantivo.ps1](exemplos/01-verbo-substantivo.ps1) | Deducing cmdlets from the convention; `Get-Verb`, `Get-Command` |
| [02-navegacao-arquivos.ps1](exemplos/02-navegacao-arquivos.ps1) | Create, list, copy, move, and remove (with `-WhatIf`) in a lab |
| [03-providers.ps1](exemplos/03-providers.ps1) | `Get-PSDrive` and browsing `Env:` as if it were a folder |

## ⚠️ Module pitfalls

- Using aliases (`ls`, `gci`, `?`, `%`) in scripts
- Forgetting `-WhatIf` before a `Remove-Item -Recurse`
- Filtering with `Where-Object` when `-Filter` would be much faster
- Trying to browse `HKLM:`/`Cert:` on Linux (they're Windows-only providers)

## 🏋️ Exercises

See [exercicios/README.en.md](exercicios/README.en.md). Grade with `./ferramentas/corrigir.ps1 01`.

## ✅ Mastery checklist

- [ ] I deduce cmdlets from the Verb-Noun convention
- [ ] I use `Get-Command` and `Get-Help -Examples` to figure things out on my own
- [ ] I manipulate files with the `*-Item` cmdlets and use `-WhatIf`
- [ ] I understand that `Env:` and the Registry are navigable "drives"
- [ ] I know why aliases don't belong in scripts

---

⬅️ [Module 00](../00-introducao-paradigma/README.en.md) · ➡️ [Module 02 — The Object Pipeline](../02-pipeline-objetos/README.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · Text under [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Code under [PolyForm NC](../../LICENSE)</sub>
