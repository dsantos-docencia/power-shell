# 📂 scripts/ — Acervo de scripts reais

Esta pasta guarda **scripts PowerShell de verdade**, usados em produção e em aula pelo Prof. Daniel Santos. Servem a dois propósitos:

1. **Estudo de caso** — exemplos "de guerra", com dezenas/centenas de linhas, tratamento de erro e logging. Ótimos para ler *depois* do [Módulo 07](../modulos/07-erros-e-debugging/).
2. **Reaproveitamento** — automações prontas para adaptar.

> ⚠️ **Leia antes de executar.** Vários destes scripts **alteram o sistema** (manutenção do Windows, movimentação de arquivos). Rode numa VM ou máquina de teste, nunca direto em produção. São material avançado, não exercícios. Por isso ficam **fora** da verificação automática do curso.

## Categorias

| Pasta | O que é |
|---|---|
| [`manutencao-windows/`](manutencao-windows/) | Rotina de manutenção do Windows 11 (limpeza, verificações, otimização). |
| [`organizacao-arquivos/`](organizacao-arquivos/) | Utilitários de consolidação de pastas/repos e varredura de downloads. |
| [`comunidade/`](comunidade/) | Catálogo colaborativo — scripts enviados pela comunidade, curados e creditados. |

## 🔎 Curadoria

Os scripts que já existiam no repositório foram **organizados por categoria** (sem alterar o conteúdo):

| Script | Categoria | Origem |
|---|---|---|
| `manutencao-windows11.ps1` | manutenção Windows | `Manutencao_Windows11_Daniel_v1.ps1` |
| `consolidar-nao-gitados.ps1` | organização de arquivos | — |
| `consolidar-novos.ps1` | organização de arquivos | — |
| `scan-downloads.ps1` | organização de arquivos | — |

Um arquivo ficou em [`_a-revisar-exclusao/`](_a-revisar-exclusao/): `agencia-conta-wagner.ps1` — o nome sugere algo específico de cliente, mas o conteúdo é um **gerador genérico de relatório de sistema**. **Nada foi apagado**; está lá para você decidir se mantém, renomeia ou remove. (Checado: não contém senhas nem dados sensíveis.)

<sub>© 2026 Prof. Daniel Santos · Scripts sob PolyForm Noncommercial (não comercial) · veja o aviso de uso acima.</sub>
