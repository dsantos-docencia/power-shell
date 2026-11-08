# Módulo 02 — O Pipeline de Objetos

> *"Este é o módulo que transforma você. Se o pipeline de objetos faz sentido, PowerShell faz sentido."*

**Carga sugerida:** 8–10 h · **Nível:** iniciante+ · **Pré-requisito:** [Módulo 01](../01-navegacao-cmdlets/)

## 🎯 Objetivos

- Entender como **objetos** (não texto) fluem pelo pipeline `|`
- Dominar o cmdlet mais importante de todos: **`Get-Member`**
- Filtrar com `Where-Object`, selecionar com `Select-Object`, ordenar com `Sort-Object`
- Agrupar e medir com `Group-Object` e `Measure-Object`
- Formatar a saída (`Format-Table`/`Format-List`) — e a **regra de ouro** dos `Format-*`
- Exportar para JSON, CSV e XML

---

## 1. O pipeline passa objetos, não texto

No Bash, `comando1 | comando2` passa o **texto** que o `comando1` imprimiu. No PowerShell, `|` passa os **objetos** que o `comando1` produziu — inteiros, com propriedades e métodos.

```powershell
Get-Process | Where-Object CPU -gt 10 | Sort-Object CPU -Descending | Select-Object Name, CPU
#    objetos        filtra pela          ordena pela              escolhe 2
#    de processo    PROPRIEDADE CPU      PROPRIEDADE CPU          propriedades
```

Cada `|` entrega objetos ao próximo cmdlet, que mexe nas **propriedades** — nunca recortando texto. É por isso que não importa o idioma do sistema, a largura da tela ou o formato: o objeto é o mesmo.

---

## 2. `Get-Member`: o cmdlet mais importante do PowerShell

Se você só puder lembrar de **um** cmdlet, que seja `Get-Member` (alias `gm`). Ele responde: *"o que este objeto tem? O que posso fazer com ele?"*

```powershell
Get-Process | Get-Member
# mostra TODAS as propriedades (Name, Id, CPU, WorkingSet...) e métodos (Kill()...)
```

```powershell
Get-ChildItem | Get-Member -MemberType Property    # só as propriedades
(Get-Date) | Get-Member -MemberType Method          # só os métodos
```

> 💡 **O segredo do PowerShell não é decorar cmdlets — é inspecionar objetos.** Fluxo: rode um cmdlet → mande para `Get-Member` → descubra as propriedades → use-as no `Select-Object`/`Where-Object`. Com isso você resolve qualquer coisa sem precisar "saber de cabeça".

---

## 3. Filtrar: `Where-Object`

Mantém só os objetos que passam numa condição.

```powershell
# Sintaxe simplificada (PS3+), legível para comparações simples:
Get-ChildItem | Where-Object Length -gt 1kb

# Sintaxe com bloco de script { }, para condições complexas ($_ = objeto atual):
Get-ChildItem | Where-Object { $_.Length -gt 1kb -and $_.Extension -eq '.log' }
```

A variável automática **`$_`** (ou `$PSItem`) é "o objeto atual do pipeline". Dentro do `{ }`, você acessa suas propriedades com `$_.Propriedade`.

| Operador | Significa |
|---|---|
| `-eq` `-ne` | igual / diferente |
| `-gt` `-ge` `-lt` `-le` | maior / maior-igual / menor / menor-igual |
| `-like` | curinga (`*`, `?`): `-like '*.log'` |
| `-match` | expressão regular |
| `-in` `-contains` | pertence a uma coleção |

> ⚠️ Comparações são **case-insensitive** por padrão. Para diferenciar maiúsc/minúsc, prefixe com `c`: `-ceq`, `-clike`, `-cmatch`.

---

## 4. Selecionar: `Select-Object`

Escolhe **quais propriedades** manter, ou quantos objetos.

```powershell
Get-Process | Select-Object Name, Id, CPU          # só essas 3 propriedades
Get-Process | Select-Object -First 5               # os 5 primeiros
Get-Process | Select-Object -Last 3                # os 3 últimos
Get-ChildItem | Select-Object -ExpandProperty Name # só os valores de Name (strings puras)
Get-Process | Select-Object -Unique                # remove duplicatas
```

**Propriedades calculadas** — criar uma propriedade na hora, com uma hashtable `@{Name=...; Expression={...}}`:
```powershell
Get-ChildItem | Select-Object Name, @{Name='KB'; Expression={ [math]::Round($_.Length / 1kb, 1) }}
#                                    └ nome da nova coluna   └ como calculá-la (do objeto atual $_)
```

---

## 5. Ordenar, agrupar, medir

```powershell
Get-Process | Sort-Object CPU -Descending               # ordena pela propriedade
Get-ChildItem | Sort-Object Length -Descending | Select-Object -First 3   # top 3 maiores

Get-ChildItem | Group-Object Extension                   # agrupa por extensão
# conta quantos arquivos de cada extensão há

Get-ChildItem -File | Measure-Object Length -Sum -Average -Maximum
# soma, média e máximo do tamanho — estatística pronta
```

> 💡 `Group-Object` + `Measure-Object` substituem relatórios inteiros que no Bash exigiriam `sort | uniq -c | awk`. E o resultado são **objetos**, prontos para o próximo passo.

---

## 6. Formatar: a Regra de Ouro

Os cmdlets `Format-*` deixam a saída bonita para o **humano** — mas transformam os objetos em instruções de formatação. Por isso:

> 🔴 **REGRA DE OURO: os `Format-*` são sempre os ÚLTIMOS da linha.** Depois de um `Format-Table`, o que corre no pipe não são mais seus objetos — é "texto de formatação". Qualquer cmdlet depois dele (um `Where-Object`, um `Export-Csv`) vai se perder.

```powershell
Get-Process | Sort-Object CPU -Descending | Format-Table Name, CPU   # ✔ Format-* por último
Get-Process | Format-Table | Where-Object CPU -gt 10                 # ✘ NUNCA — quebra
```

| Cmdlet | Mostra |
|---|---|
| `Format-Table` (`ft`) | tabela (colunas) — bom para muitos objetos com poucas propriedades |
| `Format-List` (`fl`) | lista (uma propriedade por linha) — bom para ver tudo de um objeto |
| `Format-Wide` (`fw`) | uma propriedade só, em várias colunas |

---

## 7. Exportar e converter

Aqui o modelo de objetos brilha: como os dados são estruturados, converter é trivial.

```powershell
Get-Process | Select-Object Name, Id, CPU | Export-Csv -Path proc.csv -NoTypeInformation
Get-Process | Select-Object Name, Id | ConvertTo-Json
Get-ChildItem | Export-Clixml -Path itens.xml      # serialização que PRESERVA o objeto
$dados = Import-Csv -Path proc.csv                 # lê de volta como objetos
```

| Para… | Use |
|---|---|
| planilha / outro sistema | `Export-Csv -NoTypeInformation` |
| API / configuração | `ConvertTo-Json` / `ConvertFrom-Json` |
| guardar e restaurar o objeto PowerShell | `Export-Clixml` / `Import-Clixml` |
| ver numa janela gráfica (Windows) | `Out-GridView` |

> 💡 `ConvertTo-Json` + `Invoke-RestMethod` (Módulo 09) é a dupla para falar com APIs REST. O PowerShell transforma o JSON da resposta em **objetos** navegáveis automaticamente.

---

## 🧪 Exemplos deste módulo

| Arquivo | Demonstra |
|---|---|
| [01-get-member.ps1](exemplos/01-get-member.ps1) | Inspecionar objetos: propriedades e métodos — a habilidade-chave |
| [02-filtrar-selecionar-ordenar.ps1](exemplos/02-filtrar-selecionar-ordenar.ps1) | `Where/Select/Sort` + propriedade calculada, sobre arquivos reais |
| [03-agrupar-e-exportar.ps1](exemplos/03-agrupar-e-exportar.ps1) | `Group-Object`, `Measure-Object` e exportar para JSON/CSV |

## ⚠️ Armadilhas do módulo

- Pôr um cmdlet **depois** de um `Format-*` (a regra de ouro)
- Esquecer que comparações são case-insensitive (use `-ceq` quando precisar)
- Tentar recortar texto da saída em vez de usar `Select-Object`/propriedades
- `Export-Csv` sem `-NoTypeInformation` (gera uma linha de cabeçalho `#TYPE` indesejada — no PS7 já é o padrão omitir, mas confirme)

## 🏋️ Exercícios

Veja [exercicios/README.md](exercicios/README.md). Corrija com `./ferramentas/corrigir.ps1 02`.

## ✅ Checklist de domínio

- [ ] Explico por que o pipeline passa objetos, não texto
- [ ] Uso `Get-Member` para descobrir o que um objeto tem
- [ ] Encadeio `Where-Object | Sort-Object | Select-Object` com naturalidade
- [ ] Crio uma propriedade calculada com `@{Name=...; Expression={...}}`
- [ ] Sei a regra de ouro dos `Format-*` e exporto para JSON/CSV

---

⬅️ [Módulo 01](../01-navegacao-cmdlets/README.md) · ➡️ [Módulo 03 — Scripting e Variáveis](../03-scripting-variaveis/README.md)

<sub>© 2026 Prof. Daniel Santos · Texto sob [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Código sob [PolyForm NC](../../LICENSE)</sub>
