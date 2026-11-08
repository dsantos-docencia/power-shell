# Módulo 08 — PowerShell Orientado a Objetos e .NET

> *"O superpoder escondido: você tem o .NET inteiro na ponta dos dedos. Quando um cmdlet não existe, uma classe .NET quase sempre existe."*

**Carga sugerida:** 6–8 h · **Nível:** avançado · **Pré-requisito:** [Módulo 07](../07-erros-e-debugging/)

## 🎯 Objetivos

- Chamar **classes .NET diretamente** (`[Math]`, `[DateTime]`, `[Guid]`…)
- Criar objetos ricos com `[PSCustomObject]` e `Add-Member`
- Definir suas próprias **classes** e **enums** (PowerShell 5+)
- Conhecer `Add-Type` para importar/compilar código C#

---

## 1. Chamando o .NET diretamente

O PowerShell roda sobre o .NET, então você acessa **qualquer classe** do framework. Métodos **estáticos** usam a sintaxe `[Classe]::Metodo()`:

```powershell
[Math]::Round(3.14159, 2)        # 3.14
[Math]::Sqrt(144)                # 12
[Math]::Max(10, 20)              # 20
[Math]::PI                       # 3.14159... (propriedade estática)

[Guid]::NewGuid()                # gera um GUID único
[DateTime]::Now                  # equivalente a Get-Date
[DateTime]::Parse('2026-01-15')  # texto -> DateTime

[System.IO.Path]::GetExtension('/a/b/foto.jpg')   # .jpg
[System.IO.Path]::GetFileNameWithoutExtension('relatorio.pdf')  # relatorio

[Convert]::ToString(255, 16)     # 'ff' (255 em hexadecimal)
[Convert]::ToInt32('1010', 2)    # 10 (binário -> decimal)
```

> 💡 **Quando usar?** Quando não há um cmdlet pronto. Precisa de raiz quadrada? `[Math]::Sqrt()`. Precisa de um GUID? `[Guid]::NewGuid()`. Precisa manipular um caminho sem tocar no disco? `[System.IO.Path]`. É o "plano B" que quase sempre funciona — e muitas vezes é mais rápido que um cmdlet.

> ⚠️ Instâncias (não-estáticas) usam o ponto: `$data = Get-Date; $data.AddDays(7)`. Estáticos usam `::`. Para descobrir o que uma classe oferece: `[Math] | Get-Member -Static`.

---

## 2. `Add-Member`: enriquecendo objetos

Você pode adicionar propriedades e **métodos** a um `[PSCustomObject]` depois de criá-lo:

```powershell
$conta = [pscustomobject]@{ Nome = 'Ana'; Saldo = 100 }

# adiciona um MÉTODO (ScriptMethod) ao objeto:
$conta | Add-Member -MemberType ScriptMethod -Name Depositar -Value {
    param([double]$Valor) $this.Saldo += $Valor
}
$conta.Depositar(50)
$conta.Saldo                     # 150 ($this refere-se ao próprio objeto)
```

> 💡 `Add-Member` é útil para "turbinar" objetos vindos de outros cmdlets (ex.: adicionar uma propriedade calculada a cada item). Mas quando você precisa de estrutura de verdade, com construtor e vários métodos, use uma **classe**.

---

## 3. Classes e enums (PowerShell 5+)

Desde o PowerShell 5 você define suas próprias estruturas com `class` — sintaxe parecida com C#.

```powershell
enum Nivel {
    Baixo  = 1
    Medio  = 2
    Alto   = 3
}

class Servidor {
    [string]$Nome
    [Nivel]$Prioridade
    [int]$CPU

    # construtor
    Servidor([string]$nome, [Nivel]$prio) {
        $this.Nome = $nome
        $this.Prioridade = $prio
        $this.CPU = 0
    }

    # método que retorna um valor
    [bool] EstaSobrecarregado() {
        return $this.CPU -gt 80
    }

    # método que altera o estado
    [void] RegistrarCPU([int]$valor) {
        $this.CPU = $valor
    }
}

$s = [Servidor]::new('web-01', [Nivel]::Alto)
$s.RegistrarCPU(90)
$s.EstaSobrecarregado()          # True
$s.Prioridade                    # Alto
```

| Recurso | Sintaxe |
|---|---|
| Propriedade tipada | `[string]$Nome` |
| Construtor | `NomeDaClasse(params) { ... }` |
| Método com retorno | `[tipo] Nome(params) { return ... }` |
| Método sem retorno | `[void] Nome(params) { ... }` |
| Referência ao objeto | `$this` |
| Instanciar | `[Classe]::new(args)` |

> 💡 Classes do PowerShell são ótimas para **modelar dados com comportamento** (um `Servidor`, uma `Conta`) e para **DSC** (Módulo avançado). A herança existe, mas é mais limitada que em C#. Para a maioria dos relatórios, `[PSCustomObject]` basta; classes entram quando você precisa de construtor, validação interna e métodos.

---

## 4. `Add-Type`: trazendo C# para dentro

Quando nem o .NET exposto basta, `Add-Type` compila **C# na hora** e o disponibiliza:

```powershell
Add-Type -TypeDefinition @"
public class Calculadora {
    public static int Somar(int a, int b) { return a + b; }
}
"@
[Calculadora]::Somar(2, 3)       # 5
```

Também carrega **assemblies** (DLLs) prontas:
```powershell
Add-Type -AssemblyName System.Windows.Forms   # (no Windows) GUIs, caixas de diálogo
```

> 💡 `Add-Type` é a ponte final: dá para usar bibliotecas C# inteiras, compilar código de performance crítica, ou acessar APIs do Windows. Uso avançado, mas bom saber que o teto é o .NET inteiro — não há "parede" onde o PowerShell acaba.

---

## 🧪 Exemplos deste módulo

| Arquivo | Demonstra |
|---|---|
| [01-dotnet-direto.ps1](exemplos/01-dotnet-direto.ps1) | Métodos estáticos: `[Math]`, `[Guid]`, `[IO.Path]`, `[Convert]` |
| [02-classe-e-enum.ps1](exemplos/02-classe-e-enum.ps1) | `class` e `enum` com construtor, métodos e `$this` |
| [03-add-member.ps1](exemplos/03-add-member.ps1) | Enriquecer um `[PSCustomObject]` com método via `Add-Member` |

## ⚠️ Armadilhas do módulo

- Confundir estático (`[Classe]::Metodo()`) com instância (`$obj.Metodo()`)
- Esquecer `$this` dentro de métodos de classe/ScriptMethod
- Usar classe quando um `[PSCustomObject]` resolveria (complexidade desnecessária)
- Definir `class` e esperar herança completa de C# (é mais limitada)

## 🏋️ Exercícios

Veja [exercicios/README.md](exercicios/README.md). Corrija com `./ferramentas/corrigir.ps1 08`.

## ✅ Checklist de domínio

- [ ] Chamo métodos estáticos do .NET (`[Math]::Round`, `[Guid]::NewGuid`)
- [ ] Sei a diferença entre `::` (estático) e `.` (instância)
- [ ] Defino uma `class` com construtor, propriedades e métodos
- [ ] Uso um `enum` para valores nomeados
- [ ] Sei que `Add-Type` traz C#/DLLs para dentro

---

⬅️ [Módulo 07](../07-erros-e-debugging/README.md) · ➡️ [Módulo 09 — Remoting e Paralelismo](../09-remoting-e-paralelismo/README.md)

<sub>© 2026 Prof. Daniel Santos · Texto sob [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Código sob [PolyForm NC](../../LICENSE)</sub>
