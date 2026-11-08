# 🧪 Containerized Lab

**🌍 Language / Idioma:** **English** · [Português](README.md)

An **isolated, disposable, identical-for-everyone** environment, with PowerShell 7, PSScriptAnalyzer, and Pester already installed.

## Prerequisite
[Docker](https://docs.docker.com/get-docker/).

## Usage
```bash
./laboratorio/entrar.sh
```
The first time, the image is built; after that it's instant. You land in a `pwsh` with the repository mounted at `/curso`:
```console
PS /curso> ./ferramentas/corrigir.ps1 00
PS /curso> ./ferramentas/verificar-tudo.ps1
PS /curso> exit
```

## No Docker?
Install [PowerShell 7](https://learn.microsoft.com/powershell/scripting/install/installing-powershell) and run the course directly. The container is just convenience.

<sub>© 2026 Prof. Daniel Santos · PolyForm NC (noncommercial)</sub>
