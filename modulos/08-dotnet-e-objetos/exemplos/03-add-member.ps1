<#
============================================================================
  Curso de PowerShell · Módulo 08 · Exemplo 03 — Add-Member e Add-Type
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Enriquecer um PSCustomObject com propriedade/método (Add-Member) e
            ver o Add-Type compilando C# na hora.
  EXECUTE   pwsh ./03-add-member.ps1
============================================================================
#>
Set-StrictMode -Version Latest

Write-Output '1) Add-Member adiciona uma PROPRIEDADE calculada a um objeto:'
$pessoa = [pscustomobject]@{ Nome = 'Ana'; Nascimento = [datetime]'1990-06-15' }
$pessoa | Add-Member -MemberType ScriptProperty -Name Idade -Value {
    [int](([datetime]::Now - $this.Nascimento).TotalDays / 365.25)
}
"   $($pessoa.Nome) tem aproximadamente $($pessoa.Idade) anos (propriedade calculada)" | Write-Output

Write-Output ''
Write-Output '2) Add-Member adiciona um MÉTODO (ScriptMethod); $this é o próprio objeto:'
$conta = [pscustomobject]@{ Titular = 'Bia'; Saldo = 100.0 }
$conta | Add-Member -MemberType ScriptMethod -Name Depositar -Value {
    param([double]$Valor)
    $this.Saldo += $Valor
}
$conta.Depositar(50)
$conta.Depositar(25)
"   saldo de $($conta.Titular) após depósitos: $($conta.Saldo)" | Write-Output

Write-Output ''
Write-Output '3) Add-Type compila C# na hora (o teto do PowerShell é o .NET inteiro):'
Add-Type -TypeDefinition @"
public class Calc {
    public static int Fatorial(int n) {
        int r = 1;
        for (int i = 2; i <= n; i++) r *= i;
        return r;
    }
}
"@
"   [Calc]::Fatorial(5) = $([Calc]::Fatorial(5))  (compilado de C# em tempo de execução)" | Write-Output

Write-Output ''
Write-Output 'Add-Member turbina objetos existentes; Add-Type traz código C#/DLLs.'
Write-Output 'Para estrutura de verdade com construtor e métodos, prefira uma class (exemplo 02).'
