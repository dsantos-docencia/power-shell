#!/usr/bin/env pwsh
<#
============================================================================
  Projeto 04 · CLI Profissional (gerenciador de tarefas)
  Curso de PowerShell · Prof. Daniel Santos
  github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
  ---------------------------------------------------------------------------
  Uma CLI com SUBCOMANDOS (add / listar / concluir / remover) sobre um arquivo
  JSON. Mostra ParameterSets, [ValidateSet], ajuda embutida e persistência —
  o que separa um "scriptzinho" de uma ferramenta de verdade (Módulos 05/06).

  Uso:
    pwsh ./tarefas.ps1 add "Comprar café" -Arquivo t.json
    pwsh ./tarefas.ps1 listar -Arquivo t.json
    pwsh ./tarefas.ps1 concluir 1 -Arquivo t.json
    pwsh ./tarefas.ps1 remover 1 -Arquivo t.json
    pwsh ./tarefas.ps1 ajuda
============================================================================
#>
[CmdletBinding()]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Arquivo', Justification = 'Usado dentro das funções aninhadas Get-Tarefas/Save-Tarefas por escopo.')]
param(
    [Parameter(Position = 0)]
    [ValidateSet('add', 'listar', 'concluir', 'remover', 'ajuda')]
    [string]$Comando = 'ajuda',

    [Parameter(Position = 1)]
    [string]$Argumento,

    [string]$Arquivo = (Join-Path ([System.IO.Path]::GetTempPath()) 'tarefas.json')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-Tarefas {
    if (Test-Path -LiteralPath $Arquivo) {
        $dados = Get-Content -LiteralPath $Arquivo -Raw | ConvertFrom-Json
        return @($dados)
    }
    return @()
}
function Save-Tarefas {
    param($Lista)
    ,@($Lista) | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $Arquivo -Encoding UTF8
}

switch ($Comando) {
    'add' {
        if (-not $Argumento) { Write-Error "Informe o texto da tarefa."; exit 1 }
        $lista = @(Get-Tarefas)
        $id = 1; if ($lista.Count -gt 0) { $id = (($lista | Measure-Object Id -Maximum).Maximum) + 1 }
        $lista += [PSCustomObject]@{ Id = $id; Texto = $Argumento; Feita = $false }
        Save-Tarefas $lista
        Write-Host ("＋ tarefa #{0} adicionada." -f $id) -ForegroundColor Green
        Write-Output "add ok id=$id"
    }
    'listar' {
        $lista = @(Get-Tarefas)
        if ($lista.Count -eq 0) { Write-Host "Nenhuma tarefa." -ForegroundColor DarkGray; Write-Output "total=0"; break }
        foreach ($t in $lista) {
            $marca = if ($t.Feita) { '[x]' } else { '[ ]' }
            $cor   = if ($t.Feita) { 'DarkGray' } else { 'White' }
            Write-Host ("  {0} #{1} {2}" -f $marca, $t.Id, $t.Texto) -ForegroundColor $cor
        }
        Write-Output "total=$($lista.Count)"
    }
    'concluir' {
        $lista = @(Get-Tarefas)
        $alvo = $lista | Where-Object { $_.Id -eq [int]$Argumento }
        if (-not $alvo) { Write-Error "Tarefa #$Argumento não existe."; exit 1 }
        $alvo.Feita = $true
        Save-Tarefas $lista
        Write-Host ("✓ tarefa #{0} concluída." -f $Argumento) -ForegroundColor Green
        Write-Output "concluir ok id=$Argumento"
    }
    'remover' {
        $lista = @(Get-Tarefas)
        $novo = @($lista | Where-Object { $_.Id -ne [int]$Argumento })
        Save-Tarefas $novo
        Write-Host ("－ tarefa #{0} removida." -f $Argumento) -ForegroundColor Yellow
        Write-Output "remover ok restam=$($novo.Count)"
    }
    default {
        Write-Host "tarefas.ps1 — gerenciador de tarefas em PowerShell" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  add <texto>      adiciona uma tarefa"
        Write-Host "  listar           lista todas"
        Write-Host "  concluir <id>    marca como feita"
        Write-Host "  remover <id>     apaga"
        Write-Host ""
        Write-Host "  -Arquivo <path>  onde guardar (padrão: temp/tarefas.json)"
        Write-Output "ajuda"
    }
}
