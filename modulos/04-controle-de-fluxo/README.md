# Módulo 04 — Controle de Fluxo

> *"Decidir e repetir. E uma escolha que muda a performance dos seus scripts: `foreach` ou `ForEach-Object`?"*

**Carga sugerida:** 8–10 h · **Nível:** intermediário · **Pré-requisito:** [Módulo 03](../03-scripting-variaveis/)

## 🎯 Objetivos

- Tomar decisões com `if`/`elseif`/`else` e o **`switch` turbinado** do PowerShell
- Repetir com `for`, `foreach`, `while`, `do-while`/`do-until`
- Entender a diferença **crucial** entre `foreach` (instrução) e `ForEach-Object` (pipeline)
- Controlar laços com `break`, `continue`, `return`
- Usar o operador ternário (PowerShell 7+)

---

## 1. Condicionais

```powershell
if ($idade -ge 18) {
    "maior de idade"
} elseif ($idade -ge 12) {
    "adolescente"
} else {
    "criança"
}
```

A condição fica **obrigatoriamente entre parênteses** `( )` e o bloco entre chaves `{ }`.

**Operador ternário** (PowerShell 7+):
```powershell
$status = $idade -ge 18 ? "adulto" : "menor"
```

---

## 2. O `switch` turbinado

O `switch` do PowerShell é muito mais poderoso que o de outras linguagens.

```powershell
switch ($valor) {
    1 { "um" }
    2 { "dois" }
    default { "outro" }
}
```

**Diferenças importantes:**

```powershell
# -Wildcard: compara com curingas
switch -Wildcard ($arquivo) {
    '*.jpg' { "imagem" }
    '*.log' { "registro" }
}

# -Regex: compara com expressões regulares (e $matches fica disponível)
switch -Regex ($texto) {
    '^\d+$'     { "só números" }
    '[A-Z]'     { "tem maiúscula" }
}

# SEM break, ele testa TODOS os padrões (pode casar vários!):
switch ('abc123') {
    { $_ -match '[a-z]' } { "tem letra" }
    { $_ -match '\d' }    { "tem número" }
    # imprime AS DUAS, porque não há break automático
}
```

> 💡 O `switch` aceita **blocos de condição** `{ $_ -match ... }`, aceita arrays (testa cada elemento) e aceita `-File` para processar um arquivo linha a linha. É quase uma linguagem dentro da linguagem. Por padrão **não há `break`** — adicione `break` se quiser parar no primeiro match.

---

## 3. Laços

### `for` — contador clássico
```powershell
for ($i = 0; $i -lt 5; $i++) {
    Write-Output "i = $i"
}
```

### `foreach` (instrução) — itera uma coleção
```powershell
foreach ($fruta in @('maçã', 'banana', 'uva')) {
    Write-Output $fruta
}
```

### `while` e `do`
```powershell
$i = 0
while ($i -lt 3) { $i++ }

do { $i-- } while ($i -gt 0)      # executa ao menos uma vez
do { $i++ } until ($i -ge 3)      # repete ATÉ a condição virar verdadeira
```

### `break`, `continue`, `return`
```powershell
foreach ($n in 1..10) {
    if ($n -eq 5) { continue }    # pula o 5
    if ($n -eq 8) { break }       # para no 8
    Write-Output $n
}
```
> 💡 `1..10` é o **operador de intervalo**: gera a sequência de 1 a 10. `10..1` conta ao contrário.

---

## 4. `foreach` vs. `ForEach-Object` — a diferença que importa

Existem **dois** "foreach" no PowerShell, e confundi-los custa performance:

| | `foreach ($x in $col) { }` | `$col | ForEach-Object { }` |
|---|---|---|
| O que é | **instrução** de linguagem | **cmdlet** de pipeline (alias `%`) |
| Como processa | carrega a coleção **inteira** na memória, depois itera | processa **um objeto por vez** (streaming) |
| Variável do item | o nome que você deu (`$x`) | `$_` / `$PSItem` |
| Mais rápido para | coleções já na memória, tamanho conhecido | **pipelines**, grandes volumes, dados que chegam aos poucos |
| Blocos | — | `-Begin`, `-Process`, `-End` |

```powershell
# instrução foreach: rápido quando os dados já estão numa variável
$arquivos = Get-ChildItem
foreach ($a in $arquivos) { $a.Name }

# ForEach-Object: ideal em pipeline, processa à medida que recebe
Get-ChildItem | ForEach-Object { $_.Name }
```

> 💡 **Regra prática:** se os dados **já estão numa variável** e você sabe que cabem na memória, `foreach` (instrução) costuma ser mais rápido. Se você está **no meio de um pipeline** ou processando um **volume grande/contínuo** (um log enorme, saída de um comando remoto), `ForEach-Object` processa em streaming e não estoura a memória. Medir com `Measure-Command` tira a dúvida (veja o exemplo 03).

> 💡 **"Pipeline first":** pense em pipeline antes de pensar em laço. Em vez de um `for` para filtrar arquivos, prefira `Get-ChildItem | Where-Object ... | ForEach-Object ...`. É mais legível e idiomático.

---

## 🧪 Exemplos deste módulo

| Arquivo | Demonstra |
|---|---|
| [01-if-switch.ps1](exemplos/01-if-switch.ps1) | `if`/`elseif`, ternário e o `switch` com `-Wildcard`/`-Regex` |
| [02-loops.ps1](exemplos/02-loops.ps1) | `for`, `foreach`, `while`, `do-until`, `break`/`continue`, `1..10` |
| [03-foreach-vs-foreachobject.ps1](exemplos/03-foreach-vs-foreachobject.ps1) | A diferença e uma medição com `Measure-Command` |

## ⚠️ Armadilhas do módulo

- Esquecer que o `switch` **não** tem `break` automático (casa vários padrões)
- Confundir `foreach` (instrução) com `ForEach-Object` (pipeline) e perder performance
- Usar `$_` dentro de um `foreach` de instrução (lá a variável é a que você nomeou)
- Usar laço onde um `Where-Object`/`ForEach-Object` seria mais claro

## 🏋️ Exercícios

Veja [exercicios/README.md](exercicios/README.md). Corrija com `./ferramentas/corrigir.ps1 04`.

## ✅ Checklist de domínio

- [ ] Uso `if`/`elseif`/`else` e o ternário `? :`
- [ ] Exploro o `switch` com `-Wildcard`/`-Regex` e sei que não há break automático
- [ ] Escrevo `for`/`foreach`/`while`/`do` e uso `1..N`
- [ ] Explico `foreach` vs `ForEach-Object` e escolho pela situação
- [ ] Penso "pipeline first"

---

⬅️ [Módulo 03](../03-scripting-variaveis/README.md) · ➡️ [Módulo 05 — Funções e Toolmaking](../05-funcoes-toolmaking/README.md)

<sub>© 2026 Prof. Daniel Santos · Texto sob [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Código sob [PolyForm NC](../../LICENSE)</sub>
