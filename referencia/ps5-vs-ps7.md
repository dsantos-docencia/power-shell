# 🪟 Windows PowerShell 5.1 vs. PowerShell 7+

**🌍 Idioma / Language:** **Português** · [English](ps5-vs-ps7.en.md)

A confusão nº 1 de quem começa. São **duas famílias** diferentes. Veja o [Módulo 00](../modulos/00-introducao-paradigma/).

## O essencial

| | **Windows PowerShell 5.1** | **PowerShell 7+** |
|---|---|---|
| Base | .NET Framework (só Windows) | .NET (Core) — multiplataforma |
| Onde roda | só Windows | Windows, Linux, macOS |
| Executável | `powershell.exe` | `pwsh` |
| Vem instalado? | sim, em todo Windows | não — instala-se à parte |
| `$PSVersionTable.PSEdition` | `Desktop` | `Core` |
| Futuro | **em manutenção** (sem novos recursos) | **o presente e o futuro** |

> 👉 **Aprenda e use o 7+ (`pwsh`).** O 5.1 ainda existe em servidores Windows antigos; o curso aponta as diferenças onde elas importam.

## Recursos que só existem no 7+

| Recurso | Observação |
|---|---|
| `ForEach-Object -Parallel` | paralelismo de pipeline ([Módulo 09](../modulos/09-remoting-e-paralelismo/)) |
| Operador ternário `? :` | `$x -gt 0 ? 'pos' : 'neg'` |
| Operadores `&&` e `\|\|` entre comandos | encadear por sucesso/falha, como no Bash |
| `??` e `??=` | coalescência de nulo |
| Remoting por **SSH** | multiplataforma, não só WinRM |
| `-Parallel`, `Test-Json`, `ConvertFrom-Json -AsHashtable` | melhorias diversas |

## Diferenças que pegam

| Tema | 5.1 | 7+ |
|---|---|---|
| Codificação padrão de arquivos | UTF-16/ANSI (varia) | **UTF-8 (sem BOM)** |
| `Get-WmiObject` | existe | **removido** → use `Get-CimInstance` ([Módulo 08](../modulos/08-dotnet-e-objetos/)) |
| `Invoke-WebRequest` | usa o motor do Internet Explorer | motor próprio, mais rápido |
| Módulos do Windows (AD, etc.) | nativos | via camada de **compatibilidade** (`WindowsCompatibility`) |

> ⚠️ **Codificação é a pegadinha clássica.** No 5.1, `Out-File`/`>` gravam em UTF-16 por padrão, o que quebra scripts em outros sistemas. No 7+ o padrão é UTF-8 sem BOM. Ao mover scripts entre versões, declare a codificação explicitamente: `Set-Content -Encoding utf8`.

## Rodando os dois lado a lado

Dá para ter o 5.1 e o 7+ na mesma máquina Windows — eles **coexistem**. Abra o `powershell.exe` para o 5.1 e o `pwsh.exe` para o 7+. Para descobrir onde você está:

```powershell
$PSVersionTable.PSVersion     # o número
$PSVersionTable.PSEdition     # Core (7+) ou Desktop (5.1)
```

## E no Linux/macOS?

Só existe o **7+** (`pwsh`). Não há 5.1 fora do Windows, e não há `powershell.exe`. Providers como `HKLM:` (Registro) e `Cert:` também não existem fora do Windows ([Módulo 01](../modulos/01-navegacao-cmdlets/)).

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
