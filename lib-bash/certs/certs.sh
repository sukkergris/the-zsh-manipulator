#!/usr/bin/env bash

# Bash version of pragma once
[[ -n "${_CERTS_LOADED:-}" ]] && return 0
_CERTS_LOADED=1

_CERTS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# ------------------------------------------------------------------
# create_dummy_cert [OUT_DIR]
#
# Creates a minimal self-signed cert — no SAN, no passphrase, 10-year validity.
# Used as a placeholder so nginx can start before a real cert exists.
# LESSON: "${1:-$PROJECT_ROOT/nginx/ssl}" is a default-value substitution.
# If $1 is unset or empty, use the fallback on the right of :-.
# ------------------------------------------------------------------
create_dummy_cert() {
  local out_dir="${1:-$PROJECT_ROOT/nginx/ssl}"

  mkdir -p "$out_dir"
  # MSYS2_ARG_CONV_EXCL excludes just the "/CN=..." value from Git Bash's path
  # conversion (which would otherwise mangle it into a Windows path before it
  # reaches openssl.exe), while leaving -out/-keyout path conversion intact.
  MSYS2_ARG_CONV_EXCL="/CN=" openssl req -x509 -nodes \
    -newkey rsa:2048 \
    -days 3650 \
    -out "$out_dir/dummy.crt" \
    -keyout "$out_dir/dummy.key" \
    -subj "/CN=_"
}

create_selfsigned_cert() {
  local cert_name="${1:?cert_name is required}"
  local days="${2}"
  local cert_dir="${3:?cert_dir is required}"
  local cnf_file="${4:?cnf_file is required}"

  openssl genrsa -out "${cert_dir}/$cert_name.key" 2048

  openssl req -x509 -new \
    -key "$cert_dir/$cert_name.key" \
    -sha256 -days "$days" \
    -out "$cert_dir/$cert_name.crt" \
    -config "${cnf_file}" \
    -extensions v3_req

  chmod 644 "$cert_dir/$cert_name.crt" "$cert_dir/$cert_name.key"
}

create_selfsigned_cert_letsencrypt_like() {
  local cert_name="${1:?cert_name is required}"
  local days="${2:?days is required}"
  local cert_dir="${3:?cert_dir is required}"
  local cnf_file="${4:?cnf_file is required}"

  create_selfsigned_cert \
    "$cert_name" \
    "$days" \
    "$cert_dir" \
    "$cnf_file" || return 1

  cp "${cert_dir}/${cert_name}.key" \
    "${cert_dir}/privkey.pem" || return 1

  cp "${cert_dir}/${cert_name}.crt" \
    "${cert_dir}/cert.pem" || return 1

  cp "${cert_dir}/${cert_name}.crt" \
    "${cert_dir}/fullchain.pem" || return 1

  chmod 600 "${cert_dir}/privkey.pem"
  chmod 644 \
    "${cert_dir}/cert.pem" \
    "${cert_dir}/fullchain.pem"
}
# ------------------------------------------------------------------
# trust_dev_cert CERT_FILE DOMAIN
#
# Routes certificate trust to the platform-specific implementation.
# ------------------------------------------------------------------
trust_dev_cert() {
  local cert_file="$1"
  local domain="$2"

  # Trust-store installation is host-level and should not run from containers.
  if (declare -F is_container_runtime >/dev/null && is_container_runtime) || [[ -f "/.dockerenv" ]] || [[ -f "/run/.containerenv" ]]; then
    printf 'Refusing to trust cert inside container runtime. Run this step on host instead.\n' >&2
    printf 'Detected container while processing domain: %s\n' "$domain" >&2
    return 1
  fi

  if is_macos; then
    bash "$_CERTS_DIR/trust-dev-cert.macos.sh" "$cert_file" "$domain"
    return $?
  fi

  if [[ "${IS_WSL:-false}" == "true" ]]; then
    bash "$_CERTS_DIR/trust-dev-cert.windows.sh" "$cert_file" "$domain"
    return $?
  fi

  if is_linux; then
    bash "$_CERTS_DIR/trust-dev-cert.linux.sh" "$cert_file" "$domain"
    return $?
  fi

  if is_windows; then
    bash "$_CERTS_DIR/trust-dev-cert.windows.sh" "$cert_file" "$domain"
    return $?
  fi

  printf 'Unsupported OS: %s\n' "${OS:-unknown}" >&2
  return 1
}
