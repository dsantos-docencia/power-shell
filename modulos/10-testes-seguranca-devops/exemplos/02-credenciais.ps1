<#
============================================================================
  Curso de PowerShell · Módulo 10 · Exemplo 02 — Credenciais com segurança
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Mostrar SecureString e PSCredential SEM expor segredos reais, e
            por que SecureString não é criptografia forte.
  EXECUTE   pwsh ./02-credenciais.ps1
============================================================================
#>
# O ConvertTo-SecureString -AsPlainText abaixo é SÓ demonstração local;
# por isso suprimimos a regra (em produção, a senha vem de Get-Credential/cofre).
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Demonstração didática; produção usa Get-Credential/cofre.')]
param()

Set-StrictMode -Version Latest

Write-Output '1) Em produção, a senha vem de Get-Credential (prompt seguro):'
Write-Output '   $cred = Get-Credential        # abre um diálogo; nada em texto puro no script'
Write-Output '   $cred.UserName                # o usuário'
Write-Output '   $cred.Password                # um SecureString, não texto puro'

Write-Output ''
Write-Output '2) Montando um PSCredential de exemplo (senha fictícia, só para demonstrar):'
# ConvertTo-SecureString com -AsPlainText é SÓ para demonstração/local.
$segredoFicticio = ConvertTo-SecureString 'exemplo-nao-use-assim' -AsPlainText -Force
$cred = [System.Management.Automation.PSCredential]::new('usuario.teste', $segredoFicticio)
"   UserName: $($cred.UserName)" | Write-Output
"   Password é do tipo: $($cred.Password.GetType().Name)  (não é String)" | Write-Output

Write-Output ''
Write-Output '3) SecureString NÃO é criptografia forte — é ofuscação na memória.'
Write-Output '   Quem controla o processo consegue recuperar o valor. Para segredos'
Write-Output '   de verdade, use um COFRE:'
Write-Output '      Install-Module Microsoft.PowerShell.SecretManagement'
Write-Output '      Get-Secret -Name ChaveAPI        # busca de um cofre (Key Vault, etc.)'

Write-Output ''
Write-Output '4) Regra de ouro: NUNCA escreva senhas em texto puro no script e NUNCA'
Write-Output '   as commite. O secret scanning do repositório ajuda a barrar isso.'
