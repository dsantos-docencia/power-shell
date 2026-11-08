# 🩺 Projeto 03 — Health-Check do Sistema

Roda uma bateria de verificações (disco, processos, uptime) e devolve **um objeto por verificação** com status `OK` / `ATENCAO` / `FALHA`, mais um status geral. Como são objetos e não texto ([Módulos 02](../../modulos/02-pipeline-objetos/) e [06](../../modulos/06-dados-e-objetos/)), dá para filtrar, exportar para JSON e plugar num alerta.

## Como usar

```powershell
pwsh ./health-check.ps1                    # tabela + status geral
pwsh ./health-check.ps1 -Json              # JSON p/ monitoramento
pwsh ./health-check.ps1 -LimiteDiscoPct 85 # ajusta o limite de disco
```

## Conceitos aplicados

- Padrão **"cada verificação é um `[PSCustomObject]`"** com status
- `Get-PSDrive`, `Get-Process`, agregação e "o pior status manda"
- `ConvertTo-Json -Depth` para integração com ferramentas de alerta
- Portável: usa só cmdlets multiplataforma (roda no Linux, macOS e Windows)

## Testes

```powershell
pwsh ./ferramentas/verificar-tudo.ps1
```

<sub>© 2026 Prof. Daniel Santos · Código [PolyForm NC](../../LICENSE) · Conteúdo [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md)</sub>
