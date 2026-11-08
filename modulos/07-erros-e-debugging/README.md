# Módulo 07 — Tratamento de Erros e Debugging

> *"Scripts resilientes não quebram silenciosamente. Eles falham de forma clara, limpam a bagunça e contam o que houve."*

**Carga sugerida:** 6–8 h · **Nível:** intermediário+ · **Pré-requisito:** [Módulo 06](../06-dados-e-objetos/)

## 🎯 Objetivos

- Entender **erros terminantes** vs. **não-terminantes** — a distinção que confunde todo mundo
- Controlar o comportamento com `$ErrorActionPreference` e `-ErrorAction`
- Interceptar exceções com `try`/`catch`/`finally` e lançar com `throw`
- Navegar o histórico de erros em `$Error`
- Depurar com breakpoints e `Write-Debug`

---

## 1. A filosofia de erros do PowerShell

O PowerShell tem **dois tipos** de erro, e saber a diferença é metade da batalha:

| | **Não-terminante** | **Terminante** |
|---|---|---|
| O que é | um problema que o cmdlet reporta mas **continua** | um erro que **para** a execução |
| Exemplo | `Get-ChildItem` não achou 1 de 5 arquivos | erro de sintaxe, `throw`, divisão por zero |
| `try/catch` pega? | **não** (por padrão!) | **sim** |
| Como torná-lo terminante | `-ErrorAction Stop` ou `$ErrorActionPreference='Stop'` | já é |

> ⚠️ **A pegadinha nº 1:** um `try/catch` **não pega** erros não-terminantes por padrão. Se você faz `try { Get-Item inexistente } catch { ... }`, o `catch` **não roda** — o erro é não-terminante. Para pegá-lo, force-o a ser terminante com `-ErrorAction Stop`:
> ```powershell
> try { Get-Item 'inexistente' -ErrorAction Stop } catch { "peguei: $($_.Exception.Message)" }
> ```

---

## 2. `$ErrorActionPreference` e `-ErrorAction`

Controlam o que acontece quando um erro **não-terminante** ocorre.

```powershell
$ErrorActionPreference = 'Stop'    # GLOBAL: todo erro não-terminante vira terminante
Get-Item x -ErrorAction SilentlyContinue   # LOCAL (só este comando): ignore e siga
```

| Valor | Efeito |
|---|---|
| `Continue` | mostra o erro e **continua** (padrão) |
| `Stop` | transforma em terminante (para / cai no `catch`) |
| `SilentlyContinue` | **suprime** o erro e continua |
| `Ignore` | ignora e nem registra em `$Error` (só como `-ErrorAction`) |
| `Inquire` | pergunta ao usuário o que fazer |

> 💡 **Padrão profissional:** no topo de scripts sérios, `$ErrorActionPreference = 'Stop'` — assim um erro inesperado para o script em vez de ele seguir num estado quebrado. É o equivalente ao `set -e` do Bash (Módulo 07 do curso de Bash), mas mais previsível.

---

## 3. `try` / `catch` / `finally` e `throw`

```powershell
try {
    $conteudo = Get-Content 'config.json' -ErrorAction Stop
    $dados = $conteudo | ConvertFrom-Json
}
catch {
    # $_ (ou $PSItem) é o ErrorRecord do erro capturado
    Write-Warning "Falha ao ler config: $($_.Exception.Message)"
    exit 1
}
finally {
    # roda SEMPRE (deu certo ou não) — ideal para limpeza
    Write-Verbose "encerrando"
}
```

**`throw`** lança um erro terminante (seu próprio ou reempacotando):
```powershell
function Test-Idade([int]$Idade) {
    if ($Idade -lt 0) { throw "Idade não pode ser negativa: $Idade" }
    $Idade
}
```

**Capturar tipos específicos** de exceção (vários `catch`):
```powershell
try { ... }
catch [System.IO.FileNotFoundException] { "arquivo sumiu" }
catch [System.UnauthorizedAccessException] { "sem permissão" }
catch { "qualquer outro erro: $($_.Exception.Message)" }   # genérico por último
```

> 💡 O objeto de erro (`$_`) é rico: `$_.Exception.Message` (a mensagem), `$_.Exception.GetType().FullName` (o tipo), `$_.ScriptStackTrace` (onde ocorreu), `$_.InvocationInfo.ScriptLineNumber` (a linha). Use `Get-Member` nele.

---

## 4. `$Error`: o histórico da sessão

`$Error` é um array automático com os erros da sessão — o mais recente em `$Error[0]`.

```powershell
$Error.Count          # quantos erros já ocorreram
$Error[0]             # o último erro
$Error.Clear()        # limpa o histórico
$?                    # o ÚLTIMO comando teve sucesso? ($true/$false)
```

---

## 5. Depuração

```powershell
# Breakpoints (pausa a execução para inspecionar):
Set-PSBreakpoint -Script meu.ps1 -Line 10            # por linha
Set-PSBreakpoint -Command 'Remove-Item'               # quando um comando é chamado
Set-PSBreakpoint -Variable 'config' -Mode Write       # quando uma variável muda

# Mensagens de depuração (só aparecem com -Debug ou $DebugPreference='Continue'):
Write-Debug "valor de x = $x"

# Trace de execução (mostra cada linha):
Set-PSDebug -Trace 1      # liga o trace
Set-PSDebug -Trace 0      # desliga
```

> 💡 Na prática, a melhor experiência de depuração é no **VS Code** com a extensão PowerShell: breakpoints visuais (clicando na margem), inspeção de variáveis (Watch), e a pilha de chamadas (Call Stack). O `Set-PSBreakpoint` é o motor por trás disso — bom conhecer para depurar em servidores sem interface gráfica.

---

## 🧪 Exemplos deste módulo

| Arquivo | Demonstra |
|---|---|
| [01-try-catch.ps1](exemplos/01-try-catch.ps1) | `try`/`catch`/`finally`, `throw`, capturar tipos específicos |
| [02-terminante-vs-nao.ps1](exemplos/02-terminante-vs-nao.ps1) | Por que o `catch` às vezes não pega, e como `-ErrorAction Stop` resolve |
| [03-erro-estruturado.ps1](exemplos/03-erro-estruturado.ps1) | Inspecionar o ErrorRecord e registrar um log de erro |

## ⚠️ Armadilhas do módulo

- Achar que `try/catch` pega erros não-terminantes (precisa de `-ErrorAction Stop`)
- Esquecer `finally` para a limpeza (lembra do `trap` do Bash?)
- `catch` genérico engolindo erros sem registrar nada
- Usar `-ErrorAction SilentlyContinue` e esconder um problema de verdade

## 🏋️ Exercícios

Veja [exercicios/README.md](exercicios/README.md). Corrija com `./ferramentas/corrigir.ps1 07`.

## ✅ Checklist de domínio

- [ ] Explico a diferença entre erro terminante e não-terminante
- [ ] Uso `-ErrorAction Stop` para tornar um erro capturável no `catch`
- [ ] Escrevo `try`/`catch`/`finally` e lanço com `throw`
- [ ] Inspeciono `$_.Exception.Message` e capturo tipos específicos
- [ ] Sei o que são `$Error`, `$?` e `Set-PSBreakpoint`

---

⬅️ [Módulo 06](../06-dados-e-objetos/README.md) · ➡️ [Módulo 08 — Objetos e .NET](../08-dotnet-e-objetos/README.md)

<sub>© 2026 Prof. Daniel Santos · Texto sob [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Código sob [PolyForm NC](../../LICENSE)</sub>
