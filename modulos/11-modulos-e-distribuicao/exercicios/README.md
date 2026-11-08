# 🏋️ Exercícios — Módulo 11

Corrija com `./ferramentas/corrigir.ps1 11`. Soluções em [solucoes/](solucoes/).
Tema: os detalhes que separam "um script" de **um pacote distribuível**.

### 01 — Comando qualificado · `01-comando-qualificado.ps1`
Recebe `[string]$Modulo` e `[string]$Comando` e imprime o nome totalmente qualificado `Modulo\Comando` — a forma de desambiguar quando dois módulos exportam o mesmo comando. Ex.: `Pester` + `Invoke-Pester` → `Pester\Invoke-Pester`.
> Dica: a barra invertida `\` em string com aspas duplas precisa de atenção; lembre que `$` interpola.

### 02 — Próxima minor · `02-proxima-minor.ps1`
Recebe um semver `"MAJOR.MINOR.PATCH"` e devolve a **próxima MINOR, zerando o patch**. Ex.: `"1.4.7"` → `"1.5.0"`.
> Dica: `Split('.')`, incremente o índice 1 e force o patch para `0`. Subir minor **sempre** zera o patch — é o que deixa a atualização previsível.

### 03 — Exports ordenados · `03-ordenar-exports.ps1`
Recebe nomes de funções separados por vírgula e imprime **ordenados** alfabeticamente, unidos por `", "` — um `FunctionsToExport` legível e fácil de revisar. Ex.: `"Get-B,Set-A,Get-A"` → `"Get-A, Get-B, Set-A"`.
> Dica: `Split(',')`, `Trim()` em cada um, `Sort-Object` e `-join ', '`.
