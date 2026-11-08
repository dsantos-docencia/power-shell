# 🔁 Variáveis automáticas

**🌍 Idioma / Language:** **Português** · [English](variaveis-automaticas.en.md)

São variáveis que o **próprio PowerShell preenche** — você as lê, não as cria. Veja o [Módulo 03](../modulos/03-scripting-variaveis/).

## As mais usadas no dia a dia

| Variável | É |
|---|---|
| `$_` / `$PSItem` | o objeto **atual** no pipeline (dentro de `Where-Object`/`ForEach-Object`) |
| `$?` | o **último** comando teve sucesso? (`$true`/`$false`) |
| `$LASTEXITCODE` | código de saída do último **programa externo** (ex.: `git`) |
| `$Error` | array dos erros da sessão; `$Error[0]` é o mais recente |
| `$matches` | os grupos capturados pelo último `-match` |
| `$null` | o valor nulo (compare com ele à **esquerda**: `$null -eq $x`) |
| `$true` / `$false` | os booleanos |

```powershell
Get-Process | Where-Object { $_.CPU -gt 10 }   # $_ é cada processo
if ('abc123' -match '(\d+)') { $matches[1] }    # 123
Get-Item x; if (-not $?) { 'falhou' }
```

## Sobre argumentos e funções

| Variável | É |
|---|---|
| `$args` | argumentos **não nomeados** de uma função/script |
| `$PSBoundParameters` | hashtable dos parâmetros que foram passados |
| `$MyInvocation` | detalhes de como o script/função foi chamado |
| `$PSCmdlet` | o objeto cmdlet (em funções avançadas): `$PSCmdlet.ShouldProcess(...)` |
| `$input` | enumera a entrada do pipeline (uso avançado) |

## Ambiente e caminhos

| Variável | É |
|---|---|
| `$PSVersionTable` | versão, edição (`Core`=7+ / `Desktop`=5.1), plataforma |
| `$PROFILE` | caminho do seu script de perfil |
| `$PSScriptRoot` | pasta onde o **script atual** está (ótimo para caminhos relativos) |
| `$PSCommandPath` | caminho completo do script atual |
| `$HOME` | sua pasta pessoal |
| `$PWD` | diretório atual (objeto) |
| `$PID` | PID do processo do PowerShell |
| `$HOST` | o host (console) atual |
| `$env:NOME` | variável de ambiente (ex.: `$env:PATH`, `$env:USERNAME`) |

```powershell
$PSVersionTable.PSVersion              # 7.4.x
. "$PSScriptRoot/lib/helpers.ps1"      # carrega um arquivo ao lado do script
$env:PATH -split [IO.Path]::PathSeparator   # o PATH, item a item
```

## Preferências (controlam o comportamento)

| Variável | Controla |
|---|---|
| `$ErrorActionPreference` | o que fazer em erro não-terminante (`Continue`/`Stop`/`SilentlyContinue`) |
| `$VerbosePreference` | se `Write-Verbose` aparece (`SilentlyContinue`/`Continue`) |
| `$WarningPreference` | idem para `Write-Warning` |
| `$ProgressPreference` | barra de progresso (`SilentlyContinue` acelera downloads) |
| `$ConfirmPreference` | quando pedir confirmação |

```powershell
$ErrorActionPreference = 'Stop'    # no topo de scripts sérios (como o set -e do Bash)
```

> 💡 `$PSScriptRoot` é a forma **correta** de montar caminhos relativos ao script, em vez de depender do diretório atual. E `$PSVersionTable.PSEdition` diz se você está no 7+ (`Core`) ou no 5.1 (`Desktop`).

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
