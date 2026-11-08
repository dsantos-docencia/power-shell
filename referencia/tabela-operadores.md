# ⚙️ Tabela de operadores do PowerShell

**🌍 Idioma / Language:** **Português** · [English](tabela-operadores.en.md)

No PowerShell, comparação **não** usa `>` `<` `==` (o `>` é redirecionamento!). Usa operadores com `-`. Veja os [Módulos 03](../modulos/03-scripting-variaveis/) e [04](../modulos/04-controle-de-fluxo/).

## Comparação

| Operador | Significa | Exemplo → resultado |
|---|---|---|
| `-eq` | igual | `5 -eq 5` → `$true` |
| `-ne` | diferente | `5 -ne 3` → `$true` |
| `-gt` `-ge` | maior / maior ou igual | `5 -gt 3` → `$true` |
| `-lt` `-le` | menor / menor ou igual | `3 -lt 5` → `$true` |
| `-like` | curinga (`*`, `?`) | `'gato' -like 'g*'` → `$true` |
| `-notlike` | negação do like | |
| `-match` | casa expressão regular (e preenche `$matches`) | `'abc123' -match '\d+'` → `$true` |
| `-notmatch` | não casa a regex | |
| `-contains` | a coleção contém o item | `@(1,2,3) -contains 2` → `$true` |
| `-in` | o item está na coleção | `2 -in @(1,2,3)` → `$true` |
| `-replace` | substitui por regex | `'a1b2' -replace '\d','#'` → `a#b#` |

> ⚠️ **Case-insensitive por padrão.** `'ABC' -eq 'abc'` é `$true`. Para diferenciar maiúsc/minúsc, prefixe com `c`: `-ceq`, `-clike`, `-cmatch`. Há o `i` explícito também (`-ieq`).

> ⚠️ **`-eq` com um array FILTRA em vez de comparar.** `@(1,2,3,2) -eq 2` devolve `@(2,2)`, não `$true`. Para pertencimento use `-contains`/`-in`. Para comparar com `$null`, ponha o `$null` à **esquerda**: `$null -eq $x`.

## Lógicos

| Operador | Significa |
|---|---|
| `-and` | E |
| `-or` | OU |
| `-not` ou `!` | NÃO |
| `-xor` | ou exclusivo |

```powershell
if ($idade -ge 18 -and $idade -lt 65) { 'adulto' }
if (-not (Test-Path $arq)) { 'não existe' }
```

## Aritméticos

| Operador | Faz |
|---|---|
| `+` `-` `*` `/` | soma, subtração, multiplicação, divisão |
| `%` | resto (módulo) |
| `[math]::Pow(b,e)` | potência (não há `**`) |
| `++` `--` | incremento / decremento |

```powershell
7 % 3            # 1
[math]::Pow(2,10)   # 1024
$i++
```

## Multiplicadores de tamanho

O PowerShell entende sufixos de tamanho direto:
```powershell
1KB     # 1024
5MB     # 5242880
2GB     # 2147483648
1TB  1PB
```

## Tipo e verificação

| Operador | Faz |
|---|---|
| `-is` | é do tipo? | `'x' -is [string]` → `$true` |
| `-isnot` | não é do tipo? |
| `-as` | converte para o tipo (ou `$null`) | `'10' -as [int]` → `10` |

## Outros úteis

| Operador | Faz |
|---|---|
| `..` | intervalo | `1..5` → `1 2 3 4 5` |
| `-f` | formata (como `printf`) | `'{0,-8} {1:N2}' -f 'café', 4.5` |
| `-join` | junta uma coleção | `@(1,2,3) -join '-'` → `1-2-3` |
| `-split` | divide (regex) | `'a,b,c' -split ','` |
| `-split`/`-join` como unários | — |
| `&` | operador de chamada | `& $nomeCmd args` |
| `.` | operador de ponto (roda no escopo atual) | `. ./script.ps1` |

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
