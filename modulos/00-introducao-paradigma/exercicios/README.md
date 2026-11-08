# 🏋️ Exercícios — Módulo 00

Edite os `.ps1` desta pasta e corrija com:
```powershell
./ferramentas/corrigir.ps1 00        # todos
./ferramentas/corrigir.ps1 00 01     # só o 01
```
Travou? Soluções comentadas em [solucoes/](solucoes/). Tente ao menos 15 min antes.

### 01 — Olá, mundo · `01-ola.ps1`
Faça o script imprimir exatamente:
```
Olá, mundo!
```

### 02 — Versão em duas partes · `02-versao.ps1`
Usando `$PSVersionTable.PSVersion` (propriedades `.Major` e `.Minor`), imprima:
```
PowerShell 7.4
```
(com os números da **sua** versão). Não use texto fixo — leia do objeto.

### 03 — Classificador de comando · `03-tipo-comando.ps1`
Recebe **um** nome de comando em `$Nome` (parâmetro) e imprime o `CommandType` dele (ex.: `Cmdlet`, `Function`, `Alias`). Se o comando não existir, imprima `desconhecido` e termine com código de saída `1`.
```powershell
PS> pwsh ./03-tipo-comando.ps1 -Nome Get-ChildItem   # -> Cmdlet
PS> pwsh ./03-tipo-comando.ps1 -Nome naoexiste        # -> desconhecido (exit 1)
```
