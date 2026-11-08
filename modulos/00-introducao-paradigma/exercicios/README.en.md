# 🏋️ Exercises — Module 00

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*
>
> ⚠️ **The expected outputs below are kept in Portuguese on purpose** — the automated grader checks them literally, so your script must print exactly those strings to pass.

Edit the `.ps1` files in this folder and grade with:
```powershell
./ferramentas/corrigir.ps1 00        # all
./ferramentas/corrigir.ps1 00 01     # only 01
```
Stuck? Commented solutions in [solucoes/](solucoes/). Try for at least 15 min first.

### 01 — Hello, world · `01-ola.ps1`
Make the script print exactly:
```
Olá, mundo!
```

### 02 — Version in two parts · `02-versao.ps1`
Using `$PSVersionTable.PSVersion` (the `.Major` and `.Minor` properties), print:
```
PowerShell 7.4
```
(with **your** version's numbers). Don't use a fixed string — read it from the object.

### 03 — Command classifier · `03-tipo-comando.ps1`
Receives **one** command name in `$Nome` (parameter) and prints its `CommandType` (e.g., `Cmdlet`, `Function`, `Alias`). If the command doesn't exist, print `desconhecido` and exit with code `1`.
```powershell
PS> pwsh ./03-tipo-comando.ps1 -Nome Get-ChildItem   # -> Cmdlet
PS> pwsh ./03-tipo-comando.ps1 -Nome naoexiste        # -> desconhecido (exit 1)
```

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
