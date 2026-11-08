# ⌨️ Project 04 — Professional CLI

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*

A command-line task manager with **subcommands** (`add`, `listar`, `concluir`, `remover`, `ajuda`) over a JSON file. It's what separates "a little script" from a real tool: `[ValidateSet]`, built-in help, persistence, and colored output ([Modules 05](../../modulos/05-funcoes-toolmaking/README.en.md) and [06](../../modulos/06-dados-e-objetos/README.en.md)). (The subcommand names are in Portuguese — `listar`=list, `concluir`=complete, `remover`=remove, `ajuda`=help — and are checked by the tests.)

## How to use

```powershell
pwsh ./tarefas.ps1 add "Comprar café" -Arquivo t.json
pwsh ./tarefas.ps1 listar -Arquivo t.json
pwsh ./tarefas.ps1 concluir 1 -Arquivo t.json
pwsh ./tarefas.ps1 remover 1 -Arquivo t.json
pwsh ./tarefas.ps1 ajuda
```

## Concepts applied

- Positional subcommand validated with `[ValidateSet]`
- JSON persistence (`ConvertTo-Json`/`ConvertFrom-Json`) and incremental IDs
- Built-in help and colored feedback with `Write-Host`
- Stable status output (`add ok id=1`, `total=2`) for automation

## Tests

They exercise the whole lifecycle: add, list, complete, and remove.

```powershell
pwsh ./ferramentas/verificar-tudo.ps1
```

<sub>© 2026 Prof. Daniel Santos and translators · Code [PolyForm NC](../../LICENSE) · Content [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md)</sub>
