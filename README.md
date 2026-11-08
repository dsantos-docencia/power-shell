<div align="center">

# 🪟 PowerShell do Zero à Automação Corporativa

### Um curso aberto, prático e verificável de PowerShell — do terminal ao DevOps, Windows e multiplataforma

*Material didático gratuito e aberto — para uso não comercial.*

**🌍 Idioma / Language:** **Português** · [English](README.en.md)

[![Licença do código: PolyForm NC](https://img.shields.io/badge/c%C3%B3digo-PolyForm%20NC-orange.svg)](LICENSE)
[![Licença do conteúdo: CC BY-NC-SA 4.0](https://img.shields.io/badge/conte%C3%BAdo-CC%20BY--NC--SA%204.0-lightgrey.svg)](LICENSE-CONTEUDO.md)
[![Verificação](https://github.com/dsantos-docencia/power-shell/actions/workflows/verificar.yml/badge.svg)](https://github.com/dsantos-docencia/power-shell/actions)
[![PRs bem-vindos](https://img.shields.io/badge/PRs-bem--vindos-brightgreen.svg)](CONTRIBUTING.md)

</div>

---

## 👋 Boas-vindas

Olá! Eu sou o **Professor Daniel Santos** — desenvolvedor, provedor de serviços de tecnologia e professor de cursos técnicos de TI e segurança cibernética. Trabalho com infraestrutura, automação e administração de sistemas todos os dias, e dou aula do que faço.

Este repositório é irmão do meu [curso de Bash](https://github.com/dsantos-docencia/Bash) — mesma filosofia, outro mundo. Porque PowerShell **não é "o Bash do Windows"**: é uma mudança de paradigma. Enquanto o Bash passa **texto** de um comando para o outro, o PowerShell passa **objetos .NET** — com propriedades e métodos. Entender isso é o "clique" que separa quem decora comandos de quem realmente automatiza.

Aqui a proposta é a mesma de sempre: cada conceito vem com **o porquê**, cada exemplo **roda de verdade** (uma esteira automática verifica isso a cada alteração, com PSScriptAnalyzer e Pester) e cada exercício tem **correção automática**, para você saber na hora se acertou.

É de graça, é aberto e é para a comunidade (uso não comercial). Se ajudar você, deixe uma ⭐ e, se puder, [contribua](CONTRIBUTING.md).

> *"No Bash você pensa em texto. No PowerShell, você pensa em objetos. Quando essa ficha cai, você nunca mais olha para a automação do mesmo jeito."* — Prof. Daniel

---

## 🎯 Para quem é este curso

- **Quem vem do Windows/CMD** e quer parar de clicar e começar a automatizar.
- **Quem já sabe Bash** e precisa dominar o paradigma de objetos do PowerShell.
- **Administradores de sistemas, DevOps e SRE** gerenciando Windows, Active Directory, Azure — e cada vez mais Linux com o mesmo PowerShell 7.
- **Estudantes de TI** que querem uma ferramenta de automação moderna e multiplataforma.

Pré-requisito único: vontade de pensar diferente.

---

## 🗺️ Trilha de aprendizado

Cada módulo tem: **teoria** (`README.md`), **exemplos executáveis comentados** (`exemplos/`) e **exercícios com correção automática** (`exercicios/`).

| # | Módulo | O que você domina | Horas |
|---|---|---|---|
| 00 | [Introdução e o Novo Paradigma](modulos/00-introducao-paradigma/) | Objeto vs. texto, história (Monad), 5.1 vs. 7+, instalação, ExecutionPolicy | 4–6 |
| 01 | [Navegação e Cmdlets](modulos/01-navegacao-cmdlets/) | Verbo-Substantivo, `Get-Help`, `Get-Command`, providers (PSDrives), aliases | 5–7 |
| 02 | [O Pipeline de Objetos](modulos/02-pipeline-objetos/) | `Get-Member`, `Where/Select/Sort/Group`, formatação, exportação | 8–10 |
| 03 | [Scripting e Variáveis](modulos/03-scripting-variaveis/) | `$PROFILE`, tipos, operadores, streams de saída (e a "regra do Write-Host") | 6–8 |
| 04 | [Controle de Fluxo](modulos/04-controle-de-fluxo/) | `if`, `switch` turbinado, loops, `foreach` vs. `ForEach-Object` | 8–10 |
| 05 | [Funções e Toolmaking](modulos/05-funcoes-toolmaking/) | `[CmdletBinding()]`, parâmetros avançados, `begin/process/end`, `-WhatIf` | 8–10 |
| 06 | [Dados e Objetos](modulos/06-dados-e-objetos/) | Arrays, hashtables, `[PSCustomObject]`, strings, JSON/CSV/XML | 8–10 |
| 07 | [Erros e Debugging](modulos/07-erros-e-debugging/) | Terminantes vs. não-terminantes, `try/catch`, `$ErrorActionPreference`, breakpoints | 6–8 |
| 08 | [Objetos e .NET](modulos/08-dotnet-e-objetos/) | `[PSCustomObject]`, `class`/`enum`, chamar .NET direto, `Add-Type` | 6–8 |
| 09 | [Remoting e Paralelismo](modulos/09-remoting-e-paralelismo/) | Remoting (WinRM/SSH), jobs, `ForEach-Object -Parallel`, runspaces, agendamento | 8–12 |
| 10 | [Testes, Segurança e DevOps](modulos/10-testes-seguranca-devops/) | PSScriptAnalyzer, Pester, code signing, CLM, JEA, Git | 8–10 |
| 11 | [Módulos e Distribuição](modulos/11-modulos-e-distribuicao/) | `.psm1`/`.psd1`, PowerShell Gallery, PSResourceGet | 6–8 |

🚀 **Projetos práticos**: veja [projetos/](projetos/) — inventário de sistema, limpeza com `-WhatIf`, health-check multiplataforma, CLI profissional e módulo corporativo.

📚 **Referência rápida**: veja [referencia/](referencia/) — cheat sheet de cmdlets, operadores, variáveis automáticas, 5.1 vs. 7+, e um **guia de tradução Bash → PowerShell**.

---

## 🚦 Começando em 3 passos

```powershell
# 1. Clone o repositório
git clone https://github.com/dsantos-docencia/power-shell.git
cd power-shell

# 2. Abra o primeiro módulo
Get-Content modulos/00-introducao-paradigma/README.md | more

# 3. Rode um exemplo (não quebra nada — tudo roda em pasta temporária)
pwsh ./modulos/00-introducao-paradigma/exemplos/01-objeto-vs-texto.ps1
```

Fez um exercício? Corrija na hora:
```powershell
./ferramentas/corrigir.ps1 00        # corrige todos os exercícios do módulo 00
```

Quer um ambiente 100% isolado? Use o laboratório em container:
```bash
./laboratorio/entrar.sh             # precisa de Docker (veja laboratorio/README.md)
```

---

## 🧰 O que torna este repositório diferente

- **Tudo roda.** Um robô ([GitHub Actions](.github/workflows/verificar.yml)) executa o parser, o **PSScriptAnalyzer** e **todos** os exemplos e soluções a cada push. Selo verde = cada linha aqui funciona.
- **Correção automática.** Um mini-framework em PowerShell puro ([ferramentas/](ferramentas/)) corrige seus exercícios e explica *por que* você errou — sem precisar instalar nada.
- **Foco no paradigma.** O coração do curso é o [Módulo 02 — Pipeline de Objetos](modulos/02-pipeline-objetos/). É onde o PowerShell se revela.
- **`Get-Member` em tudo.** O segredo não é decorar 10.000 cmdlets, mas saber **inspecionar** o objeto que saiu de um cmdlet.

---

## 🌐 Comunidades e documentação

Lista curada em **[referencia/recursos.md](referencia/recursos.md)**. Destaques: [Microsoft Learn — PowerShell](https://learn.microsoft.com/powershell/), [PowerShell Gallery](https://www.powershellgallery.com/), [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer), [Pester](https://pester.dev/) e o repositório oficial [PowerShell/PowerShell](https://github.com/PowerShell/PowerShell).

---

## 🤝 Contribuindo

> **Junte-se a mim e deixe algo de útil para o próximo.** 🌱 Conhecimento que não é compartilhado morre com quem o guarda.

- **Achou um erro ou tem uma ideia?** [Abra uma issue](https://github.com/dsantos-docencia/power-shell/issues/new/choose) ou mande um PR.
- **Escreveu um script legal?** Envie pela trilha **"📜 Enviar um script para a comunidade"** — a gente avalia e, se fizer sentido, inclui em [`scripts/comunidade/`](scripts/comunidade/) com seu crédito. *Não deixe o conhecimento morrer com você.*
- **Fala outro idioma?** Ajude a traduzir ([guia](traducoes/README.md)).

Leia o [guia de contribuição](CONTRIBUTING.md). Quem contribui entra em [CONTRIBUTORS.md](CONTRIBUTORS.md). 💚

---

## 📄 Licença e autoria

Criado e mantido por **Prof. Daniel Santos** ([@dsantos-docencia](https://github.com/dsantos-docencia)).

Material **aberto para uso não comercial** — estude, use e aprenda à vontade; só não vale explorar comercialmente. Detalhes e direitos do autor no [NOTICE](NOTICE.md).

- **Código**: [PolyForm Noncommercial 1.0.0](LICENSE) — usar, modificar e redistribuir **para fins não comerciais**.
- **Conteúdo didático**: [CC BY-NC-SA 4.0](LICENSE-CONTEUDO.md) — compartilhe e adapte **para fins não comerciais**, com atribuição e mesma licença.
- **Uso comercial** requer autorização do autor.

> A pasta [`scripts/`](scripts/) contém scripts reais usados em aula, com curadoria. Leia o [aviso da pasta](scripts/README.md) antes de executá-los.

<div align="center">
<sub>Feito com dedicação para quem quer <b>entender</b>, não apenas copiar. · © 2026 Daniel Santos</sub>
</div>
