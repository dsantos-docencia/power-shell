# 🏢 Projeto 05 — Módulo Corporativo

O capstone do [Módulo 11](../../modulos/11-modulos-e-distribuicao/): um módulo **empacotado de verdade** — `Iconne.Infra` — com `.psm1`, manifesto `.psd1`, funções públicas e uma privada encapsulada, pronto para `Import-Module` em qualquer script da casa. Vem com testes **Pester** completos.

## Estrutura

```
05-modulo-corporativo/
├── Iconne.Infra/
│   ├── Iconne.Infra.psm1    # código: 3 funções públicas + 1 privada
│   └── Iconne.Infra.psd1    # manifesto (versão, autor, exports)
├── demo.ps1                 # importa e usa o módulo
└── Iconne.Infra.Tests.ps1   # testes Pester (10 casos)
```

## Como usar

```powershell
Import-Module ./Iconne.Infra/Iconne.Infra.psd1
Convert-ParaTamanhoLegivel -Bytes 1048576   # "1.0 MB"
Test-NomeRecurso -Nome 'srv-web01'          # True
New-IdRecurso -Prefixo 'vm'                 # "vm-a1b2c3"

pwsh ./demo.ps1                              # demonstração completa
Invoke-Pester ./Iconne.Infra.Tests.ps1       # roda os testes do módulo
```

## Conceitos aplicados

- Módulo `.psm1` + manifesto `.psd1` gerado com `New-ModuleManifest`
- `Export-ModuleMember` expondo **só** o que é público (a ajudante fica privada)
- `[OutputType]`, comment-based help (`.SYNOPSIS`/`.EXAMPLE`) em cada função
- Suíte **Pester** cobrindo sucesso, erro e encapsulamento

## Testes

```powershell
pwsh ./ferramentas/verificar-tudo.ps1   # Pester + corretor do curso
```

<sub>© 2026 Prof. Daniel Santos · Código [PolyForm NC](../../LICENSE) · Conteúdo [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md)</sub>
