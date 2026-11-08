# ⌨️ Projeto 04 — CLI Profissional

Um gerenciador de tarefas de linha de comando com **subcomandos** (`add`, `listar`, `concluir`, `remover`, `ajuda`) sobre um arquivo JSON. É o que separa um "scriptzinho" de uma ferramenta de verdade: `[ValidateSet]`, ajuda embutida, persistência e saída colorida ([Módulos 05](../../modulos/05-funcoes-toolmaking/) e [06](../../modulos/06-dados-e-objetos/)).

## Como usar

```powershell
pwsh ./tarefas.ps1 add "Comprar café" -Arquivo t.json
pwsh ./tarefas.ps1 listar -Arquivo t.json
pwsh ./tarefas.ps1 concluir 1 -Arquivo t.json
pwsh ./tarefas.ps1 remover 1 -Arquivo t.json
pwsh ./tarefas.ps1 ajuda
```

## Conceitos aplicados

- Subcomando posicional validado com `[ValidateSet]`
- Persistência em JSON (`ConvertTo-Json`/`ConvertFrom-Json`) e IDs incrementais
- Ajuda embutida e feedback colorido com `Write-Host`
- Saída de status estável (`add ok id=1`, `total=2`) para automação

## Testes

Exercitam o ciclo de vida inteiro: adicionar, listar, concluir e remover.

```powershell
pwsh ./ferramentas/verificar-tudo.ps1
```

<sub>© 2026 Prof. Daniel Santos · Código [PolyForm NC](../../LICENSE) · Conteúdo [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md)</sub>
