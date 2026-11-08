<#
============================================================================
  Curso de PowerShell · Módulo 08 · Exemplo 02 — Classes e enums
  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
----------------------------------------------------------------------------
  OBJETIVO  Definir class e enum com construtor, propriedades e métodos ($this).
  EXECUTE   pwsh ./02-classe-e-enum.ps1
============================================================================
#>
Set-StrictMode -Version Latest

enum Prioridade {
    Baixa  = 1
    Media  = 2
    Alta   = 3
}

class Servidor {
    [string]$Nome
    [Prioridade]$Prioridade
    [int]$CPU

    # Construtor: roda ao criar com [Servidor]::new(...)
    Servidor([string]$nome, [Prioridade]$prio) {
        $this.Nome = $nome
        $this.Prioridade = $prio
        $this.CPU = 0
    }

    # Método que ALTERA o estado (retorna void)
    [void] RegistrarCPU([int]$valor) {
        $this.CPU = $valor
    }

    # Método que RETORNA um valor
    [bool] EstaSobrecarregado() {
        return $this.CPU -gt 80
    }

    # Sobrescreve a representação em texto
    [string] ToString() {
        return "$($this.Nome) [$($this.Prioridade)] CPU=$($this.CPU)%"
    }
}

Write-Output '1) Criando objetos a partir da classe:'
$web = [Servidor]::new('web-01', [Prioridade]::Alta)
$db  = [Servidor]::new('db-01',  [Prioridade]::Media)
"   $($web.ToString())" | Write-Output
"   $($db.ToString())"  | Write-Output

Write-Output ''
Write-Output '2) Chamando métodos ($this altera/consulta o próprio objeto):'
$web.RegistrarCPU(90)
$db.RegistrarCPU(40)
"   web-01 sobrecarregado? $($web.EstaSobrecarregado())" | Write-Output
"   db-01 sobrecarregado?  $($db.EstaSobrecarregado())"  | Write-Output

Write-Output ''
Write-Output '3) O enum dá valores nomeados e tipados:'
"   [Prioridade]::Alta vale $([int][Prioridade]::Alta)" | Write-Output
"   todos os níveis: $([enum]::GetNames([Prioridade]) -join ', ')" | Write-Output

Write-Output ''
Write-Output '4) Uma coleção de objetos da classe é tabular como qualquer outra:'
@($web, $db) | Sort-Object CPU -Descending |
    ForEach-Object { "   $($_.Nome): CPU $($_.CPU)%" | Write-Output }
