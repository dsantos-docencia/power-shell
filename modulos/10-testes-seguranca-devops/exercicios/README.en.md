# 🏋️ Exercises — Module 10

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Found a slip? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues).*

Grade with `./ferramentas/corrigir.ps1 10`. Solutions in [solucoes/](solucoes/).
Theme: **validate inputs, guard secrets, and automate releases** — the tripod of testing, security, and DevOps.

### 01 — Validated input · `01-validar-faixa.ps1`
Receives `[int]$N` and prints the **double**, but only accepts values from **1 to 100**. Let the validation engine itself (`[ValidateRange(1,100)]`) reject the rest — don't write a validation `if`. E.g.: `-N 5` → `10`; `-N 999` → error.
> Hint: validation goes on the parameter, not in the body. Less code, more guarantee.

### 02 — Mask a secret · `02-mascarar-segredo.ps1`
Receives `[string]$Texto` and returns everything replaced by `*`, except the **last 4** characters. For 4 characters or fewer, returns it unchanged. E.g.: `"token12345"` → `"******2345"`.
> Hint: `Substring`, string repetition with `'*' * n`, and concatenation.

### 03 — Bump the version · `03-bump-versao.ps1`
Receives a semver `"MAJOR.MINOR.PATCH"` and prints the version with **patch +1** — the classic step of an automated release. E.g.: `"1.2.3"` → `"1.2.4"`.
> Hint: `Split('.')`, convert the patch to `[int]`, add 1, and join with `-join '.'`.

---
In this module's **examples** you saw the other side: tests with **Pester** (`calculadora.Tests.ps1`), **static analysis** with PSScriptAnalyzer, and **credentials** with `PSCredential`/`SecureString`. Run `Invoke-Pester` in the examples folder to see the tests passing.

<sub>© 2026 Prof. Daniel Santos and translators · [CC BY-NC-SA 4.0](../../../LICENSE-CONTEUDO.md) · [PolyForm NC](../../../LICENSE)</sub>
