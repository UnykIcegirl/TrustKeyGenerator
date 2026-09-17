#!/usr/bin/env bash

# Script “hardened” para descifrar una clave cifrada con OpenSSL
# Medidas de protección:
#  - No se registre en historial del shell
#  - No se impriman secretos en consola
#  - Se almacenen temporalmente en un archivo
#  - Se limpie al finalizar
#  
#  Fecha elaboración: 21 MAyo 2025
#  Versión 1.0
#  Autor: Maribel Hernández Gutiérrez

# Script seguro para desencriptar claves cifradas con openssl
set -euo pipefail
LC_ALL=C

# --- Desactivar historial temporalmente ---
set +o history
export HISTFILE=/dev/null

# --- Solicitar archivo de entrada ---
read -rp "📂 Nombre del archivo cifrado (.enc): " ENC_FILE
[[ -f "$ENC_FILE" ]] || { echo "❌ Archivo no encontrado."; exit 1; }

# --- Archivo temporal para output ---
TEMPFILE=$(mktemp)

# --- Solicitar passphrase y descifrar ---
echo "🔐 Introduce la passphrase para descifrar:"
openssl enc -d -aes-256-cbc -in "$ENC_FILE" -out "$TEMPFILE"

echo "✅ Claves desencriptadas se guardaron temporalmente en: $TEMPFILE"

# --- Mostrar con editor adecuado sin imprimir en consola ---
if command -v nano &>/dev/null; then
    nano "$TEMPFILE"
elif command -v vi &>/dev/null; then
    vi "$TEMPFILE"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    open -e "$TEMPFILE"  # TextEdit en macOS
else
    echo "ℹ️ Puedes abrir el archivo temporal manualmente: $TEMPFILE"
fi

# --- Esperar acción del usuario ---
read -rsp $'\nPresiona ENTER para eliminar el archivo temporal...'

# --- Limpieza segura ---
if command -v shred &>/dev/null; then
    shred -u "$TEMPFILE"
else
    rm -f "$TEMPFILE"
fi

# --- Reactivar historial ---
set -o history
echo "🧼 Archivo temporal eliminado de forma segura."
