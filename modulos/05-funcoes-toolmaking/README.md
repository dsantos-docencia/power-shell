# Módulo 05 — Funções e "Cmdlets" Personalizados (Toolmaking)

> *"Aqui você para de escrever scripts e começa a construir ferramentas. Suas funções passam a se comportar como cmdlets de verdade."*

**Carga sugerida:** 8–10 h · **Nível:** intermediário+ · **Pré-requisito:** [Módulo 04](../04-controle-de-fluxo/)

## 🎯 Objetivos

- Escrever funções com parâmetros nomeados e tipados
- Transformar funções em **funções avançadas** com `[CmdletBinding()]`
- Validar entrada com `[Parameter(Mandatory)]`, `[ValidateSet]`, `[ValidateRange]`…
- Fazer funções que **aceitam o pipeline** (`ValueFromPipeline` + `process`)
- Implementar `-WhatIf`/`-Confirm` com `SupportsShouldProcess`

---

## 1. Funções básicas

```powershell
function Get-Saudacao {
    param(
        [string]$Nome,
        [string]$Periodo = 'dia'
    )
    "Bom $Periodo, $Nome!"
}

Get-Saudacao -Nome 'Ana'                    # parâmetros nomeados
Get-Saudacao -Nome 'Bia' -Periodo 'tarde'
Get-Saudacao 'Caio' 'noite'                 # posicional (funciona, mas nomeado é mais claro)
```

> 💡 **Nomeie suas funções Verbo-Substantivo**, como os cmdlets (`Get-Saudacao`, não `Saudacao`). Use um verbo aprovado (`Get-Verb`). Assim sua ferramenta é descoberta por `Get-Command` e se encaixa no ecossistema.

> ⚠️ **Toda saída emitida vira retorno.** No PowerShell, qualquer objeto que a função "deixa cair" no pipeline é retornado. `$x = 5` não retorna nada, mas `$x` sozinho numa linha, ou `"texto"`, ou um cmdlet sem capturar a saída — tudo isso vai para o retorno. Cuidado com saídas acidentais (atribua a `$null` ou use `[void]` o que não deve retornar).

---

## 2. Funções avançadas: `[CmdletBinding()]`

Adicionar `[CmdletBinding()]` acima do `param()` transforma sua função numa **função avançada** — ela ganha, de graça, os parâmetros comuns (`-Verbose`, `-Debug`, `-ErrorAction`…) e passa a se comportar como um cmdlet compilado.

```powershell
function Get-Quadrado {
    [CmdletBinding()]
    param([int]$N)

    Write-Verbose "calculando o quadrado de $N"   # aparece só com -Verbose
    $N * $N
}

Get-Quadrado -N 5 -Verbose     # agora -Verbose funciona automaticamente
```

---

## 3. Validação de parâmetros

O PowerShell valida a entrada **antes** de a função rodar — você declara as regras como atributos. Isso elimina um monte de `if` de checagem.

```powershell
function New-Usuario {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]            # obrigatório; pergunta se faltar
        [string]$Nome,

        [ValidateSet('admin', 'editor', 'leitor')] # só aceita um desses
        [string]$Papel = 'leitor',

        [ValidateRange(18, 120)]                   # só nesse intervalo
        [int]$Idade,

        [ValidateNotNullOrEmpty()]                 # não pode ser vazio
        [string]$Email,

        [ValidatePattern('^\d{5}-\d{3}$')]         # tem que casar a regex
        [string]$Cep
    )
    "Criado: $Nome ($Papel)"
}
```

| Atributo | Garante |
|---|---|
| `[Parameter(Mandatory=$true)]` | o parâmetro foi informado |
| `[ValidateSet(...)]` | o valor está na lista permitida |
| `[ValidateRange(min,max)]` | número no intervalo |
| `[ValidateNotNullOrEmpty()]` | não é nulo nem vazio |
| `[ValidatePattern('regex')]` | casa a expressão regular |
| `[ValidateScript({...})]` | passa num teste personalizado |

> 💡 `[ValidateSet(...)]` dá **autocompletar** com Tab no console. Quem usa sua função só aperta Tab e vê as opções. É profissionalismo de graça.

---

## 4. Funções que aceitam o pipeline

Esta é a marca de uma ferramenta de verdade: aceitar objetos pelo pipeline, como os cmdlets nativos. Você marca o parâmetro com `ValueFromPipeline` e processa cada item no bloco `process`.

```powershell
function Get-Dobro {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [int]$Numero
    )
    begin   { $total = 0 }                  # roda UMA vez, no início
    process { $Numero * 2; $total += $Numero }  # roda PARA CADA item do pipeline
    end     { Write-Verbose "processei soma=$total" }  # roda UMA vez, no fim
}

1, 2, 3 | Get-Dobro         # 2, 4, 6 — processou cada um
```

| Bloco | Quando roda |
|---|---|
| `begin` | uma vez, antes do primeiro item (inicialização) |
| `process` | uma vez **para cada** objeto do pipeline (`$_` ou o parâmetro) |
| `end` | uma vez, depois do último item (finalização) |

> 💡 Também existe `ValueFromPipelineByPropertyName` — o parâmetro recebe o valor de uma **propriedade** de mesmo nome do objeto que vem pelo pipeline. É como `Get-Process | Stop-Process` funciona: o `Id` flui por nome de propriedade.

---

## 5. `-WhatIf` e `-Confirm`: simular antes de agir

Lembra do `-WhatIf` do `Remove-Item` (Módulo 01)? Você pode dar esse superpoder às **suas** funções com `SupportsShouldProcess`.

```powershell
function Remove-Log {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param([Parameter(Mandatory)][string]$Caminho)

    if ($PSCmdlet.ShouldProcess($Caminho, 'Remover arquivo de log')) {
        Remove-Item -Path $Caminho
    }
}

Remove-Log -Caminho app.log -WhatIf    # só mostra "What if:..."; NÃO apaga
Remove-Log -Caminho app.log -Confirm   # pergunta antes de apagar
Remove-Log -Caminho app.log            # apaga
```

> 💡 `$PSCmdlet.ShouldProcess(...)` devolve `$false` quando o usuário passou `-WhatIf` (ou respondeu "não" ao `-Confirm`), então o bloco de ação não roda. **Toda função que altera estado** (apaga, modifica, reinicia) deveria implementar isso. É a diferença entre uma ferramenta amadora e uma profissional — e a rede de segurança que falta no Bash.

---

## 🧪 Exemplos deste módulo

| Arquivo | Demonstra |
|---|---|
| [01-funcao-avancada.ps1](exemplos/01-funcao-avancada.ps1) | `[CmdletBinding()]`, `Mandatory`, `ValidateSet`, `ValidateRange` |
| [02-pipeline-input.ps1](exemplos/02-pipeline-input.ps1) | `ValueFromPipeline` + `begin/process/end` |
| [03-whatif.ps1](exemplos/03-whatif.ps1) | `SupportsShouldProcess` e `ShouldProcess()` |

## ⚠️ Armadilhas do módulo

- Saída acidental: uma linha solta que vai parar no retorno da função
- Esquecer o bloco `process` (sem ele, só o último item do pipeline é processado)
- Não validar entrada com atributos e encher a função de `if`
- Alterar estado (apagar/mudar) sem implementar `SupportsShouldProcess`

## 🏋️ Exercícios

Veja [exercicios/README.md](exercicios/README.md). Corrija com `./ferramentas/corrigir.ps1 05`.

## ✅ Checklist de domínio

- [ ] Escrevo funções Verbo-Substantivo com `param()` tipado
- [ ] Uso `[CmdletBinding()]` e ganho `-Verbose` de graça
- [ ] Valido entrada com `ValidateSet`/`ValidateRange`/`Mandatory`
- [ ] Faço funções que aceitam pipeline com `ValueFromPipeline` + `process`
- [ ] Implemento `-WhatIf` com `SupportsShouldProcess`

---

⬅️ [Módulo 04](../04-controle-de-fluxo/README.md) · ➡️ [Módulo 06 — Dados e Objetos](../06-dados-e-objetos/README.md)

<sub>© 2026 Prof. Daniel Santos · Texto sob [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Código sob [PolyForm NC](../../LICENSE)</sub>
