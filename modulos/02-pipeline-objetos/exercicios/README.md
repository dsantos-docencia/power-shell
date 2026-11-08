# 🏋️ Exercícios — Módulo 02

Corrija com `./ferramentas/corrigir.ps1 02`. Soluções em [solucoes/](solucoes/).

### 01 — Maiores por extensão · `01-maiores-log.ps1`
Recebe um diretório em `$Caminho` e imprime os **nomes** dos arquivos `.log` dele, do **maior para o menor** (um por linha, só o nome). Dica: `Where-Object`, `Sort-Object Length -Descending`, `Select-Object -ExpandProperty Name`.

### 02 — Soma por chave · `02-total-por-vendedor.ps1`
Recebe um caminho de CSV em `$Csv` (colunas `Vendedor,Valor`) e imprime, **em ordem alfabética de vendedor**, uma linha por vendedor no formato `NOME: TOTAL` (soma dos valores). Dica: `Import-Csv`, `Group-Object`, `Measure-Object -Sum`.

### 03 — Propriedade calculada · `03-tamanho-kb.ps1`
Recebe um diretório em `$Caminho` e imprime o **nome e o tamanho em KB** (arredondado a 1 casa) de cada arquivo, no formato `nome=KB`, ordenado por tamanho decrescente. Dica: propriedade calculada `@{Name=...;Expression={...}}` e `[math]::Round(.../1kb,1)`.
