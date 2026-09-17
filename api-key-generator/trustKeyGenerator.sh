#!/usr/bin/env bash

###############################################################################
# Script endurecido para generar API Keys 256 bits Base64 URL-safe
# Compatible: macOS, Linux, BSD
# Cumple: NIST SP 800‑63B · NIST SP 800‑90A · RFC 4086 · ISO 27001 · OWASP API Security
#
#  Fecha elaboración: 20 Marzo 2026
#  Versión 1.0
#  Autor: Maribel Hernández Gutiérrez
###############################################################################

set -euo pipefail

###############################################################################
# Desactivar o aislar historial
###############################################################################
export LC_ALL=C
export LC_CTYPE=C

# Desactivar historial en la sesión
set +o history
export HISTFILE="/dev/null"


###############################################################################
# Tamaños de claves
###############################################################################
# KEY_ID = identificador NO SECRETO (128 bits)
# KEY_SECRET = clave SECRETA (256 bits)
KEY_ID_BYTES=16
KEY_SECRET_BYTES=32

###############################################################################
# 1. SELFTEST CRIPTOGRAFICO (NIST SP 80090A style)
###############################################################################
crypto_self_test() {
    echo "[SELF-TEST] Iniciando validacion criptografica..."

    # Validar funcionamiento de OpenSSL (CSPRNG)
    if ! openssl rand 1 >/dev/null 2>&1; then
        echo "[ERROR] OpenSSL no esta disponible o fall." >&2
        exit 1
    fi

    # Generar 3 muestras para probar entropa y no-repeticin
    local s1 s2 s3
    s1=$(openssl rand -base64 "${KEY_SECRET_BYTES}")
    s2=$(openssl rand -base64 "${KEY_SECRET_BYTES}")
    s3=$(openssl rand -base64 "${KEY_SECRET_BYTES}")

    # Ninguna cadena debe ser vacia
    [[ -z "$s1" || -z "$s2" || -z "$s3" ]] && {
        echo "[ERROR] RNG produjo valores vacios." >&2
        exit 1
    }

    # No deben repetirse entre s
    [[ "$s1" == "$s2" || "$s1" == "$s3" || "$s2" == "$s3" ]] && {
        echo "[ERROR] RNG produjo valores repetidos. Fallo critico del CSPRNG." >&2
        exit 1
    }

    # Confirmar que produce exactamente 32 bytes (256 bits)
    local size
    size=$(echo -n "$s1" | base64 --decode | wc -c | tr -d ' ')
    [[ "$size" -ne "${KEY_SECRET_BYTES}" ]] && {
        echo "[ERROR] RNG no genero 256 bits reales." >&2
        exit 1
    }

    echo "[SELF-TEST] OK — CSPRNG validado."
}

###############################################################################
# 2. Generadores seguros
###############################################################################

# ID NO SECRETO (128 bits)
generate_id() {
    openssl rand -hex "${KEY_ID_BYTES}"
}

# SECRETO 256 BITS  Base64 URL-safe sin truncamiento
# ESTA ES LA PARTE MAS IMPORTANTE
generate_secret() {
    # 1. Genera 32 bytes reales
    # 2. Base64 estándar con OpenSSL (estable en macOS)
    # 3. Convertir a URL-safe sin eliminar padding (NUNCA borrar '=')
    openssl rand "${KEY_SECRET_BYTES}" \
        | openssl base64 -A \
        | tr '+/' '-_'
}

generate_secretHEX() {
    openssl rand -hex "${KEY_SECRET_BYTES}"
}

###############################################################################
# 3. Validador universal (macOS + Linux)
###############################################################################
validate_apikey() {
    local key="$1"
    #echo "$key"

    echo "[VALIDATOR] Validando APIKEY"

    # 1. Verificar que no esté vacía
    [[ -z "$key" ]] && { echo "[ERROR] APIKEY vacía"; exit 1; }

    # Debe contener solo Base64 URL-safe con padding opcional
    if ! [[ "$key" =~ ^[A-Za-z0-9_-]+=*$ ]]; then
        echo "[ERROR] APIKEY contiene caracteres no validos."
        exit 1
    fi

    # Validar 256 bits exactos despus de convertir de vuelta a base64 estndar
    local restored
    restored=$(echo "$key" | tr '_-' '/+' )

    local bytes
    bytes=$(echo -n "$restored" | base64 --decode 2>/dev/null | wc -c | tr -d ' ')

    if [[ "$bytes" -ne "${KEY_SECRET_BYTES}"  ]]; then
        echo "[ERROR] APIKEY NO tiene 256 bits reales (bytes detectados: $bytes)"
        exit 1
    fi

    echo -n "$key" | tr '_-' '/+' | openssl base64 -d | wc -c

    echo "[VALIDATOR] OK  APIKEY valida (256 bits reales)."
}

# Validar en terminal
# echo -n "WL40N9jkTZ2GbuF-sNZcBS6mb1Shwsh-gIROnxmiLSo=" \
#   | tr '_-' '/+' \
#   | base64 --decode \
#   | wc -c
# 

###############################################################################
# 4. Ejecucion
###############################################################################
crypto_self_test

KEY_ID=$(generate_id)
KEY_SECRET=$(generate_secret)
KEY_SECRETHEX="$(generate_secretHEX)"

validate_apikey "$KEY_SECRET"

echo "------------------------------------------"
echo " APIKEY GENERADA EXITOSAMENTE"
echo "------------------------------------------"
echo "KEY_ID     = $KEY_ID"
echo "KEY_SECRET = $KEY_SECRET"
echo "KEY_SECRETHEX = $KEY_SECRETHEX"
echo "------------------------------------------"

###############################################################################
# Limpieza de variables sensibles
###############################################################################
unset KEY_ID
unset KEY_SECRET
unset KEY_SECRETHEX

# Reactivar historial para no afectar sesión global
set -o history
