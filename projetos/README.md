# 🚀 Projetos Práticos

Aqui a teoria vira ferramenta. Cada projeto é um script **completo e funcional**, com código comentado, tratamento de erro e **testes automatizados** — exatamente como você escreveria no trabalho.

> Diferente dos exemplos (que ilustram um conceito), os projetos resolvem um problema real de ponta a ponta. Leia o código, rode, quebre, melhore.

## Os projetos

| # | Projeto | Conceitos aplicados | Módulos |
|---|---|---|---|
| 1 | [Inventário de arquivos](01-inventario/) | pipeline de objetos, `Group-Object`, CSV/JSON | 02, 06 |
| 2 | [Limpeza de arquivos antigos](02-limpeza/) | `SupportsShouldProcess`, `-WhatIf`, idempotência | 04, 05 |
| 3 | [Health-check do sistema](03-health-check/) | objeto por verificação, status geral, JSON | 02, 06 |
| 4 | [CLI profissional](04-cli/) | subcomandos, `[ValidateSet]`, persistência JSON | 05, 06 |
| 5 | [Módulo corporativo](05-modulo-corporativo/) | `.psm1`/`.psd1`, `Export-ModuleMember`, Pester | 11 |

## Como rodar e testar

Cada projeto tem seu `README.md`, o script principal e uma pasta `testes/` com testes no mini-framework do curso (os projetos 05 traz também testes **Pester**):

```powershell
# rodar um projeto
pwsh ./projetos/01-inventario/inventario.ps1 -Caminho ./alvo

# rodar todos os testes (inclui projetos e Pester)
pwsh ./ferramentas/verificar-tudo.ps1
```

Todos os projetos são **seguros para rodar**: operam em diretórios temporários ou exigem que você aponte explicitamente o alvo, nada apaga sem confirmação explícita, e nenhum acessa a rede real nos testes.

<sub>© 2026 Prof. Daniel Santos · Código [PolyForm NC](../LICENSE) · Conteúdo [CC BY-NC-SA 4.0](../LICENSE-CONTEUDO.md)</sub>
