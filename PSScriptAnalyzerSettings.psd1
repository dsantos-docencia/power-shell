@{
    # Configuração do PSScriptAnalyzer para o curso.
    # Reportamos avisos e erros. As regras abaixo são excluídas por conflitarem
    # com decisões LEGÍTIMAS deste repositório (não para "passar de qualquer jeito"):
    Severity = @('Error', 'Warning')

    ExcludeRules = @(
        # Funções do nosso mini-framework ('Teste-*', 'Afirmar-*') usam verbos
        # não aprovados DE PROPÓSITO, para ficarem legíveis em português.
        'PSUseApprovedVerbs',

        # Curso CROSS-PLATFORM: usamos UTF-8 SEM BOM (padrão do PowerShell 7 e
        # do mundo Linux/macOS). BOM atrapalha ferramentas Unix. Regra não se aplica.
        'PSUseBOMForUnicodeEncodedFile',

        # As FERRAMENTAS (corrigir/verificar) e exemplos interativos usam Write-Host
        # para a interface colorida no console — uso legítimo. O curso ensina, no
        # Módulo 03, QUANDO Write-Host é um anti-pattern (scripts que emitem dados)
        # e quando é correto (saída para o usuário). A lição está no texto, não aqui.
        'PSAvoidUsingWriteHost',

        # Nosso mini-framework de testes expõe $global:SAIDA/$global:STATUS por
        # design, para os arquivos de teste lerem. É uma escolha de arquitetura.
        'PSAvoidGlobalVars',

        # Nomes de função em PORTUGUÊS (ex.: 'Invoke-Testes') não seguem a regra
        # de substantivo singular do inglês. Não se aplica a este curso.
        'PSUseSingularNouns'
    )
}
