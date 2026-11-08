# 📂 scripts/ — Collection of real scripts

**🌍 Language / Idioma:** **English** · [Português](README.md)

This folder holds **real PowerShell scripts**, used in production and in class by Prof. Daniel Santos. They serve two purposes:

1. **Case studies** — "battle-tested" examples, with dozens/hundreds of lines, error handling, and logging. Great to read *after* [Module 07](../modulos/07-erros-e-debugging/README.en.md).
2. **Reuse** — ready-made automations to adapt.

> ⚠️ **Read before running.** Several of these scripts **change the system** (Windows maintenance, moving files). Run them in a VM or test machine, never straight into production. They're advanced material, not exercises. That's why they stay **out** of the course's automated verification.

## Categories

| Folder | What it is |
|---|---|
| [`manutencao-windows/`](manutencao-windows/) | Windows 11 maintenance routine (cleanup, checks, optimization). |
| [`organizacao-arquivos/`](organizacao-arquivos/) | Utilities for consolidating folders/repos and scanning downloads. |
| [`comunidade/`](comunidade/README.en.md) | Collaborative catalog — scripts submitted by the community, curated and credited. |

## 🔎 Curation

The scripts that already existed in the repo were **organized by category** (without changing their content):

| Script | Category | Origin |
|---|---|---|
| `manutencao-windows11.ps1` | Windows maintenance | `Manutencao_Windows11_Daniel_v1.ps1` |
| `consolidar-nao-gitados.ps1` | file organization | — |
| `consolidar-novos.ps1` | file organization | — |
| `scan-downloads.ps1` | file organization | — |

One file was left in [`_a-revisar-exclusao/`](_a-revisar-exclusao/README.en.md): `agencia-conta-wagner.ps1` — the name suggests something client-specific, but the content is a **generic system-report generator**. **Nothing was deleted**; it's there for you to decide whether to keep, rename, or remove it. (Checked: it contains no passwords or sensitive data.)

<sub>© 2026 Prof. Daniel Santos · Scripts under PolyForm Noncommercial (noncommercial) · see the usage notice above.</sub>
