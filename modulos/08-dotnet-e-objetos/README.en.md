# Module 08 — Object-Oriented PowerShell and .NET

**🌍 Language / Idioma:** **English** · [Português](README.md)

> 🌐 *Community translation. Spotted a slip or have a better wording? [Open an issue or PR](https://github.com/dsantos-docencia/power-shell/issues) — see [traducoes/](../../traducoes/README.en.md).*

> *"The hidden superpower: you have all of .NET at your fingertips. When a cmdlet doesn't exist, a .NET class almost always does."*

**Suggested load:** 6–8 h · **Level:** advanced · **Prerequisite:** [Module 07](../07-erros-e-debugging/README.en.md)

## 🎯 Objectives

- Call **.NET classes directly** (`[Math]`, `[DateTime]`, `[Guid]`…)
- Create rich objects with `[PSCustomObject]` and `Add-Member`
- Define your own **classes** and **enums** (PowerShell 5+)
- Learn `Add-Type` to import/compile C# code

---

## 1. Calling .NET directly

PowerShell runs on .NET, so you can access **any class** in the framework. **Static** methods use the `[Class]::Method()` syntax:

```powershell
[Math]::Round(3.14159, 2)        # 3.14
[Math]::Sqrt(144)                # 12
[Math]::Max(10, 20)              # 20
[Math]::PI                       # 3.14159... (static property)

[Guid]::NewGuid()                # generates a unique GUID
[DateTime]::Now                  # equivalent to Get-Date
[DateTime]::Parse('2026-01-15')  # text -> DateTime

[System.IO.Path]::GetExtension('/a/b/foto.jpg')   # .jpg
[System.IO.Path]::GetFileNameWithoutExtension('relatorio.pdf')  # relatorio

[Convert]::ToString(255, 16)     # 'ff' (255 in hexadecimal)
[Convert]::ToInt32('1010', 2)    # 10 (binary -> decimal)
```

> 💡 **When to use it?** When there's no ready-made cmdlet. Need a square root? `[Math]::Sqrt()`. Need a GUID? `[Guid]::NewGuid()`. Need to manipulate a path without touching the disk? `[System.IO.Path]`. It's the "plan B" that almost always works — and is often faster than a cmdlet.

> ⚠️ Instances (non-static) use the dot: `$data = Get-Date; $data.AddDays(7)`. Statics use `::`. To discover what a class offers: `[Math] | Get-Member -Static`.

---

## 2. `Add-Member`: enriching objects

You can add properties and **methods** to a `[PSCustomObject]` after creating it:

```powershell
$conta = [pscustomobject]@{ Nome = 'Ana'; Saldo = 100 }

# adds a METHOD (ScriptMethod) to the object:
$conta | Add-Member -MemberType ScriptMethod -Name Depositar -Value {
    param([double]$Valor) $this.Saldo += $Valor
}
$conta.Depositar(50)
$conta.Saldo                     # 150 ($this refers to the object itself)
```

> 💡 `Add-Member` is useful for "souping up" objects coming from other cmdlets (e.g., adding a calculated property to each item). But when you need real structure, with a constructor and several methods, use a **class**.

---

## 3. Classes and enums (PowerShell 5+)

Since PowerShell 5 you define your own structures with `class` — syntax similar to C#.

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

    # constructor
    Servidor([string]$nome, [Nivel]$prio) {
        $this.Nome = $nome
        $this.Prioridade = $prio
        $this.CPU = 0
    }

    # method that returns a value
    [bool] EstaSobrecarregado() {
        return $this.CPU -gt 80
    }

    # method that changes the state
    [void] RegistrarCPU([int]$valor) {
        $this.CPU = $valor
    }
}

$s = [Servidor]::new('web-01', [Nivel]::Alto)
$s.RegistrarCPU(90)
$s.EstaSobrecarregado()          # True
$s.Prioridade                    # Alto
```

| Feature | Syntax |
|---|---|
| Typed property | `[string]$Nome` |
| Constructor | `ClassName(params) { ... }` |
| Method with return | `[type] Name(params) { return ... }` |
| Method without return | `[void] Name(params) { ... }` |
| Reference to the object | `$this` |
| Instantiate | `[Class]::new(args)` |

> 💡 PowerShell classes are great for **modeling data with behavior** (a `Servidor`, a `Conta`) and for **DSC** (advanced module). Inheritance exists, but it's more limited than in C#. For most reports, `[PSCustomObject]` is enough; classes come in when you need a constructor, internal validation, and methods.

---

## 4. `Add-Type`: bringing C# in

When even the exposed .NET isn't enough, `Add-Type` compiles **C# on the fly** and makes it available:

```powershell
Add-Type -TypeDefinition @"
public class Calculadora {
    public static int Somar(int a, int b) { return a + b; }
}
"@
[Calculadora]::Somar(2, 3)       # 5
```

It also loads ready-made **assemblies** (DLLs):
```powershell
Add-Type -AssemblyName System.Windows.Forms   # (on Windows) GUIs, dialog boxes
```

> 💡 `Add-Type` is the final bridge: you can use whole C# libraries, compile performance-critical code, or access Windows APIs. Advanced use, but good to know the ceiling is all of .NET — there's no "wall" where PowerShell ends.

---

## 🧪 Examples in this module

| File | Demonstrates |
|---|---|
| [01-dotnet-direto.ps1](exemplos/01-dotnet-direto.ps1) | Static methods: `[Math]`, `[Guid]`, `[IO.Path]`, `[Convert]` |
| [02-classe-e-enum.ps1](exemplos/02-classe-e-enum.ps1) | `class` and `enum` with constructor, methods, and `$this` |
| [03-add-member.ps1](exemplos/03-add-member.ps1) | Enriching a `[PSCustomObject]` with a method via `Add-Member` |

## ⚠️ Module pitfalls

- Confusing static (`[Class]::Method()`) with instance (`$obj.Method()`)
- Forgetting `$this` inside class/ScriptMethod methods
- Using a class when a `[PSCustomObject]` would do (unnecessary complexity)
- Defining a `class` and expecting full C# inheritance (it's more limited)

## 🏋️ Exercises

See [exercicios/README.en.md](exercicios/README.en.md). Grade with `./ferramentas/corrigir.ps1 08`.

## ✅ Mastery checklist

- [ ] I call static .NET methods (`[Math]::Round`, `[Guid]::NewGuid`)
- [ ] I know the difference between `::` (static) and `.` (instance)
- [ ] I define a `class` with constructor, properties, and methods
- [ ] I use an `enum` for named values
- [ ] I know that `Add-Type` brings C#/DLLs in

---

⬅️ [Module 07](../07-erros-e-debugging/README.en.md) · ➡️ [Module 09 — Remoting and Parallelism](../09-remoting-e-paralelismo/README.en.md)

<sub>© 2026 Prof. Daniel Santos and translators · Text under [CC BY-NC-SA 4.0](../../LICENSE-CONTEUDO.md) · Code under [PolyForm NC](../../LICENSE)</sub>
