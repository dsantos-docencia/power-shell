# Module 09 — Mass Automation, Remoting, and Parallelism

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Spotted a slip or have a better wording? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues) — see [traducoes/](../../traducoes/README.en.md).*

> *"Administering one server is useful. Administering a thousand at once is PowerShell."*

**Suggested load:** 8–12 h · **Level:** advanced · **Prerequisite:** [Module 08](../08-dotnet-e-objetos/README.en.md)

## 🎯 Objectives

- Run background tasks with **Jobs**
- Parallelize with `ForEach-Object -Parallel` and `-ThrottleLimit` (PowerShell 7+)
- Understand **PowerShell Remoting** (WinRM and SSH) and `Invoke-Command`
- Learn `$Using:` to pass local variables to remote sessions
- Know when to drop down to **runspaces** and how to **schedule** runs

---

## 1. Jobs: background tasks

A **Job** runs a block of code in another process, freeing up your console.

```powershell
$job = Start-Job -ScriptBlock { Start-Sleep 2; "result ready" }
Get-Job                       # lists jobs and their state (Running/Completed)
Wait-Job $job | Out-Null      # waits for it to finish
Receive-Job $job              # gets the result: "result ready"
Remove-Job $job               # cleans up
```

| Cmdlet | Does |
|---|---|
| `Start-Job` | starts a background job (separate process) |
| `Get-Job` | lists the jobs and states |
| `Wait-Job` | waits for one or several to finish |
| `Receive-Job` | gets the job's output |
| `Stop-Job` / `Remove-Job` | stop / remove |
| `Start-ThreadJob` | a **lighter** job (thread, not process) — great for many jobs |

> 💡 `Start-Job` creates a **process** (isolated, but heavy). `Start-ThreadJob` (the `ThreadJob` module, included in PS7) uses **threads** — much lighter when you fire off dozens of tasks. For I/O (querying several servers, downloading several URLs), threads shine.

---

## 2. `ForEach-Object -Parallel` (PowerShell 7+)

The modern, simple way to parallelize a pipeline:

```powershell
1..10 | ForEach-Object -Parallel {
    Start-Sleep 1
    "processed $_"
} -ThrottleLimit 5             # at most 5 at the same time
```

- Each item runs in a separate runspace, **in parallel**.
- `-ThrottleLimit N` limits how many run simultaneously (no point opening 1000 at once).
- Inside the block, `$_` is the current item.

> ⚠️ **External variables need `$using:`** inside the `-Parallel` block (as in remoting). The block runs in another runspace and doesn't see your variables automatically:
> ```powershell
> $prefixo = 'srv-'
> 1..3 | ForEach-Object -Parallel { "$using:prefixo$_" }   # uses $using:prefixo
> ```

> 💡 **Parallelism isn't always faster.** There's a cost to creating runspaces. It pays off when each item takes a while (I/O, network, waiting) — not for trivial math. Measure with `Measure-Command` (example 02).

---

## 3. PowerShell Remoting

Running commands on **other machines**. Two transports: **WinRM** (default on Windows) and **SSH** (cross-platform, PowerShell 7+).

```powershell
# One command on a machine (or on several at once):
Invoke-Command -ComputerName srv01, srv02 -ScriptBlock { Get-Service }

# Interactive session (like an SSH):
Enter-PSSession -ComputerName srv01
# ... you're "inside" srv01 ...
Exit-PSSession

# Reusable persistent session:
$sessao = New-PSSession -HostName srv01 -UserName admin   # via SSH on PS7
Invoke-Command -Session $sessao -ScriptBlock { hostname }
```

**`$Using:`** passes a local variable to the remote block:
```powershell
$servico = 'nginx'
Invoke-Command -ComputerName srv01 -ScriptBlock { Get-Service $using:servico }
```

> 💡 The beauty of remoting in PowerShell 7: what comes back are **objects** (deserialized), not text. `Invoke-Command { Get-Process }` brings process objects back from the remote machines, ready for `Where-Object`/`Sort-Object` — you filter the result of 100 servers with one pipeline. Remoting over **SSH** makes this cross-platform: the same script administers Windows and Linux.

---

## 4. Runspaces and scheduling

**Runspaces** are the low-level mechanism behind `-Parallel` and ThreadJobs. You touch them directly only in extreme performance scenarios (thousands of concurrent operations with fine control). For 99% of cases, `ForEach-Object -Parallel` and `Start-ThreadJob` are enough.

**Scheduling** — running scripts automatically:
- **Windows:** Task Scheduler (`Register-ScheduledTask`, `New-ScheduledTaskTrigger`).
- **Linux/macOS:** `cron`, calling `pwsh -File /path/script.ps1`.

```cron
0 2 * * *  pwsh -File /opt/scripts/backup.ps1 >> /var/log/backup.log 2>&1
```

> ⚠️ Same cron trap we saw in Bash: a minimal environment. Use absolute paths and test how the scheduler sees the environment.

---

## 🧪 Examples in this module

| File | Demonstrates |
|---|---|
| [01-jobs.ps1](exemplos/01-jobs.ps1) | `Start-Job`, `Wait-Job`, `Receive-Job`, and `Start-ThreadJob` |
| [02-paralelo.ps1](exemplos/02-paralelo.ps1) | `ForEach-Object -Parallel`, `$using:`, `-ThrottleLimit`, and measurement |
| [03-remoting-conceitual.ps1](exemplos/03-remoting-conceitual.ps1) | The `Invoke-Command`/`$Using:` pattern (simulated locally, no network) |

> The examples do **not** access remote machines — the remoting one demonstrates the pattern locally so it runs anywhere.

## ⚠️ Module pitfalls

- Forgetting `$using:` to access external variables in `-Parallel`/remoting
- Opening parallelism without `-ThrottleLimit` and overloading the machine
- Using `Start-Job` (heavy process) where `Start-ThreadJob` (light) would do
- Parallelizing trivial tasks and getting slower (cost of creating runspaces)

## 🏋️ Exercises

See [exercicios/README.en.md](exercicios/README.en.md). Grade with `./ferramentas/corrigir.ps1 09`.

## ✅ Mastery checklist

- [ ] I run a Job and get the result with `Receive-Job`
- [ ] I parallelize with `ForEach-Object -Parallel` and cap it with `-ThrottleLimit`
- [ ] I use `$using:` to access external variables in the parallel/remote block
- [ ] I understand `Invoke-Command` and remoting over WinRM/SSH
- [ ] I know when parallelism pays off (I/O, waiting) and when it doesn't

---

⬅️ [Module 08](../08-dotnet-e-objetos/README.en.md) · ➡️ [Module 10 — Testing, Security, and DevOps](../10-testes-seguranca-devops/README.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · Text under [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Code under [PolyForm NC](../../LICENSE)</sub>
