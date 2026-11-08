# 🌐 Recursos: comunidades, documentação e prática

**🌍 Idioma / Language:** **Português** · [English](recursos.en.md)

Lista curada e comentada. Nem tudo é igual — abaixo, o que vale o seu tempo.

## 📘 Documentação oficial (a fonte da verdade)

- **[Microsoft Learn — PowerShell](https://learn.microsoft.com/powershell/)** — a documentação oficial, completa e atualizada. Também disponível offline com `Get-Help` (rode `Update-Help` primeiro). Quando houver dúvida sobre comportamento, é aqui que se confere.
- **[Referência de cmdlets por módulo](https://learn.microsoft.com/powershell/module/)** — a doc de cada cmdlet nativo, com exemplos.
- **[about_ topics](https://learn.microsoft.com/powershell/scripting/learn/ps101/00-introduction)** — os guias conceituais (`about_Operators`, `about_Splatting`…), acessíveis também via `Get-Help about_*`.

## 🏆 As melhores referências da comunidade

- **[PowerShell/PowerShell (GitHub)](https://github.com/PowerShell/PowerShell)** — o repositório oficial: downloads, changelog, issues. É o próprio produto, aberto.
- **[PowerShell Gallery](https://www.powershellgallery.com/)** — o repositório público de módulos (o "npm/PyPI" do PowerShell). Veja o [Módulo 11](../modulos/11-modulos-e-distribuicao/).
- **["Learn PowerShell in a Month of Lunches"](https://www.manning.com/books/learn-powershell-in-a-month-of-lunches-fourth-edition)** — o livro de referência para aprender PowerShell do zero, de Don Jones e Jeffery Hicks.
- **[The PowerShell Best Practices and Style Guide](https://github.com/PoshCode/PowerShellPracticeAndStyle)** — convenções de estilo mantidas pela comunidade.
- **[PowerShell.org](https://powershell.org/)** — fóruns, artigos e a conferência PowerShell + DevOps Global Summit.

## 🔧 Ferramentas que você vai usar sempre

- **[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)** — o linter oficial (o "ShellCheck" do PowerShell). Aponta bugs e más práticas sem executar. Tratado no [Módulo 10](../modulos/10-testes-seguranca-devops/).
- **[Pester](https://pester.dev/)** — o framework de testes padrão. Tratado no [Módulo 10](../modulos/10-testes-seguranca-devops/).
- **[Microsoft.PowerShell.PSResourceGet](https://learn.microsoft.com/powershell/module/microsoft.powershell.psresourceget/)** — o módulo moderno para `Find`/`Install`/`Publish-PSResource` ([Módulo 11](../modulos/11-modulos-e-distribuicao/)).
- **[VS Code + extensão PowerShell](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)** — a melhor experiência: depuração visual, autocompletar e o analyzer enquanto você digita.

## 🏋️ Para praticar

- **[Os exercícios deste curso](../modulos/)** — com correção automática via `./ferramentas/corrigir.ps1`.
- **[Os projetos deste curso](../projetos/)** — automações reais de ponta a ponta.
- **[Exercism — não tem track de PowerShell]**, mas o [track de Bash](https://exercism.org/tracks/bash) ajuda a treinar a lógica de shell com mentoria gratuita.
- **[Microsoft Learn — trilhas de PowerShell](https://learn.microsoft.com/training/browse/?terms=powershell)** — módulos interativos gratuitos.

## 🇧🇷 Em português

- **[Microsoft Learn em português](https://learn.microsoft.com/pt-br/powershell/)** — boa parte da documentação oficial está traduzida.
- **[Comunidades brasileiras de PowerShell](https://powershell.org/)** — grupos no Telegram/Discord e canais no YouTube cobrem PowerShell em português; procure por "PowerShell Brasil".

## 📺 Blogs e canais

- **[PowerShell Team Blog](https://devblogs.microsoft.com/powershell/)** — novidades direto de quem mantém o produto.
- **[r/PowerShell](https://www.reddit.com/r/PowerShell/)** — comunidade ativa, boa para dúvidas e descobertas.

---

> 💡 **Como estudar documentação sem se afogar:** não leia tudo. Use `Get-Help <cmdlet> -Examples` para o uso prático, `Get-Command` para descobrir e `Get-Member` para inspecionar. Veja [pedir-ajuda.md](pedir-ajuda.md).

<sub>© 2026 Prof. Daniel Santos · CC BY-NC-SA 4.0</sub>
