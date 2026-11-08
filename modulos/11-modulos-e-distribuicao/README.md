# Módulo 11 — Módulos e Distribuição

> *"Um script resolve o seu problema de hoje. Um módulo resolve o problema de todo mundo, para sempre."*

**Carga sugerida:** 6–8 h · **Nível:** avançado · **Pré-requisito:** [Módulo 10](../10-testes-seguranca-devops/)

## 🎯 Objetivos

- Transformar um conjunto de funções em um **módulo** (`.psm1`)
- Escrever um **manifesto** (`.psd1`) com versão, autor, dependências e exports
- Entender `Export-ModuleMember` e por que **exportar só o que é público**
- Conhecer o **PSResourceGet** (`Find`/`Install`/`Publish-PSResource`) e a **PowerShell Gallery**
- Versionar com **SemVer** e organizar o repositório para publicação

---

## 1. De script a módulo

Um **módulo** é só uma pasta com um arquivo `.psm1` (o código) e, idealmente, um `.psd1` (o manifesto, os "metadados"). O nome da pasta, do `.psm1` e do `.psd1` devem ser **iguais**:

```
MinhaFerramenta/
├── MinhaFerramenta.psm1     # as funções
└── MinhaFerramenta.psd1     # o manifesto (versão, autor, exports...)
```

Dentro do `.psm1`, você define funções normalmente e no fim decide o que fica **público**:

```powershell
function Get-Saudacao { param([string]$Nome) "Olá, $Nome!" }
function Format-Interno { param($x) $x }   # ajudante privado

Export-ModuleMember -Function Get-Saudacao   # só esta vira pública
```

> 💡 **Regra de ouro do toolmaking:** exporte o mínimo. Funções auxiliares (`Format-Interno`) ficam de fora. Quem instala seu módulo vê uma interface limpa — e você pode refatorar o resto sem quebrar ninguém.

Para carregar:

```powershell
Import-Module ./MinhaFerramenta/MinhaFerramenta.psd1
Get-Saudacao -Nome "Daniel"     # Olá, Daniel!
Get-Command -Module MinhaFerramenta   # lista só o que foi exportado
```

---

## 2. O manifesto (`.psd1`)

O manifesto é uma **hashtable** com os metadados do módulo. Você não escreve na mão — gera com `New-ModuleManifest`:

```powershell
New-ModuleManifest -Path ./MinhaFerramenta/MinhaFerramenta.psd1 `
    -RootModule       'MinhaFerramenta.psm1' `
    -ModuleVersion    '1.0.0' `
    -Author           'Daniel Santos' `
    -Description      'Ferramentas de saudação' `
    -FunctionsToExport @('Get-Saudacao') `
    -PowerShellVersion '7.0'
```

| Campo | Para que serve |
|---|---|
| `RootModule` | qual `.psm1` carregar |
| `ModuleVersion` | a versão **SemVer** (ver seção 4) |
| `FunctionsToExport` | lista **explícita** do que é público (nada de `'*'`) |
| `RequiredModules` | dependências que o motor instala/carrega junto |
| `PowerShellVersion` | versão mínima exigida |
| `PrivateData.PSData.Tags` | palavras-chave para a Gallery encontrar |

Valide sempre antes de publicar:

```powershell
Test-ModuleManifest ./MinhaFerramenta/MinhaFerramenta.psd1
```

> ⚠️ `FunctionsToExport = '*'` parece prático, mas desliga a otimização de descoberta de comandos e **vaza** ajudantes privados. Liste os nomes, um a um. O manifesto é um **contrato** com quem usa seu módulo.

---

## 3. Publicar: PSResourceGet e a PowerShell Gallery

A **PowerShell Gallery** (`powershellgallery.com`) é o repositório público — o "npm/PyPI" do PowerShell. O módulo moderno para falar com ela é o **`Microsoft.PowerShell.PSResourceGet`** (sucessor do antigo `PowerShellGet`):

```powershell
# descobrir e instalar
Find-PSResource Pester                     # procura na Gallery
Install-PSResource Pester -Scope CurrentUser

# publicar (precisa de uma API key da sua conta na Gallery)
Publish-PSResource -Path ./MinhaFerramenta -ApiKey $env:NUGET_KEY
```

| Verbo antigo (`PowerShellGet`) | Verbo novo (`PSResourceGet`) |
|---|---|
| `Find-Module` | `Find-PSResource` |
| `Install-Module` | `Install-PSResource` |
| `Publish-Module` | `Publish-PSResource` |
| `Update-Module` | `Update-PSResource` |

> 💡 Você também pode hospedar um **repositório privado** (NuGet, Azure Artifacts, GitHub Packages) e registrá-lo com `Register-PSResourceRepository` — útil para módulos internos da empresa que não vão para a Gallery pública.

---

## 4. Versionamento (SemVer)

A Gallery e o `Update-PSResource` dependem de versões bem-comportadas. Use **SemVer** `MAJOR.MINOR.PATCH`:

| Mudança | O que incrementar |
|---|---|
| Correção compatível (bug fix) | **PATCH** → `1.2.3` → `1.2.4` |
| Novo recurso compatível | **MINOR** → `1.2.3` → `1.3.0` (zera o patch) |
| Quebra de compatibilidade | **MAJOR** → `1.2.3` → `2.0.0` (zera minor e patch) |

> No [Módulo 10](../10-testes-seguranca-devops/) você automatizou o bump de **patch** num passo de release. Aqui a disciplina se completa: **subir minor zera o patch**, subir major zera os dois. Previsibilidade é o que deixa seus usuários tranquilos para atualizar.

---

## 🧪 Exemplos

Rode cada um com `pwsh ./exemplos/<arquivo>.ps1`:

1. **`01-construir-modulo.ps1`** — cria uma pasta de módulo com `.psm1`, importa e chama a função pública (e mostra que a privada **não** aparece).
2. **`02-manifesto.ps1`** — gera um `.psd1` com `New-ModuleManifest` e valida com `Test-ModuleManifest`.
3. **`03-publicar-conceitual.ps1`** — passo a passo narrado de `Find`/`Install`/`Publish-PSResource` (sem publicar de verdade — você vê os comandos exatos).

## 🏋️ Exercícios

Veja [exercicios/README.md](exercicios/README.md). Corrija com `./ferramentas/corrigir.ps1 11`.

## ✅ Checklist de domínio

- [ ] Transformo um conjunto de funções num `.psm1` e importo
- [ ] Exporto **só o que é público** com `Export-ModuleMember`/`FunctionsToExport`
- [ ] Gero e valido um manifesto com `New-ModuleManifest` + `Test-ModuleManifest`
- [ ] Sei usar `Find`/`Install`/`Publish-PSResource` (PSResourceGet)
- [ ] Aplico SemVer corretamente (patch, minor zera patch, major zera os dois)

---

🎓 **Você chegou ao fim da trilha.** Do primeiro `Get-Command` ao módulo publicado, você percorreu o PowerShell inteiro. O próximo passo é o melhor de todos: **construa algo**, compartilhe na comunidade e [contribua com o curso](../../CONTRIBUTING.md). *Não deixe o conhecimento morrer com você.*

---

⬅️ [Módulo 10](../10-testes-seguranca-devops/README.md) · 🏠 [Início](../../README.md) · 🚀 [Projetos](../../projetos/)

<sub>© 2026 Prof. Daniel Santos · Texto sob [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Código sob [PolyForm NC](../../LICENSE)</sub>
