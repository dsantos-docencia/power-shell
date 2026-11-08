# 🧪 Laboratório em container

Um ambiente **isolado, descartável e idêntico para todos**, com PowerShell 7, PSScriptAnalyzer e Pester já instalados.

## Pré-requisito
[Docker](https://docs.docker.com/get-docker/).

## Uso
```bash
./laboratorio/entrar.sh
```
Na primeira vez a imagem é construída; depois é instantâneo. Você cai num `pwsh` com o repositório montado em `/curso`:
```console
PS /curso> ./ferramentas/corrigir.ps1 00
PS /curso> ./ferramentas/verificar-tudo.ps1
PS /curso> exit
```

## Sem Docker?
Instale o [PowerShell 7](https://learn.microsoft.com/powershell/scripting/install/installing-powershell) e rode o curso direto. O container é só conveniência.

<sub>© 2026 Prof. Daniel Santos · PolyForm NC (não comercial)</sub>
