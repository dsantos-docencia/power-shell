# Módulo 06 — Dados e Objetos

> *"A base de qualquer relatório moderno em PowerShell é o `[PSCustomObject]`. Dominar coleções e objetos é dominar os dados."*

**Carga sugerida:** 8–10 h · **Nível:** intermediário+ · **Pré-requisito:** [Módulo 05](../05-funcoes-toolmaking/)

## 🎯 Objetivos

- Trabalhar com **arrays** e **hashtables** (dicionários) — e evitar a armadilha do `+=`
- Criar objetos estruturados com **`[PSCustomObject]`**
- Manipular strings com métodos .NET e operadores (`-split`, `-join`, `-replace`, `-f`)
- Converter de/para **JSON, CSV e XML**

---

## 1. Arrays

```powershell
$arr = @(1, 2, 3)              # array
$arr = 1, 2, 3                 # o mesmo (a vírgula cria array)
$arr[0]                        # primeiro (índice começa em 0)
$arr[-1]                       # último
$arr[1..2]                     # fatia (índices 1 e 2)
$arr.Count                     # quantidade
$arr += 4                      # "acrescenta"... veja a armadilha abaixo
```

> ⚠️ **A armadilha do `+=` em laços (O(n²)).** Arrays em PowerShell têm **tamanho fixo**. `$arr += $x` **não** acrescenta: ele cria um array **novo**, copia tudo e adiciona o item. Num laço grande, isso fica lento quadraticamente (copia n vezes um array que cresce). Para acumular em laços, use uma **lista** `[System.Collections.Generic.List[T]]`:
> ```powershell
> $lista = [System.Collections.Generic.List[int]]::new()
> foreach ($n in 1..100000) { $lista.Add($n) }   # rápido: adiciona no lugar
> ```
> Ou **colete pelo pipeline** (idiomático): `$resultado = 1..100000 | ForEach-Object { $_ * 2 }`. O `Measure-Command` escancara a diferença (veja o exemplo 01).

## 2. Hashtables (dicionários)

Pares chave→valor, com acesso instantâneo pela chave.

```powershell
$pessoa = @{ Nome = 'Ana'; Idade = 30 }
$pessoa['Nome']               # Ana
$pessoa.Idade                 # 30 (também funciona com ponto)
$pessoa['Email'] = 'a@x.com'  # adiciona/atualiza
$pessoa.Keys                  # as chaves
$pessoa.ContainsKey('Nome')   # $true
```

> 💡 Hashtables são ótimas para **contar** (histogramas), **mapear** (de→para) e **configurar**. Diferente do array, adicionar a uma hashtable é barato. Para manter a **ordem** de inserção, use `[ordered]@{ ... }`.

## 3. `[PSCustomObject]` — a estrela dos relatórios

Cria um objeto com propriedades nomeadas. É assim que você produz dados estruturados "do zero" — a base de todo relatório e de toda função que devolve objetos (Módulo 05).

```powershell
$usuario = [pscustomobject]@{
    Nome   = 'Daniel'
    Papel  = 'admin'
    Ativo  = $true
}
$usuario.Nome                 # Daniel
$usuario | Get-Member         # é um objeto de verdade, inspecionável

# Uma COLEÇÃO de PSCustomObject vira uma "tabela" pronta para pipeline/export:
$relatorio = @(
    [pscustomobject]@{ Servico = 'web';   Status = 'ok'    }
    [pscustomobject]@{ Servico = 'db';    Status = 'parado' }
)
$relatorio | Where-Object Status -eq 'parado'    # filtra como qualquer objeto
$relatorio | Export-Csv relatorio.csv -NoTypeInformation
```

> 💡 Por que não hashtable? Porque `[PSCustomObject]` passa pelo pipeline como um objeto com propriedades reais — `Select-Object`, `Where-Object`, `Sort-Object`, `Export-Csv` e `Format-Table` funcionam perfeitamente. Hashtable é para lookup; PSCustomObject é para **dados tabulares**.

## 4. Manipulação de strings

Strings são objetos .NET — têm métodos — e o PowerShell ainda adiciona operadores.

```powershell
$t = '  Daniel Santos  '
$t.Trim()                     # 'Daniel Santos' (remove espaços das pontas)
$t.ToUpper()                  # '  DANIEL SANTOS  '
$t.Replace('Santos', 'Silva') # método .NET
'a,b,c'.Split(',')            # array @('a','b','c') — método .NET
```

Operadores do PowerShell (mais poderosos, com regex):
```powershell
'a,b,c' -split ','            # divide (aceita regex)
@('a','b','c') -join '-'      # 'a-b-c'
'teste123' -replace '\d', '#' # 'teste###' (regex)
'{0} tem {1} anos' -f 'Ana', 30   # formatação
```

| Operador | Faz | vs. método |
|---|---|---|
| `-split` | divide (regex) | `.Split()` é literal, mais simples |
| `-join` | junta uma coleção | — |
| `-replace` | substitui (regex) | `.Replace()` é literal |
| `-f` | formata | — |

## 5. JSON, CSV e XML

A natureza de objetos torna a conversão trivial.

```powershell
# JSON (ótimo para APIs e config)
$obj | ConvertTo-Json -Depth 5
'{ "nome": "Ana", "idade": 30 }' | ConvertFrom-Json    # vira objeto navegável

# CSV (planilhas, outros sistemas)
$dados | Export-Csv -Path saida.csv -NoTypeInformation
$lidos = Import-Csv -Path saida.csv                     # vira coleção de objetos

# XML
[xml]$doc = '<raiz><item>1</item><item>2</item></raiz>'
$doc.raiz.item                                          # navega como objeto
```

> 💡 `ConvertFrom-Json` e `Import-Csv` devolvem **objetos** — você já sai filtrando com `Where-Object` e selecionando com `Select-Object`. É o ciclo do PowerShell: trazer dados de qualquer formato → virar objeto → manipular no pipeline.

---

## 🧪 Exemplos deste módulo

| Arquivo | Demonstra |
|---|---|
| [01-colecoes.ps1](exemplos/01-colecoes.ps1) | Arrays, a armadilha do `+=` vs `List[T]`, hashtables |
| [02-pscustomobject.ps1](exemplos/02-pscustomobject.ps1) | Construir objetos e relatórios tabulares |
| [03-strings-e-formatos.ps1](exemplos/03-strings-e-formatos.ps1) | `-split`/`-join`/`-replace`/`-f` e JSON/CSV |

## ⚠️ Armadilhas do módulo

- `$arr += $x` dentro de um laço grande (O(n²)) — use `List[T]` ou colete no pipeline
- Usar hashtable onde `[PSCustomObject]` (dados tabulares) seria o certo
- Confundir `-split`/`-replace` (regex) com `.Split()`/`.Replace()` (literal)
- `ConvertTo-Json` sem `-Depth` suficiente (corta objetos aninhados; padrão é 2)

## 🏋️ Exercícios

Veja [exercicios/README.md](exercicios/README.md). Corrija com `./ferramentas/corrigir.ps1 06`.

## ✅ Checklist de domínio

- [ ] Sei por que `+=` em array é lento e uso `List[T]` ou o pipeline
- [ ] Uso hashtables para lookup e `[PSCustomObject]` para dados tabulares
- [ ] Manipulo strings com `-split`/`-join`/`-replace`/`-f`
- [ ] Converto de/para JSON e CSV e saio manipulando como objeto

---

⬅️ [Módulo 05](../05-funcoes-toolmaking/README.md) · ➡️ [Módulo 07 — Erros e Debugging](../07-erros-e-debugging/README.md)

<sub>© 2026 Prof. Daniel Santos · Texto sob [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Código sob [PolyForm NC](../../LICENSE)</sub>
