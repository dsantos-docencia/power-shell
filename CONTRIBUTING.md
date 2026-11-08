# 🤝 Guia de Contribuição

**Junte-se a mim e deixe algo de útil para o próximo.** 🌱 Conhecimento que não é compartilhado morre com quem o guarda. Correções, novos exemplos, exercícios, traduções, scripts da comunidade e melhorias de texto são todos bem-vindos.

## Formas de contribuir

| Quero… | Como |
|---|---|
| **Corrigir um erro** | [issue "🐛 Erro"](https://github.com/dsantos-docencia/power-shell/issues/new/choose) ou PR direto |
| **Sugerir um exemplo/exercício** | [issue "💡 Sugestão"](https://github.com/dsantos-docencia/power-shell/issues/new/choose) |
| **Compartilhar um script meu** | [issue "📜 Enviar um script"](https://github.com/dsantos-docencia/power-shell/issues/new/choose) → entra em [`scripts/comunidade/`](scripts/comunidade/) com seu crédito |
| **Traduzir** | veja o [guia de tradução](traducoes/README.md) |

> **Sobre a licença:** ao contribuir, você concorda que sua contribuição será publicada sob as licenças do projeto (**uso não comercial** — PolyForm Noncommercial para código, CC BY-NC-SA para conteúdo; veja o [NOTICE](NOTICE.md)), mantendo seu crédito.

## Antes de começar

Promessa do repositório: **todo código aqui funciona**. Rode a verificação local antes de abrir um PR:

```powershell
./ferramentas/verificar-tudo.ps1
```

Ela roda, para todo `.ps1`/`.psm1` (fora de `scripts/`): **sintaxe** (parser), **PSScriptAnalyzer**, **execução** dos exemplos, **soluções** oficiais contra os testes, **Pester** (se houver) e **testes dos projetos**. Verde local = verde no [GitHub Actions](.github/workflows/verificar.yml).

Instale as ferramentas uma vez:
```powershell
Install-Module PSScriptAnalyzer -Scope CurrentUser
Install-Module Pester -Scope CurrentUser -SkipPublisherCheck
```

## Padrão dos arquivos

```
modulos/NN-nome/
├── README.md                    # teoria: o PORQUÊ antes do COMO
├── exemplos/
│   └── NN-nome.ps1              # executável, muito comentado, roda sozinho
└── exercicios/
    ├── README.md               # enunciados
    ├── NN-nome.ps1             # esqueleto do aluno
    ├── solucoes/NN-nome.ps1    # solução oficial comentada
    └── testes/NN-nome.Testes.ps1  # casos de teste (funções Teste-*)
```

### Cabeçalho obrigatório em todo `.ps1`
```powershell
<#
============================================================================
  Curso de PowerShell · Módulo NN · <título>
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  ...
  EXECUTE   ...
============================================================================
#>
```

### Regras de ouro para exemplos
- **Devem rodar sem argumentos** e sem travar (`$ErrorActionPreference = 'Stop'` é bom hábito).
- **Não podem alterar o sistema**: usem `New-TemporaryFile`/`$env:TEMP` e limpem com `try/finally`.
- Comentários explicam o **porquê**, não só o quê.
- Zero avisos do PSScriptAnalyzer (ou uma supressão `[Diagnostics.CodeAnalysis.SuppressMessage(...)]` justificada).
- Prefira `Write-Output` para **dados**; `Write-Host` só para interface no console (a "regra do Write-Host" é tema do Módulo 03).

### Escrevendo um teste
Toda função `Teste-*` em um arquivo `.Testes.ps1` é descoberta e rodada isoladamente. As asserções estão em [`ferramentas/lib/Teste.psm1`](ferramentas/lib/Teste.psm1):

```powershell
function Teste-DescricaoCurta {
    Invoke-Alvo arg1 arg2         # roda o script do aluno
    Afirmar-Status 0
    Afirmar-Igual "esperado" $global:SAIDA
    Afirmar-Contem "trecho" $global:SAIDA
}
```

> Usamos um mini-framework próprio para a correção (zero instalação). O **Pester** — padrão de mercado — é ensinado no [Módulo 10](modulos/10-testes-seguranca-devops/) e usado nos testes dos módulos avançados (`*.Tests.ps1`).

## Fluxo do Pull Request

1. Fork e branch: `git checkout -b meu-ajuste`
2. Mudanças seguindo o padrão
3. `./ferramentas/verificar-tudo.ps1` — tudo verde
4. Commit claro em português
5. Abra o PR descrevendo **o quê** e **por quê**

## Estilo de PowerShell adotado

- Cmdlets por extenso (nada de aliases como `ls`/`gci` em scripts) e **Verbo-Substantivo**
- `Set-StrictMode -Version Latest` e `$ErrorActionPreference = 'Stop'` em scripts sérios
- `[CmdletBinding()]` e parâmetros tipados em funções
- `Write-Output`/`Write-Verbose` para dados; `Write-Host` só para UI
- `-WhatIf`/`-Confirm` em qualquer coisa que altere estado

## Código de conduta

Seja gentil. Veja [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).

<sub>© 2026 Prof. Daniel Santos</sub>
