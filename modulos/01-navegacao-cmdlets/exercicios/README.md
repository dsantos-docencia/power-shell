# 🏋️ Exercícios — Módulo 01

Corrija com `./ferramentas/corrigir.ps1 01`. Soluções em [solucoes/](solucoes/).

### 01 — Contar por tipo · `01-contar-tipos.ps1`
Recebe um diretório em `$Caminho` e imprime **duas linhas**, exatamente:
```
arquivos: N
diretorios: M
```
N = nº de arquivos e M = nº de diretórios **dentro** dele (recursivo). Dica: `Get-ChildItem -Recurse -File` e `-Directory`.

### 02 — Resolver alias · `02-resolver-alias.ps1`
Recebe um alias em `$Alias` e imprime o **nome do cmdlet** para o qual ele aponta (ex.: `gci` → `Get-ChildItem`). Se não for um alias, imprima `nao-e-alias` e saia com código 1. Dica: `Get-Alias`.

### 03 — Maior arquivo · `03-maior-arquivo.ps1`
Recebe um diretório em `$Caminho` e imprime **apenas o nome** do maior arquivo (recursivo). Dica: `Sort-Object Length -Descending | Select-Object -First 1`.
