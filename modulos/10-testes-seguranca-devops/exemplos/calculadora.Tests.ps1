<#
============================================================================
  Curso de PowerShell · Módulo 10 · calculadora.Tests.ps1
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  Testes Pester de verdade para calculadora.ps1. Rode com:
     Invoke-Pester modulos/10-testes-seguranca-devops/exemplos
  (também rodam na verificação do repositório: ferramentas/verificar-tudo.ps1)
============================================================================
#>
BeforeAll {
    $script:calc = Join-Path $PSScriptRoot 'calculadora.ps1'
}

Describe 'calculadora' {

    Context 'operações básicas' {
        It 'soma dois números (padrão)' {
            & $calc -A 2 -B 3 | Should -Be 5
        }
        It 'subtrai' {
            & $calc -A 10 -B 4 -Op Subtrair | Should -Be 6
        }
        It 'multiplica' {
            & $calc -A 6 -B 7 -Op Multiplicar | Should -Be 42
        }
        It 'divide' {
            & $calc -A 20 -B 5 -Op Dividir | Should -Be 4
        }
    }

    Context 'erros e validação' {
        It 'lança erro na divisão por zero' {
            { & $calc -A 5 -B 0 -Op Dividir } | Should -Throw
        }
        It 'rejeita operação inválida (ValidateSet)' {
            { & $calc -A 1 -B 1 -Op Potencia } | Should -Throw
        }
    }
}
