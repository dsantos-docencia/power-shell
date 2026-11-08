<#
============================================================================
  Curso de PowerShell · Módulo 05 · Exemplo 01 — Função avançada e validação
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  [CmdletBinding()] + validação de parâmetros (Mandatory, ValidateSet,
            ValidateRange) — a entrada é validada ANTES da função rodar.
  EXECUTE   pwsh ./01-funcao-avancada.ps1
============================================================================
#>
Set-StrictMode -Version Latest

function New-Conta {
    [CmdletBinding()]
    # Este exemplo é sobre VALIDAÇÃO e não altera estado (só valida e retorna texto),
    # então suprimimos a regra que pede ShouldProcess em verbos como New-. Quando a
    # função REALMENTE altera estado, implemente ShouldProcess (veja o exemplo 03).
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Exemplo didático de validação; não altera estado.')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Nome,

        [ValidateSet('admin', 'editor', 'leitor')]
        [string]$Papel = 'leitor',

        [ValidateRange(18, 120)]
        [int]$Idade = 18
    )
    Write-Verbose "validação passou; criando a conta"
    "Conta: $Nome | papel=$Papel | idade=$Idade"
}

Write-Output '1) Chamada válida:'
"   " + (New-Conta -Nome 'Ana' -Papel editor -Idade 30) | Write-Output

Write-Output ''
Write-Output '2) -Verbose (de graça, por causa do [CmdletBinding()]):'
New-Conta -Nome 'Bia' -Verbose 4>&1 | ForEach-Object { "   $_" | Write-Output }

Write-Output ''
Write-Output '3) ValidateSet REJEITA um papel inválido (antes de a função rodar):'
try { New-Conta -Nome 'Caio' -Papel 'hacker' | Out-Null }
catch { "   ✔ 'hacker' rejeitado: não está em {admin, editor, leitor}" | Write-Output }

Write-Output ''
Write-Output '4) ValidateRange REJEITA idade fora de 18..120:'
try { New-Conta -Nome 'Dan' -Idade 5 | Out-Null }
catch { "   ✔ idade 5 rejeitada (fora do intervalo 18..120)" | Write-Output }

Write-Output ''
Write-Output '5) Mandatory: sem -Nome, a função exigiria o valor (aqui, capturamos o erro):'
try { New-Conta -Papel leitor -ErrorAction Stop | Out-Null }
catch { "   ✔ -Nome é obrigatório" | Write-Output }
