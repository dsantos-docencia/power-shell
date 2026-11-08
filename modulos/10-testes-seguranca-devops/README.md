# Módulo 10 — Testes, Segurança e Boas Práticas (DevOps)

> *"Elevar o script ao nível de código de produção: analisado, testado, seguro e versionado."*

**Carga sugerida:** 8–10 h · **Nível:** avançado · **Pré-requisito:** [Módulo 09](../09-remoting-e-paralelismo/)

## 🎯 Objetivos

- Analisar código com **PSScriptAnalyzer** (o linter oficial)
- Escrever testes automatizados com **Pester** (o framework-padrão)
- Entender assinatura de código, **Constrained Language Mode** e **JEA**
- Tratar credenciais com segurança (`Get-Credential`, `SecureString`)
- Integrar com Git

---

## 1. PSScriptAnalyzer — o linter oficial

Analisa seu código estaticamente e aponta bugs e más práticas — sem executar nada. É o equivalente ao ShellCheck do Bash.

```powershell
Install-Module PSScriptAnalyzer -Scope CurrentUser    # instalar (uma vez)
Invoke-ScriptAnalyzer -Path .\meu-script.ps1          # analisar
Invoke-ScriptAnalyzer -Path . -Recurse                # a pasta toda
Invoke-ScriptAnalyzer -Path .\x.ps1 -Fix              # corrige o que der automaticamente
```

Exemplos do que ele pega:
| Regra | Pega |
|---|---|
| `PSAvoidUsingCmdletAliases` | `ls`/`gci` em vez de `Get-ChildItem` |
| `PSUseDeclaredVarsMoreThanAssignments` | variável atribuída e nunca usada |
| `PSAvoidUsingPlainTextForPassword` | senha em texto puro |
| `PSUseShouldProcessForStateChangingFunctions` | `Remove-*`/`Set-*` sem `-WhatIf` |
| `PSUseSingularNouns` | substantivo no plural no nome |

> 💡 **Este repositório** roda o PSScriptAnalyzer em **todo** `.ps1` via CI, com um [arquivo de configuração](../../PSScriptAnalyzerSettings.psd1) que documenta quais regras são excluídas e por quê. Integre ao **VS Code** (a extensão PowerShell já usa o analyzer) para ver os avisos enquanto digita.

### Silenciar uma regra (com justificativa)
```powershell
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '',
    Justification = 'Interface colorida de console; não é saída de dados.')]
param()
```

---

## 2. Pester — testes automatizados

[Pester](https://pester.dev) é o framework **BDD** padrão para testar PowerShell. Testes ficam em arquivos `*.Tests.ps1`.

```powershell
Install-Module Pester -Scope CurrentUser -SkipPublisherCheck   # instalar
Invoke-Pester                                                  # roda os *.Tests.ps1
```

Anatomia de um teste:
```powershell
BeforeAll {
    . $PSScriptRoot/calculadora.ps1    # carrega o que vai testar
}

Describe 'Somar' {
    It 'soma dois positivos' {
        Somar -A 2 -B 3 | Should -Be 5
    }
    It 'lança erro em entrada inválida' {
        { Somar -A 'x' -B 3 } | Should -Throw
    }
}
```

| Bloco / comando | Faz |
|---|---|
| `Describe` / `Context` | agrupa testes |
| `It` | um caso de teste |
| `Should -Be` / `-BeExactly` | asserção de igualdade |
| `Should -Throw` | espera uma exceção |
| `Should -Contain` / `-Match` | coleção / regex |
| `BeforeAll` / `BeforeEach` | preparação |
| `Mock` | substitui um cmdlet (isola dependências) |

> 💡 **Mock** é o superpoder do Pester: você substitui `Get-Service`, `Invoke-RestMethod` etc. por uma versão falsa, para testar sua lógica **sem** depender de serviços reais. Testes viram rápidos e determinísticos. Veja [`exemplos/calculadora.Tests.ps1`](exemplos/calculadora.Tests.ps1) — ele roda na verificação deste repositório.

> Este curso usa um mini-framework próprio para corrigir os exercícios (zero instalação), mas **Pester é o que você usa no trabalho** — e é testado de verdade aqui.

---

## 3. Segurança e hardening

### Assinatura de código
```powershell
# Assina um script com um certificado (garante autoria e integridade):
Set-AuthenticodeSignature -FilePath .\x.ps1 -Certificate $cert
```
Combinada com a ExecutionPolicy `AllSigned`/`RemoteSigned` (Módulo 00), impede que scripts adulterados rodem.

### Constrained Language Mode (CLM)
Restringe o PowerShell a um subconjunto seguro (bloqueia chamadas .NET arbitrárias, `Add-Type` etc.). Usado em ambientes travados, junto com AppLocker/WDAC. É uma barreira **de verdade** — diferente da ExecutionPolicy.

### JEA — Just Enough Administration
Permite delegar tarefas administrativas **sem** dar acesso total. Um operador pode reiniciar um serviço específico via uma sessão JEA, sem ser admin da máquina. Princípio do menor privilégio aplicado ao remoting.

### Credenciais — nunca em texto puro
```powershell
$cred = Get-Credential                          # pede usuário/senha com segurança
$cred.UserName                                  # o usuário
# $cred.Password é um SecureString (não é texto puro na memória comum)

# NUNCA faça: $senha = 'MinhaSenha123'   (texto puro no script = vazamento)
```

> ⚠️ **`SecureString` não é criptografia forte** — é ofuscação na memória, reversível por quem tem acesso ao processo. Para segredos de verdade, use um cofre: o módulo **`Microsoft.PowerShell.SecretManagement`** + um backend (Azure Key Vault, etc.). Nunca commite senhas; o secret scanning deste repositório (veja [`SECURITY.md`](../../SECURITY.md)) ajuda a barrar isso.

---

## 4. Git e DevOps

PowerShell se integra ao fluxo DevOps: scripts versionados no Git, analisados (PSScriptAnalyzer) e testados (Pester) por um pipeline de CI — exatamente como este repositório faz com o [GitHub Actions](../../.github/workflows/verificar.yml).

```powershell
git add . ; git commit -m "feat: novo script de inventário"
# o CI roda PSScriptAnalyzer + Pester automaticamente no PR
```

---

## 🧪 Exemplos deste módulo

| Arquivo | Demonstra |
|---|---|
| [calculadora.ps1](exemplos/calculadora.ps1) | Uma ferramenta com validação (alvo dos testes) |
| [calculadora.Tests.ps1](exemplos/calculadora.Tests.ps1) | **Testes Pester de verdade** (rodam na verificação) |
| [01-analise-estatica.ps1](exemplos/01-analise-estatica.ps1) | Rodar o PSScriptAnalyzer e ver o que ele pega |
| [02-credenciais.ps1](exemplos/02-credenciais.ps1) | `SecureString`/`PSCredential` sem expor segredos |

> Rode os testes Pester com: `Invoke-Pester modulos/10-testes-seguranca-devops/exemplos`

## ⚠️ Armadilhas do módulo

- Ignorar avisos do PSScriptAnalyzer "porque funciona"
- Testar só o caminho feliz (teste erros e bordas também)
- Senha em texto puro no script (use `Get-Credential`/cofre)
- Confiar no `SecureString` como se fosse criptografia forte

## 🏋️ Exercícios

Veja [exercicios/README.md](exercicios/README.md). Corrija com `./ferramentas/corrigir.ps1 10`.

## ✅ Checklist de domínio

- [ ] Rodo o PSScriptAnalyzer e entendo/corrijo os avisos
- [ ] Escrevo testes Pester com `Describe`/`It`/`Should`
- [ ] Sei o que são assinatura de código, CLM e JEA
- [ ] Trato credenciais com `Get-Credential`/cofre, nunca texto puro
- [ ] Entendo o fluxo Git + CI (analyzer + Pester)

---

⬅️ [Módulo 09](../09-remoting-e-paralelismo/README.md) · ➡️ [Módulo 11 — Módulos e Distribuição](../11-modulos-e-distribuicao/README.md)

<sub>© 2026 Prof. Daniel Santos · Texto sob [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Código sob [PolyForm NC](../../LICENSE)</sub>
