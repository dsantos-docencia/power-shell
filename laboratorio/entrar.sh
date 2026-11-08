#!/usr/bin/env bash
# ============================================================================
#  Curso de PowerShell — laboratorio/entrar.sh
#  Abre um shell pwsh dentro do container do curso, com o repositório montado.
#  Prof. Daniel Santos · github.com/dsantos-docencia/power-shell · © 2026 (PolyForm-NC)
# ============================================================================
set -euo pipefail
RAIZ="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGEM="curso-powershell:lab"

if ! command -v docker >/dev/null; then
    echo "Docker não encontrado. Instale em https://docs.docker.com/get-docker/" >&2
    echo "Sem Docker, você pode usar o curso direto no seu PowerShell 7 (pwsh)." >&2
    exit 1
fi

if ! docker image inspect "$IMAGEM" >/dev/null 2>&1; then
    echo "Construindo a imagem do laboratório (só na primeira vez)…"
    docker build -t "$IMAGEM" "$RAIZ/laboratorio"
fi

echo "Entrando no laboratório. O repositório está em /curso. Digite 'exit' para sair."
exec docker run --rm -it -v "$RAIZ:/curso" "$IMAGEM" pwsh
