# 🧹 Projeto 02 — Limpeza de Arquivos Antigos

Remove arquivos mais velhos que *N* dias — com **rede de segurança**. Por padrão ele só **mostra** o que faria; nada some sem o `-Executar`. E como todo bom `cmdlet`, respeita `-WhatIf` e `-Confirm` ([Módulo 05](../../modulos/05-funcoes-toolmaking/)). Rodar duas vezes é seguro: é **idempotente** ([Módulo 04](../../modulos/04-controle-de-fluxo/)).

## Como usar

```powershell
pwsh ./limpeza.ps1 -Caminho ./logs -Dias 30             # simula (padrão)
pwsh ./limpeza.ps1 -Caminho ./logs -Dias 30 -Executar   # remove de verdade
pwsh ./limpeza.ps1 -Caminho ./logs -Dias 30 -WhatIf     # simulação do engine
pwsh ./limpeza.ps1 -Caminho ./logs -Dias 7 -Filtro '*.tmp' -Executar
```

## Conceitos aplicados

- `[CmdletBinding(SupportsShouldProcess)]` e `$PSCmdlet.ShouldProcess`
- Dupla trava de segurança: switch `-Executar` **e** `-WhatIf` do engine
- `Where-Object` por data, `[ValidateRange]`, idempotência
- Saída determinística (`removidos=N` / `simulados=N`) para automação

## Testes

Cobrem os três comportamentos que importam: **simular não apaga**, **executar apaga só o certo** e **rodar de novo não faz nada** (idempotência).

```powershell
pwsh ./ferramentas/verificar-tudo.ps1
```

<sub>© 2026 Prof. Daniel Santos · Código [PolyForm NC](../../LICENSE) · Conteúdo [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md)</sub>
