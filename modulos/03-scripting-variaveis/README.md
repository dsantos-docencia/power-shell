# Módulo 03 — Scripting e Variáveis

> *"Até aqui você usou o PowerShell. Agora você começa a programá-lo."*

**Carga sugerida:** 6–8 h · **Nível:** iniciante+ · **Pré-requisito:** [Módulo 02](../02-pipeline-objetos/)

## 🎯 Objetivos

- Criar e tipar variáveis, e entender escopos
- Dominar os **operadores de comparação** do PowerShell (`-eq`, `-like`, `-match`…)
- Entender os **streams de saída** e a famosa **"regra do Write-Host"**
- Interagir com o usuário (`Read-Host`) e interpolar strings
- Conhecer o `$PROFILE` para personalizar seu ambiente

---

## 1. Variáveis e tipos

Variáveis começam com `$`. O PowerShell é **dinamicamente tipado**, mas por baixo todo valor é um **tipo .NET**.

```powershell
$nome = "Daniel"              # String
$idade = 38                   # Int32
$pi = 3.14                    # Double
$ativo = $true                # Boolean ($true / $false)
$nada = $null                 # nulo
$lista = @(1, 2, 3)           # array
$mapa = @{ Nome = "Ana"; Idade = 30 }   # hashtable (dicionário)
```

Você pode **forçar o tipo** (tipagem forte), o que valida a entrada:
```powershell
[int]$quantidade = 10         # só aceita inteiros
[datetime]$nascimento = "1986-05-20"   # converte texto para data de verdade
$nascimento.Year              # 1986 — agora é um objeto DateTime, com propriedades
```

> 💡 Descobrir o tipo de qualquer coisa: `$nome.GetType().Name` ou `(Get-Item .).GetType().FullName`. Lembre do Módulo 02: todo valor é um objeto — use `Get-Member`.

### Escopos
```powershell
$global:config = "x"     # visível em toda a sessão
$script:contador = 0     # visível no script inteiro
function f { $local:temp = 1 }   # só dentro da função (padrão)
```

### Variáveis automáticas (o PowerShell preenche)
| Variável | É |
|---|---|
| `$_` / `$PSItem` | o objeto atual no pipeline |
| `$?` | o último comando teve sucesso? (`$true`/`$false`) |
| `$LASTEXITCODE` | código de saída do último programa externo |
| `$PSVersionTable` | detalhes da versão |
| `$args` | argumentos não nomeados |
| `$PROFILE` | caminho do seu script de perfil |

---

## 2. Operadores de comparação

Aqui o PowerShell diverge de quase todas as linguagens: comparação **não** usa `>` `<` `==` (o `>` é redirecionamento!). Usa operadores com `-`:

| Operador | Significa | Exemplo |
|---|---|---|
| `-eq` `-ne` | igual / diferente | `$x -eq 10` |
| `-gt` `-ge` `-lt` `-le` | maior / maior-igual / menor / menor-igual | `$x -gt 5` |
| `-like` | curinga (`*`, `?`) | `$nome -like 'Dan*'` |
| `-notlike` | negação do like | |
| `-match` | expressão regular | `$cep -match '^\d{5}-\d{3}$'` |
| `-replace` | substitui por regex | `$t -replace '\d', '#'` |
| `-in` / `-contains` | pertence a uma coleção | `3 -in @(1,2,3)` |
| `-and` `-or` `-not` (`!`) | lógicos | `$a -gt 0 -and $a -lt 10` |

> ⚠️ **Comparações são case-insensitive por padrão.** `'ABC' -eq 'abc'` é `$true`. Para diferenciar maiúsc/minúsc, prefixe com `c`: `-ceq`, `-clike`, `-cmatch`. (Existe `i` explícito também: `-ieq`.)

> ⚠️ **`-eq` com arrays FILTRA em vez de comparar.** `@(1,2,3,2) -eq 2` devolve `@(2,2)` (os elementos iguais), não `$true`. Para testar pertencimento use `-contains`/`-in`. E para comparar com `$null`, ponha o `$null` à **esquerda**: `$null -eq $x` (evita um comportamento traiçoeiro quando `$x` é array — tema do [Módulo 07](../07-erros-e-debugging/)).

---

## 3. Saída: os streams e a "regra do Write-Host"

Este é um tema que separa amadores de profissionais no PowerShell. Há **vários streams de saída**, cada um com um propósito:

| Cmdlet | Stream | Para quê |
|---|---|---|
| `Write-Output` | **Success (1)** | **os dados** — o que vai pelo pipeline |
| `Write-Host` | Information (6) | mensagens para o **humano** no console |
| `Write-Verbose` | Verbose (4) | detalhes (só aparecem com `-Verbose`) |
| `Write-Warning` | Warning (3) | avisos |
| `Write-Error` | Error (2) | erros não-terminantes |
| `Write-Debug` | Debug (5) | depuração (só com `-Debug`) |

### 🔴 A regra do Write-Host

```powershell
function Get-Dobro($n) {
    Write-Host "Calculando..."     # ❌ isto "suja" a saída de dados?
    Write-Output ($n * 2)          # ✔ este é o dado que retorna
}
$resultado = Get-Dobro 21          # $resultado = 42 (o Write-Host NÃO entra aqui)
```

Historicamente, `Write-Host` era um **anti-pattern** porque escrevia direto na tela e não podia ser capturado nem redirecionado — se você usasse `Write-Host` para "retornar" um dado, ele se perdia. Desde o PowerShell 5, `Write-Host` escreve no stream de **Information** (6), então *pode* ser capturado, mas a lição permanece:

> **Use `Write-Output` (ou simplesmente emita o objeto) para DADOS. Use `Write-Host` só para mensagens ao usuário no console** (um menu, uma barra de progresso textual, cores). Em uma função que produz dados para o pipeline, `Write-Host` no meio é quase sempre um erro de design. Para "falar com o operador" sem sujar os dados, prefira `Write-Verbose`/`Write-Information`.

> 💡 No PowerShell, uma função **retorna tudo o que emite** — não precisa de `Write-Output` nem `return`. `$n * 2` sozinho numa linha já vai para o pipeline. Isso é poderoso e perigoso (saídas acidentais) — tema do [Módulo 05](../05-funcoes-toolmaking/).

---

## 4. Entrada e interpolação

```powershell
$nome = Read-Host "Qual seu nome"            # pergunta e lê (string)
$senha = Read-Host "Senha" -AsSecureString   # entrada protegida (SecureString)

# Interpolação: dentro de ASPAS DUPLAS, $var é expandida:
Write-Output "Olá, $nome!"
# Para expressões/propriedades, use $( ):
Write-Output "Você tem $($nome.Length) letras no nome"
Write-Output "Agora: $(Get-Date -Format 'HH:mm')"

# Aspas SIMPLES são literais (não expandem):
Write-Output 'Isto sai $literal, sem expandir'
```

**Operador de formato `-f`** (como o `printf`):
```powershell
'{0,-10} {1,6:N2}' -f 'Café', 4.5        # Café         4.50
'{0:X}' -f 255                            # FF (hex)
'{0:P0}' -f 0.8                           # 80% (percentual)
```

**Here-strings** (blocos de texto, úteis para JSON/SQL/templates):
```powershell
$texto = @"
Linha 1 com $nome expandido
Linha 2
"@
```

---

## 5. O `$PROFILE`

`$PROFILE` é um script que roda toda vez que você abre o PowerShell — onde você põe aliases, funções e configurações pessoais.

```powershell
$PROFILE                          # mostra o caminho do seu perfil
Test-Path $PROFILE                # ele existe?
New-Item -ItemType File -Path $PROFILE -Force   # cria
# edite e adicione, por exemplo:  function ll { Get-ChildItem -Force }
```

---

## 🧪 Exemplos deste módulo

| Arquivo | Demonstra |
|---|---|
| [01-variaveis-e-tipos.ps1](exemplos/01-variaveis-e-tipos.ps1) | Tipagem dinâmica vs. forte; tipos .NET por baixo |
| [02-streams-de-saida.ps1](exemplos/02-streams-de-saida.ps1) | `Write-Output` vs `Write-Host` e por que importa (a regra) |
| [03-operadores.ps1](exemplos/03-operadores.ps1) | `-eq`/`-like`/`-match`, case-sensitivity e a armadilha do array |

## ⚠️ Armadilhas do módulo

- Usar `Write-Host` para "retornar" dados de uma função (use `Write-Output`)
- Esquecer que comparações são case-insensitive (`-ceq` quando precisar)
- `$x -eq $null` em vez de `$null -eq $x` (o certo é o `$null` à esquerda)
- Interpolar propriedade sem `$( )`: `"$obj.Nome"` sai errado; use `"$($obj.Nome)"`
- Usar `>` achando que compara (é redirecionamento!)

## 🏋️ Exercícios

Veja [exercicios/README.md](exercicios/README.md). Corrija com `./ferramentas/corrigir.ps1 03`.

## ✅ Checklist de domínio

- [ ] Tipo variáveis com `[int]`/`[datetime]` e sei ver o tipo com `Get-Member`
- [ ] Uso os operadores `-eq`/`-like`/`-match` corretamente
- [ ] Explico a regra do Write-Host e uso `Write-Output` para dados
- [ ] Interpolo com `$( )` e formato com `-f`
- [ ] Sei o que é o `$PROFILE`

---

⬅️ [Módulo 02](../02-pipeline-objetos/README.md) · ➡️ [Módulo 04 — Controle de Fluxo](../04-controle-de-fluxo/README.md)

<sub>© 2026 Prof. Daniel Santos · Texto sob [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Código sob [PolyForm NC](../../LICENSE)</sub>
