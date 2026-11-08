# 🌐 Resources: communities, documentation, and practice

**🌍 Idioma / Language:** [Português](recursos.md) · **English**

A curated, annotated list. Not everything is equal — below, what's worth your time.

## 📘 Official documentation (the source of truth)

- **[Microsoft Learn — PowerShell](https://learn.microsoft.com/powershell/)** — the official, complete, up-to-date documentation. Also available offline with `Get-Help` (run `Update-Help` first). When in doubt about behavior, this is where you check.
- **[Cmdlet reference by module](https://learn.microsoft.com/powershell/module/)** — the docs for each native cmdlet, with examples.
- **[about_ topics](https://learn.microsoft.com/powershell/scripting/learn/ps101/00-introduction)** — the conceptual guides (`about_Operators`, `about_Splatting`…), also accessible via `Get-Help about_*`.

## 🏆 The best community references

- **[PowerShell/PowerShell (GitHub)](https://github.com/PowerShell/PowerShell)** — the official repository: downloads, changelog, issues. It's the product itself, open.
- **[PowerShell Gallery](https://www.powershellgallery.com/)** — the public module repository (the "npm/PyPI" of PowerShell). See [Module 11](../modulos/11-modulos-e-distribuicao/README.en.md).
- **["Learn PowerShell in a Month of Lunches"](https://www.manning.com/books/learn-powershell-in-a-month-of-lunches-fourth-edition)** — the go-to book for learning PowerShell from scratch, by Don Jones and Jeffery Hicks.
- **[The PowerShell Best Practices and Style Guide](https://github.com/PoshCode/PowerShellPracticeAndStyle)** — style conventions maintained by the community.
- **[PowerShell.org](https://powershell.org/)** — forums, articles, and the PowerShell + DevOps Global Summit conference.

## 🔧 Tools you'll always use

- **[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)** — the official linter (PowerShell's "ShellCheck"). Flags bugs and bad practices without running. Covered in [Module 10](../modulos/10-testes-seguranca-devops/README.en.md).
- **[Pester](https://pester.dev/)** — the standard testing framework. Covered in [Module 10](../modulos/10-testes-seguranca-devops/README.en.md).
- **[Microsoft.PowerShell.PSResourceGet](https://learn.microsoft.com/powershell/module/microsoft.powershell.psresourceget/)** — the modern module for `Find`/`Install`/`Publish-PSResource` ([Module 11](../modulos/11-modulos-e-distribuicao/README.en.md)).
- **[VS Code + PowerShell extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)** — the best experience: visual debugging, autocompletion, and the analyzer as you type.

## 🏋️ To practice

- **[This course's exercises](../modulos/)** — with automatic grading via `./ferramentas/corrigir.ps1`.
- **[This course's projects](../projetos/README.en.md)** — real end-to-end automations.
- **[Exercism has no PowerShell track]**, but the [Bash track](https://exercism.org/tracks/bash) helps train shell logic with free mentoring.
- **[Microsoft Learn — PowerShell paths](https://learn.microsoft.com/training/browse/?terms=powershell)** — free interactive modules.

## 📺 Blogs and channels

- **[PowerShell Team Blog](https://devblogs.microsoft.com/powershell/)** — news straight from the people who maintain the product.
- **[r/PowerShell](https://www.reddit.com/r/PowerShell/)** — an active community, good for questions and discoveries.

---

> 💡 **How to study documentation without drowning:** don't read it all. Use `Get-Help <cmdlet> -Examples` for practical use, `Get-Command` to discover, and `Get-Member` to inspect. See [pedir-ajuda.md](pedir-ajuda.en.md).

<sub>© 2026 Prof. Daniel Santos and translators · CC BY-NC-SA 4.0</sub>
