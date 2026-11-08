# Módulo 01 — Navegação e Cmdlets

> *"No PowerShell você não decora comandos: você os adivinha. A convenção Verbo-Substantivo é um superpoder."*

**Carga sugerida:** 5–7 h · **Nível:** iniciante · **Pré-requisito:** [Módulo 00](../00-introducao-paradigma/)

## 🎯 Objetivos

- Entender a sintaxe **Verbo-Substantivo** e usá-la para **deduzir** cmdlets
- Descobrir comandos com `Get-Command` e aprender com `Get-Help -Examples`
- Navegar e manipular arquivos com cmdlets (`Get-ChildItem`, `Copy-Item`…)
- Entender **Providers e PSDrives**: tratar o Registro, variáveis de ambiente e certificados como "pastas"
- Saber o que são **aliases** e por que **não** usá-los em scripts

---

## 1. A sintaxe sagrada: Verbo-Substantivo

Todo cmdlet do PowerShell tem o formato **`Verbo-Substantivo`**, sempre no singular:

```
Get-Process     Set-Location     New-Item     Remove-Item     Stop-Service
└┬┘ └──┬──┘
verbo  substantivo
```

Isso não é estética — é **previsibilidade**. Os verbos são padronizados (há uma lista oficial, veja `Get-Verb`). Então, se você conhece o substantivo, **adivinha** as operações:

| Se existe… | provavelmente existe… |
|---|---|
| `Get-Service` | `Start-Service`, `Stop-Service`, `Restart-Service` |
| `Get-Item` | `New-Item`, `Remove-Item`, `Copy-Item`, `Rename-Item` |
| `Get-Content` | `Set-Content`, `Add-Content`, `Clear-Content` |

**Os verbos mais comuns:**

| Verbo | Significa | Exemplo |
|---|---|---|
| `Get` | obter/ler | `Get-ChildItem` |
| `Set` | alterar/definir | `Set-Content` |
| `New` | criar | `New-Item` |
| `Remove` | apagar | `Remove-Item` |
| `Start` / `Stop` | iniciar / parar | `Start-Service` |
| `Invoke` | executar/disparar | `Invoke-Command` |

> 💡 `Get-Verb` lista todos os verbos aprovados, agrupados por tipo (Common, Data, Lifecycle…). Usar um verbo fora da lista gera aviso do PSScriptAnalyzer — é parte de escrever código "idiomático".

---

## 2. Descobrindo comandos

Você nunca está preso: o PowerShell se **autodocumenta**.

```powershell
Get-Command -Verb Get -Noun *Item*     # todos os Get-*Item*
Get-Command -Noun Process              # tudo que mexe com processos
Get-Command *network*                  # busca por nome aproximado
Get-Help Get-ChildItem -Examples       # aprenda pelo exemplo (o melhor atalho)
Get-Alias ls                           # ls é apelido de quê?
```

> 💡 Fluxo de descoberta do profissional: **`Get-Command`** (achar o cmdlet) → **`Get-Help -Examples`** (ver como se usa) → rodar → **`Get-Member`** (inspecionar o que voltou, Módulo 02).

---

## 3. Navegação e arquivos

Os cmdlets de navegação têm aliases que lembram o Unix/CMD, mas em script usamos os nomes completos:

| Cmdlet | Aliases | Faz |
|---|---|---|
| `Get-Location` | `pwd`, `gl` | onde estou |
| `Set-Location` | `cd`, `sl` | mudar de diretório |
| `Get-ChildItem` | `ls`, `dir`, `gci` | listar conteúdo |
| `New-Item` | `ni` | criar arquivo/pasta |
| `Copy-Item` | `cp`, `copy` | copiar |
| `Move-Item` | `mv`, `move` | mover/renomear |
| `Remove-Item` | `rm`, `del` | apagar |
| `Get-Content` | `cat`, `gc`, `type` | ler conteúdo |

```powershell
Get-ChildItem -Path . -Recurse -Filter *.log    # todos os .log recursivamente
New-Item -ItemType Directory -Path projeto/src -Force   # cria a cadeia de pastas
New-Item -ItemType File -Path projeto/README.md
Copy-Item -Path origem.txt -Destination backup.txt
Remove-Item -Path *.tmp                         # apaga (veja o aviso abaixo)
```

> 🔥 **Cuidado com `Remove-Item -Recurse -Force`.** Assim como o `rm -rf` do Bash, ele apaga sem lixeira. A grande vantagem do PowerShell: **`-WhatIf`** simula sem executar:
> ```powershell
> Remove-Item -Path C:\dados\* -Recurse -WhatIf    # só MOSTRA o que apagaria
> ```
> Pegue o hábito de rodar com `-WhatIf` primeiro. É a rede de segurança que o Bash não tem nativamente (tema do [Módulo 05](../05-funcoes-toolmaking/)).

> ⚠️ **`-Filter` é mais rápido que `-Include`.** O `-Filter` é aplicado pelo provider (no "chão de fábrica"); `Where-Object { $_.Name -like ... }` filtra depois de trazer tudo. Filtrar cedo = mais rápido (tema de performance no [Módulo 09](../09-remoting-e-paralelismo/)).

---

## 4. Providers e PSDrives: tudo é uma "unidade"

Aqui está algo que o Bash não tem. No PowerShell, **não só o disco** é navegável como pastas — o Registro do Windows, as variáveis de ambiente, os certificados, até funções são expostos como **drives** por meio de **providers**.

```powershell
Get-PSDrive                 # lista todos os "drives": C:, Env:, Function:, Alias:...
Get-ChildItem Env:          # as variáveis de ambiente, como se fossem arquivos!
Get-Content Env:PATH        # o valor de uma variável
Set-Location Env:           # "entrar" nas variáveis de ambiente
```

No **Windows**, você pode literalmente navegar o Registro:
```powershell
Set-Location HKLM:\SOFTWARE          # entra no Registro como se fosse uma pasta
Get-ChildItem Cert:\CurrentUser\My   # os certificados instalados
```

> 💡 Essa é a beleza do modelo de objetos: o mesmo `Get-ChildItem` funciona em disco, no Registro, nas variáveis de ambiente — porque todos são expostos pela mesma interface de "provider". Um conceito, muitos usos.

| Provider / Drive | O que expõe | Multiplataforma? |
|---|---|---|
| `C:`, `/` | sistema de arquivos | sim |
| `Env:` | variáveis de ambiente | sim |
| `Alias:` | os aliases definidos | sim |
| `Function:` | as funções carregadas | sim |
| `HKLM:`, `HKCU:` | Registro do Windows | só Windows |
| `Cert:` | certificados | só Windows |

---

## 5. Aliases: úteis no console, proibidos em scripts

Aliases como `ls`, `cd`, `cat` existem para **facilitar a vida de quem vem do Unix/CMD** e para digitar rápido no console interativo.

```powershell
ls          # = Get-ChildItem
cd ..       # = Set-Location ..
cat arq     # = Get-Content arq
gci | ? Length -gt 1kb | % Name    # ? = Where-Object, % = ForEach-Object
```

> ⚠️ **Nunca use aliases em scripts.** Três motivos: (1) aliases podem ser **redefinidos** (alguém pode fazer `Set-Alias ls Get-Process`!); (2) alguns não existem em todas as plataformas (`ls` no Linux é o `ls` do sistema, não o alias); (3) legibilidade — `Get-ChildItem | Where-Object Length -gt 1kb` se lê; `gci | ? Length -gt 1kb` não. O PSScriptAnalyzer avisa (regra `PSAvoidUsingCmdletAliases`).

---

## 🧪 Exemplos deste módulo

| Arquivo | Demonstra |
|---|---|
| [01-verbo-substantivo.ps1](exemplos/01-verbo-substantivo.ps1) | Deduzir cmdlets pela convenção; `Get-Verb`, `Get-Command` |
| [02-navegacao-arquivos.ps1](exemplos/02-navegacao-arquivos.ps1) | Criar, listar, copiar, mover e remover (com `-WhatIf`) num lab |
| [03-providers.ps1](exemplos/03-providers.ps1) | `Get-PSDrive` e navegar o `Env:` como se fosse pasta |

## ⚠️ Armadilhas do módulo

- Usar aliases (`ls`, `gci`, `?`, `%`) em scripts
- Esquecer o `-WhatIf` antes de um `Remove-Item -Recurse`
- Filtrar com `Where-Object` quando `-Filter` seria muito mais rápido
- Tentar navegar `HKLM:`/`Cert:` no Linux (são providers só do Windows)

## 🏋️ Exercícios

Veja [exercicios/README.md](exercicios/README.md). Corrija com `./ferramentas/corrigir.ps1 01`.

## ✅ Checklist de domínio

- [ ] Deduzo cmdlets pela convenção Verbo-Substantivo
- [ ] Uso `Get-Command` e `Get-Help -Examples` para me virar sozinho
- [ ] Manipulo arquivos com os cmdlets `*-Item` e uso `-WhatIf`
- [ ] Entendo que `Env:` e o Registro são "drives" navegáveis
- [ ] Sei por que aliases não entram em scripts

---

⬅️ [Módulo 00](../00-introducao-paradigma/README.md) · ➡️ [Módulo 02 — O Pipeline de Objetos](../02-pipeline-objetos/README.md)

<sub>© 2026 Prof. Daniel Santos · Texto sob [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Código sob [PolyForm NC](../../LICENSE)</sub>
