#!/usr/bin/env bash
set -u

CERT_FILE="${1}"
DOMAIN="${2}"

if [[ -z "${CERT_FILE}" ]] || [[ -z "${DOMAIN}" ]]; then
    echo "Usage: $0 <certificate-file> <domain>" >&2
    exit 1
fi

if [[ ! -f "${CERT_FILE}" ]]; then
    echo "Certificate file not found: ${CERT_FILE}" >&2
    exit 1
fi

if command -v cygpath >/dev/null 2>&1; then
    CERT_FILE_WIN="$(cygpath -w "${CERT_FILE}")"
else
    CERT_FILE_WIN="$(printf '%s' "${CERT_FILE}" | sed -E 's#^/([A-Za-z])/#\1:/#' | sed 's#/#\\#g')"
fi

# Trust into CurrentUser\Root so no admin elevation is required.
certutil -user -delstore Root "${DOMAIN}" >/dev/null 2>&1 || true

certutil -user -addstore -f Root "${CERT_FILE_WIN}"
