# TrustKeyGenerator

Herramienta para la generación segura de llaves criptográficas, secretos y mecanismos de intercambio de claves, alineada con buenas prácticas de seguridad y recomendaciones de NIST.

## Descripción

TrustKeyGenerator es un conjunto de utilidades orientadas a la gestión segura de llaves y secretos para entornos de desarrollo, integración y seguridad de aplicaciones.

El proyecto incorpora mecanismos para:

- Generación de API Keys de 256 bits.
- Generación de Key ID de 128 bits.
- Validación criptográfica de secretos.
- Self-test de generadores aleatorios criptográficos (CSPRNG).
- Cifrado y descifrado de llaves.
- Generación de llaves públicas y privadas mediante Diffie-Hellman.
- Intercambio seguro de secretos entre sistemas.

## Funcionalidades

### Generación Segura de API Keys

Genera claves con:

- 256 bits de entropía real.
- Codificación Base64 URL Safe.
- Validación automática.
- Compatibilidad con Linux, macOS y BSD.

### Utilidades de Cifrado

Incluye scripts para:

- Cifrar información sensible.
- Descifrar información protegida.
- Gestionar secretos para integraciones.

### Intercambio Seguro de Llaves

Implementación de Diffie-Hellman para:

- Generación de llave privada.
- Generación de llave pública.
- Cálculo de secreto compartido.
- Validación de intercambio seguro.

## Estándares Considerados

- NIST SP 800-63B
- NIST SP 800-90A
- RFC 4086
- ISO/IEC 27001
- OWASP API Security Top 10
- OWASP ASVS

## Casos de Uso

- Autenticación de APIs.
- Gestión de credenciales.
- Integraciones entre sistemas.
- Intercambio seguro de claves.
- Laboratorios de criptografía aplicada.
- Arquitectura Segura y Application Security.

## Estructura del Proyecto

```text
TrustKeyGenerator/
│
├── generarKeys_rules.sh
├── generarKeys_rules_cifrado.sh
├── desencriptar_keys.sh
├── TrustKeyGenerator.sh
├── GeneracionLlaveDF-PubPriv.py
└── README.md
```

## Evolución del Proyecto

### Versión 1.0

Funcionalidades iniciales:

- Generación de llaves.
- Cifrado de secretos.
- Descifrado de secretos.

### Versión 2.0

Fortalecimiento criptográfico:

- Generación de API Keys de 256 bits.
- Validación criptográfica.
- Self-test del CSPRNG.
- Validación de entropía.

### Versión 2.1

Intercambio seguro de llaves:

- Implementación Diffie-Hellman.
- Llaves públicas y privadas.
- Generación de secretos compartidos.

## Autor

Maribel Hernández Gutiérrez

Líder de Seguridad en Aplicaciones | AppSec | Arquitectura Segura

## Licencia

Proyecto de uso educativo y demostrativo para prácticas de criptografía aplicada, gestión de secretos y seguridad de aplicaciones.
