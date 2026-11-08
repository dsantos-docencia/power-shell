# Módulo 09 — Automação em Massa, Remoting e Paralelismo

> *"Administrar um servidor é útil. Administrar mil ao mesmo tempo é PowerShell."*

**Carga sugerida:** 8–12 h · **Nível:** avançado · **Pré-requisito:** [Módulo 08](../08-dotnet-e-objetos/)

## 🎯 Objetivos

- Rodar tarefas em segundo plano com **Jobs**
- Paralelizar com `ForEach-Object -Parallel` e `-ThrottleLimit` (PowerShell 7+)
- Entender **PowerShell Remoting** (WinRM e SSH) e `Invoke-Command`
- Conhecer `$Using:` para passar variáveis locais a sessões remotas
- Saber quando descer para **runspaces** e como **agendar** execuções

---

## 1. Jobs: tarefas em segundo plano

Um **Job** roda um bloco de código em outro processo, liberando seu console.

```powershell
$job = Start-Job -ScriptBlock { Start-Sleep 2; "resultado pronto" }
Get-Job                       # lista os jobs e seu estado (Running/Completed)
Wait-Job $job | Out-Null      # espera terminar
Receive-Job $job              # pega o resultado: "resultado pronto"
Remove-Job $job               # limpa
```

| Cmdlet | Faz |
|---|---|
| `Start-Job` | inicia um job em background (processo separado) |
| `Get-Job` | lista os jobs e estados |
| `Wait-Job` | espera um ou vários terminarem |
| `Receive-Job` | pega a saída do job |
| `Stop-Job` / `Remove-Job` | para / remove |
| `Start-ThreadJob` | job mais **leve** (thread, não processo) — ótimo para muitos jobs |

> 💡 `Start-Job` cria um **processo** (isolado, mas pesado). `Start-ThreadJob` (módulo `ThreadJob`, incluso no PS7) usa **threads** — bem mais leve quando você dispara dezenas de tarefas. Para I/O (consultar vários servidores, baixar várias URLs), threads brilham.

---

## 2. `ForEach-Object -Parallel` (PowerShell 7+)

O jeito moderno e simples de paralelizar um pipeline:

```powershell
1..10 | ForEach-Object -Parallel {
    Start-Sleep 1
    "processado $_"
} -ThrottleLimit 5             # no máximo 5 ao mesmo tempo
```

- Cada item roda num runspace separado, **em paralelo**.
- `-ThrottleLimit N` limita quantos rodam simultaneamente (não adianta abrir 1000 de uma vez).
- Dentro do bloco, `$_` é o item atual.

> ⚠️ **Variáveis externas precisam de `$using:`** dentro do bloco `-Parallel` (como no remoting). O bloco roda em outro runspace e não enxerga suas variáveis automaticamente:
> ```powershell
> $prefixo = 'srv-'
> 1..3 | ForEach-Object -Parallel { "$using:prefixo$_" }   # usa $using:prefixo
> ```

> 💡 **Paralelismo nem sempre é mais rápido.** Há custo para criar runspaces. Vale a pena quando cada item demora (I/O, rede, espera) — não para contas triviais. Meça com `Measure-Command` (exemplo 02).

---

## 3. PowerShell Remoting

Rodar comandos em **outras máquinas**. Dois transportes: **WinRM** (padrão no Windows) e **SSH** (multiplataforma, PowerShell 7+).

```powershell
# Um comando numa máquina (ou em várias de uma vez):
Invoke-Command -ComputerName srv01, srv02 -ScriptBlock { Get-Service }

# Sessão interativa (como um SSH):
Enter-PSSession -ComputerName srv01
# ... você está "dentro" do srv01 ...
Exit-PSSession

# Sessão persistente reutilizável:
$sessao = New-PSSession -HostName srv01 -UserName admin   # via SSH no PS7
Invoke-Command -Session $sessao -ScriptBlock { hostname }
```

**`$Using:`** passa uma variável local para o bloco remoto:
```powershell
$servico = 'nginx'
Invoke-Command -ComputerName srv01 -ScriptBlock { Get-Service $using:servico }
```

> 💡 A beleza do remoting no PowerShell 7: o que volta são **objetos** (desserializados), não texto. `Invoke-Command { Get-Process }` traz objetos de processo das máquinas remotas, prontos para `Where-Object`/`Sort-Object` — você filtra o resultado de 100 servidores com um pipeline. Remoting por **SSH** torna isso multiplataforma: o mesmo script administra Windows e Linux.

---

## 4. Runspaces e agendamento

**Runspaces** são o mecanismo de baixo nível por trás do `-Parallel` e dos ThreadJobs. Você mexe neles diretamente só em cenários extremos de performance (milhares de operações concorrentes com controle fino). Para 99% dos casos, `ForEach-Object -Parallel` e `Start-ThreadJob` bastam.

**Agendamento** — rodar scripts automaticamente:
- **Windows:** Agendador de Tarefas (`Register-ScheduledTask`, `New-ScheduledTaskTrigger`).
- **Linux/macOS:** `cron`, chamando `pwsh -File /caminho/script.ps1`.

```cron
0 2 * * *  pwsh -File /opt/scripts/backup.ps1 >> /var/log/backup.log 2>&1
```

> ⚠️ Mesma armadilha do cron que vimos no Bash: ambiente mínimo. Use caminhos absolutos e teste como o agendador vê o ambiente.

---

## 🧪 Exemplos deste módulo

| Arquivo | Demonstra |
|---|---|
| [01-jobs.ps1](exemplos/01-jobs.ps1) | `Start-Job`, `Wait-Job`, `Receive-Job` e `Start-ThreadJob` |
| [02-paralelo.ps1](exemplos/02-paralelo.ps1) | `ForEach-Object -Parallel`, `$using:`, `-ThrottleLimit` e medição |
| [03-remoting-conceitual.ps1](exemplos/03-remoting-conceitual.ps1) | O padrão `Invoke-Command`/`$Using:` (simulado localmente, sem rede) |

> Os exemplos **não** acessam máquinas remotas — o de remoting demonstra o padrão localmente para rodar em qualquer lugar.

## ⚠️ Armadilhas do módulo

- Esquecer `$using:` para acessar variáveis externas em `-Parallel`/remoting
- Abrir paralelismo sem `-ThrottleLimit` e sobrecarregar a máquina
- Usar `Start-Job` (processo pesado) onde `Start-ThreadJob` (leve) bastaria
- Paralelizar tarefas triviais e ficar mais lento (custo de criar runspaces)

## 🏋️ Exercícios

Veja [exercicios/README.md](exercicios/README.md). Corrija com `./ferramentas/corrigir.ps1 09`.

## ✅ Checklist de domínio

- [ ] Rodo um Job e pego o resultado com `Receive-Job`
- [ ] Paralelizo com `ForEach-Object -Parallel` e limito com `-ThrottleLimit`
- [ ] Uso `$using:` para acessar variáveis externas no bloco paralelo/remoto
- [ ] Entendo `Invoke-Command` e remoting por WinRM/SSH
- [ ] Sei quando paralelismo vale a pena (I/O, espera) e quando não

---

⬅️ [Módulo 08](../08-dotnet-e-objetos/README.md) · ➡️ [Módulo 10 — Testes, Segurança e DevOps](../10-testes-seguranca-devops/README.md)

<sub>© 2026 Prof. Daniel Santos · Texto sob [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Código sob [PolyForm NC](../../LICENSE)</sub>
