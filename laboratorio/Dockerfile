# Laboratório do Curso de PowerShell — ambiente isolado e reproduzível.
# Usa a imagem oficial da Microsoft (PowerShell 7 multiplataforma).
FROM mcr.microsoft.com/powershell:latest

# Instala as ferramentas usadas no curso: PSScriptAnalyzer (linter) e Pester (testes).
RUN pwsh -NoProfile -Command " \
      Set-PSRepository PSGallery -InstallationPolicy Trusted; \
      Install-Module PSScriptAnalyzer -Scope AllUsers -Force; \
      Install-Module Pester -Scope AllUsers -Force -SkipPublisherCheck "

# O repositório é montado como volume em /curso (veja entrar.sh).
WORKDIR /curso
CMD ["pwsh"]
