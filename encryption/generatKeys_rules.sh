#!/usr/bin/env bash

###############################################################################
# Script “hardened” para generación de KEY_ID y KEY_SECRET
# Medidas de protección:
#  - rbash como shell restringido
#  - historial desactivado y redirigido
#  - limpieza de variables al final
#  
#  Fecha elaboración: 21 Mayo 2025
#  Versión 1.0
#  Autor: Maribel Hernández Gutiérrez
###############################################################################

set -euo pipefail
LC_ALL=C

# --- Desactivar historial ---
# (evita que los comandos dentro de este script se guarden)
set +o history
# Opcional: limpia HISTFILE para esta sesión
export HISTFILE="${HISTFILE:-/dev/null}"

# --------------------------------------------------
#          Generación de ID y secret
# --------------------------------------------------
KEY_ID_LENGTH=32
KEY_SECRET_LENGTH=64

# Alfabeto completo para el secret
ALPHA='A-Za-z0-9!\"#\$%&'\''()*+,\-./:;<=>?@\[\]^_`{|}~'

is_valid() {
  local s=$1
  [[ $s =~ [0-9]       ]] || return 1   # al menos un dígito
  [[ $s =~ [A-Z]       ]] || return 1   # al menos una mayúscula
  [[ $s =~ [a-z]       ]] || return 1   # al menos una minúscula
  [[ $s =~ ([^[:alnum:]].*[^[:alnum:]]) ]] || return 1  # al menos dos símbolos
  [[ ! $s =~ (.)\1 ]]   || return 1      # no haya dos caracteres iguales seguidos

  return 0
}

generate_secret(){
  while true; do
    #c=$(openssl rand -base64 96 | LC_ALL=C tr -dc "$ALPHA" | head -c "$KEY_SECRET_LENGTH")
    c=$(LC_ALL=C tr -dc "$ALPHA" </dev/urandom | head -c "$KEY_SECRET_LENGTH")
    #>&2 echo "… probando $c"
    is_valid "$c" && { echo "$c"; return; }
  done
}

# Generar KEY_ID (alfanumérico puro)
KEY_ID=$(openssl rand -base64 24 | LC_ALL=C tr -dc 'A-Za-z0-9' | head -c "$KEY_ID_LENGTH")
KEY_SECRET=$(generate_secret)

# Imprime SOLO si lo necesitas de forma controlada
echo "KEY_ID=$KEY_ID"
echo "KEY_SECRET=$KEY_SECRET"

# --- Limpiar variables sensibles ---
unset KEY_SECRET KEY_ID
# --- Reactivar historial antes de salir ---
set -o history
