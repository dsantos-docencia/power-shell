# 🧹 Project 02 — Cleanup of Old Files

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*

Removes files older than *N* days — with a **safety net**. By default it only **shows** what it would do; nothing disappears without `-Executar`. And like any good `cmdlet`, it respects `-WhatIf` and `-Confirm` ([Module 05](../../modulos/05-funcoes-toolmaking/README.en.md)). Running it twice is safe: it's **idempotent** ([Module 04](../../modulos/04-controle-de-fluxo/README.en.md)).

## How to use

```powershell
pwsh ./limpeza.ps1 -Caminho ./logs -Dias 30             # simulates (default)
pwsh ./limpeza.ps1 -Caminho ./logs -Dias 30 -Executar   # actually removes
pwsh ./limpeza.ps1 -Caminho ./logs -Dias 30 -WhatIf     # engine simulation
pwsh ./limpeza.ps1 -Caminho ./logs -Dias 7 -Filtro '*.tmp' -Executar
```
> `-Executar` means "execute"; `-Caminho` is the path, `-Dias` the days, `-Filtro` the filter.

## Concepts applied

- `[CmdletBinding(SupportsShouldProcess)]` and `$PSCmdlet.ShouldProcess`
- Double safety lock: the `-Executar` switch **and** the engine's `-WhatIf`
- `Where-Object` by date, `[ValidateRange]`, idempotency
- Deterministic output (`removidos=N` / `simulados=N`) for automation

## Tests

They cover the three behaviors that matter: **simulating doesn't delete**, **executing deletes only the right ones**, and **running again does nothing** (idempotency).

```powershell
pwsh ./ferramentas/verificar-tudo.ps1
```

<sub>© 2026 Prof. Daniel Santos and translators · Code [PolyForm NC](../../LICENSE) · Content [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md)</sub>
