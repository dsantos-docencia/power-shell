# Testes Pester do módulo Iconne.Infra (Projeto 05)
BeforeAll {
    $psd1 = Join-Path $PSScriptRoot 'Iconne.Infra/Iconne.Infra.psd1'
    Import-Module $psd1 -Force
}
AfterAll { Remove-Module Iconne.Infra -Force -ErrorAction SilentlyContinue }

Describe 'Convert-ParaTamanhoLegivel' {
    It 'formata bytes pequenos' { Convert-ParaTamanhoLegivel -Bytes 512 | Should -Be '512 B' }
    It 'formata KB'             { Convert-ParaTamanhoLegivel -Bytes 1536 | Should -Be '1.5 KB' }
    It 'formata MB'             { Convert-ParaTamanhoLegivel -Bytes 1048576 | Should -Be '1.0 MB' }
    It 'rejeita negativo'       { { Convert-ParaTamanhoLegivel -Bytes -1 } | Should -Throw }
}
Describe 'Test-NomeRecurso' {
    It 'aceita padrão válido'   { Test-NomeRecurso -Nome 'srv-web01' | Should -BeTrue }
    It 'rejeita maiúsculas'     { Test-NomeRecurso -Nome 'SRV-web01' | Should -BeFalse }
    It 'rejeita sem hífen'      { Test-NomeRecurso -Nome 'srvweb01' | Should -BeFalse }
}
Describe 'New-IdRecurso' {
    It 'gera no formato correto' { New-IdRecurso -Prefixo 'vm' | Should -Match '^vm-[0-9a-f]{6}$' }
    It 'rejeita prefixo inválido' { { New-IdRecurso -Prefixo 'VM1' } | Should -Throw }
}
Describe 'Encapsulamento' {
    It 'não expõe a função privada' { Get-Command Test-SufixoValido -ErrorAction SilentlyContinue | Should -BeNullOrEmpty }
}
