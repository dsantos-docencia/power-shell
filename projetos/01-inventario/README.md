# 📦 Projeto 01 — Inventário de Arquivos

Varre uma pasta e transforma cada arquivo em um **objeto** (nome, extensão, tamanho, data), produzindo um relatório na tela, em **CSV** ou **JSON**. É o pipeline de objetos dos [Módulos 02](../../modulos/02-pipeline-objetos/) e [06](../../modulos/06-dados-e-objetos/) resolvendo um problema real de administração.

## Como usar

```powershell
pwsh ./inventario.ps1 -Caminho ./alvo                      # tabela + resumo
pwsh ./inventario.ps1 -Caminho ./alvo -Formato csv  -Saida relatorio.csv
pwsh ./inventario.ps1 -Caminho ./alvo -Formato json -Saida relatorio.json
pwsh ./inventario.ps1 -Caminho ./alvo -Resumo              # uma linha, p/ CI
```

## Conceitos aplicados

- `Get-ChildItem -Recurse -File` e projeção em `[PSCustomObject]`
- `Measure-Object -Sum`, `Group-Object`, `Sort-Object`
- Exportação com `Export-Csv` e `ConvertTo-Json`
- Parâmetros validados (`[ValidateSet]`), `-Resumo` como switch

## Testes

```powershell
pwsh ./ferramentas/verificar-tudo.ps1   # inclui os testes dos projetos
```

<sub>© 2026 Prof. Daniel Santos · Código [PolyForm NC](../../LICENSE) · Conteúdo [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md)</sub>
