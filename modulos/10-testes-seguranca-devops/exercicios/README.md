# 🏋️ Exercícios — Módulo 10

Corrija com `./ferramentas/corrigir.ps1 10`. Soluções em [solucoes/](solucoes/).
Tema: **validar entradas, cuidar de segredos e automatizar release** — o tripé de testes, segurança e DevOps.

### 01 — Entrada validada · `01-validar-faixa.ps1`
Recebe `[int]$N` e imprime o **dobro**, mas só aceita valores de **1 a 100**. Deixe o próprio motor de validação (`[ValidateRange(1,100)]`) rejeitar o resto — não escreva `if` de validação. Ex.: `-N 5` → `10`; `-N 999` → erro.
> Dica: a validação vai no parâmetro, não no corpo. Menos código, mais garantia.

### 02 — Mascarar segredo · `02-mascarar-segredo.ps1`
Recebe `[string]$Texto` e devolve tudo trocado por `*`, exceto os **4 últimos** caracteres. Até 4 caracteres, devolve igual. Ex.: `"token12345"` → `"******2345"`.
> Dica: `Substring`, repetição de string com `'*' * n` e concatenação.

### 03 — Subir versão · `03-bump-versao.ps1`
Recebe um semver `"MAJOR.MINOR.PATCH"` e imprime a versão com o **patch +1** — o passo clássico de um release automatizado. Ex.: `"1.2.3"` → `"1.2.4"`.
> Dica: `Split('.')`, converta o patch para `[int]`, some 1 e junte com `-join '.'`.

---
Nos **exemplos** deste módulo você viu o outro lado: testes com **Pester** (`calculadora.Tests.ps1`), **análise estática** com PSScriptAnalyzer e **credenciais** com `PSCredential`/`SecureString`. Rode `Invoke-Pester` na pasta de exemplos para ver os testes passando.
