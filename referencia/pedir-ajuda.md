# 🧭 Pedir ajuda: descobrir e inspecionar

**🌍 Idioma / Language:** **Português** · [English](pedir-ajuda.en.md)

O profissional de PowerShell não decora cmdlets — ele **descobre** e **inspeciona**. Com três cmdlets você se vira sozinho com qualquer coisa. Veja o [Módulo 00](../modulos/00-introducao-paradigma/).

## O fluxo dos três cmdlets

```
Get-Command  →  Get-Help  →  Get-Member
(achar)         (como usar)   (o que o objeto tem)
```

## `Get-Help` — a documentação

```powershell
Update-Help -ErrorAction SilentlyContinue   # baixa a ajuda (faça uma vez na máquina nova)
Get-Help Get-ChildItem                      # sinopse, sintaxe, parâmetros
Get-Help Get-ChildItem -Examples            # SÓ os exemplos — comece por aqui
Get-Help Get-ChildItem -Full                # tudo
Get-Help Get-ChildItem -Online              # abre a doc no navegador
Get-Help about_Functions                    # tópicos conceituais (about_*)
```

> 💡 `Get-Help <cmdlet> -Examples` é o atalho mais produtivo do PowerShell. E `Get-Help about_*` lista dezenas de guias conceituais (`about_Operators`, `about_Splatting`, `about_Regular_Expressions`…).

## `Get-Command` — descobrir cmdlets

```powershell
Get-Command -Verb Get                 # tudo que começa com Get-
Get-Command -Noun Process             # tudo que mexe com Process (Get/Start/Stop...)
Get-Command *service*                 # busca por nome aproximado
Get-Command -Module Microsoft.PowerShell.Management   # de um módulo específico
Get-Command Get-ChildItem -Syntax     # só a sintaxe, compacta
Get-Verb                              # os verbos aprovados (Get, Set, New, Remove...)
```

> 💡 A convenção **Verbo-Substantivo** deixa você *adivinhar*: se existe `Get-Service`, provavelmente existem `Start-Service`, `Stop-Service`, `Restart-Service`. Você deduz em vez de decorar.

## `Get-Member` — inspecionar o objeto (o mais importante)

```powershell
Get-Process | Get-Member               # TODAS as propriedades e métodos de um processo
Get-Process | Get-Member -MemberType Property   # só propriedades
(Get-Date)  | Get-Member -MemberType Method     # só métodos
'texto'     | Get-Member                # até uma string é um objeto, com métodos
```

> 💡 **O segredo do PowerShell não é decorar cmdlets — é inspecionar objetos.** Rodou um cmdlet e não sabe o que fazer com a saída? Mande para `Get-Member`, descubra as propriedades, use-as no `Select-Object`/`Where-Object`. Resolve qualquer coisa.

## Para builtins e tópicos

| Quer saber… | Use |
|---|---|
| O que um cmdlet faz | `Get-Help <cmdlet>` |
| Exemplos prontos | `Get-Help <cmdlet> -Examples` |
| Quais cmdlets existem | `Get-Command` |
| O que um objeto tem | `Get-Member` |
| Conceitos (operadores, escopo…) | `Get-Help about_<tópico>` |
| O tipo de um valor | `$x.GetType().FullName` |
| Métodos estáticos de uma classe | `[Math] \| Get-Member -Static` |

## Atalhos modernos

- `Get-Help <cmdlet> -ShowWindow` — abre a ajuda numa janela pesquisável (Windows).
- No **VS Code** com a extensão PowerShell: autocompletar, ajuda ao passar o mouse, e o `Get-Member` fica a um `|` de distância.

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
