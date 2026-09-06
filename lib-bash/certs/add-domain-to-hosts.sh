#!/usr/bin/env bash
# @module hostsfile
# Provides cross-platform functions to add domain entries to the system hosts file.
# Supports macOS, Linux, and Windows (with manual instructions).
#
# Usage:
#   hostsfile::add_domain_to_hosts "example.local" "127.0.0.1"
#   hostsfile::add_domain_to_hosts "sub.example.local"  # defaults to 127.0.0.1

set -u

[[ -n "${_HOSTSFILE_ADD_DOMAIN_LOADED:-}" ]] && return 0 2>/dev/null || true
_HOSTSFILE_ADD_DOMAIN_LOADED=1

_HOSTSFILE_SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=/dev/null
. "$_HOSTSFILE_SCRIPT_DIR/../header.sh"

load_module "os-detection"

# Private helper: validate IPv4 address format (0.0.0.0 - 255.255.255.255)
_hostsfile::validate_ip() {
	local ip="${1:-}"
	local octet

	if ! [[ "${ip}" =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
		return 1
	fi

	# Validate each octet is 0-255
	for octet in "${BASH_REMATCH[@]:1}"; do
		[[ ${octet} -le 255 ]] || return 1
	done
	return 0
}

hostsfile::add_domain_to_hosts_macos() {
	local domain="${1:-}"
	local ip_address="${2:-127.0.0.1}"
	local hosts_file="/etc/hosts"

	if [[ -z "${domain}" ]]; then
		printf 'Usage: hostsfile::add_domain_to_hosts_macos <domain> [ip]\n' >&2
		return 1
	fi

	if ! _hostsfile::validate_ip "${ip_address}"; then
		printf 'Invalid IP address: %s\n' "${ip_address}" >&2
		return 1
	fi

	# Use grep -F (fixed string) for safety; grep with literal domain/IP pattern
	if grep -F "${ip_address}" "${hosts_file}" | grep -q "${domain}"; then
		printf 'Host entry already exists: %s -> %s\n' "${domain}" "${ip_address}"
		return 0
	fi

	printf 'Adding host entry: %s -> %s\n' "${domain}" "${ip_address}"
	printf '%s\t%s\n' "${ip_address}" "${domain}" | sudo tee -a "${hosts_file}" >/dev/null
	if [[ $? -eq 0 ]]; then
		return 0
	else
		printf 'Failed to add host entry: %s -> %s\n' "${domain}" "${ip_address}" >&2
		return 1
	fi
}

hostsfile::add_domain_to_hosts_linux() {
	local domain="${1:-}"
	local ip_address="${2:-127.0.0.1}"
	local hosts_file="/etc/hosts"

	if [[ -z "${domain}" ]]; then
		printf 'Usage: hostsfile::add_domain_to_hosts_linux <domain> [ip]\n' >&2
		return 1
	fi

	if ! _hostsfile::validate_ip "${ip_address}"; then
		printf 'Invalid IP address: %s\n' "${ip_address}" >&2
		return 1
	fi

	if grep -F "${ip_address}" "${hosts_file}" | grep -q "${domain}" 2>/dev/null; then
		printf 'Host entry already exists: %s -> %s\n' "${domain}" "${ip_address}"
		return 0
	fi

	printf 'Adding host entry: %s -> %s\n' "${domain}" "${ip_address}"
	printf '%s\t%s\n' "${ip_address}" "${domain}" | sudo tee -a "${hosts_file}" >/dev/null
	if [[ $? -eq 0 ]]; then
		return 0
	else
		printf 'Failed to add host entry: %s -> %s\n' "${domain}" "${ip_address}" >&2
		return 1
	fi
}

_hostsfile::windows_hosts_file() {
	if command -v cygpath >/dev/null 2>&1; then
		cygpath -u "${SYSTEMROOT:-C:\\Windows}\\System32\\drivers\\etc\\hosts"
		return
	fi
	printf '/c/Windows/System32/drivers/etc/hosts\n'
}

_hostsfile::windows_hosts_file_win() {
	local posix_path="$1"
	if command -v cygpath >/dev/null 2>&1; then
		cygpath -w "${posix_path}"
		return
	fi
	printf '%s' "${posix_path}" | sed -E 's#^/([A-Za-z])/#\1:/#' | sed 's#/#\\#g'
}

# Elevated append fallback: writes a tiny temp .ps1 that runs Add-Content, then
# launches it via Start-Process -Verb RunAs so only that one append is elevated
# (avoids fragile multi-level quoting through -ArgumentList one-liners).
_hostsfile::elevated_append_windows() {
	local hosts_file_win="$1"
	local line="$2"
	local ps1 ps1_win

	ps1="$(mktemp --suffix=.ps1 2>/dev/null)" || ps1="/tmp/hostsfile-append-$$.ps1"
	# -Encoding ASCII matches the hosts file's plain-ASCII default, so a repeat
	# append never flips it to UTF-16 (which would break the bash-side dedup grep).
	printf 'Add-Content -Path "%s" -Value "%s" -Encoding ASCII\n' "${hosts_file_win}" "${line}" > "${ps1}"
	ps1_win="$(_hostsfile::windows_hosts_file_win "${ps1}")"

	powershell -NoProfile -Command \
		"Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','${ps1_win}' -Verb RunAs -Wait"
	local rc=$?
	rm -f "${ps1}"
	return $rc
}

hostsfile::add_domain_to_hosts_windows() {
	local domain="${1:-}"
	local ip_address="${2:-127.0.0.1}"
	local hosts_file line

	if [[ -z "${domain}" ]]; then
		printf 'Usage: hostsfile::add_domain_to_hosts_windows <domain> [ip]\n' >&2
		return 1
	fi

	if ! _hostsfile::validate_ip "${ip_address}"; then
		printf 'Invalid IP address: %s\n' "${ip_address}" >&2
		return 1
	fi

	hosts_file="$(_hostsfile::windows_hosts_file)"
	line="$(printf '%s\t%s' "${ip_address}" "${domain}")"

	if [[ -f "${hosts_file}" ]] && grep -F "${ip_address}" "${hosts_file}" | grep -q "${domain}"; then
		printf 'Host entry already exists: %s -> %s\n' "${domain}" "${ip_address}"
		return 0
	fi

	printf 'Adding host entry: %s -> %s\n' "${domain}" "${ip_address}"

	if printf '%s\n' "${line}" >> "${hosts_file}" 2>/dev/null; then
		return 0
	fi

	if _hostsfile::elevated_append_windows "$(_hostsfile::windows_hosts_file_win "${hosts_file}")" "${line}"; then
		return 0
	fi

	printf 'Failed to add host entry: %s -> %s\n' "${domain}" "${ip_address}" >&2
	printf 'Manually add this line to %s: %s\n' "$(_hostsfile::windows_hosts_file_win "${hosts_file}")" "${line}" >&2
	return 1
}

hostsfile::add_domain_to_hosts() {
	local domain="${1:-}"
	local ip_address="${2:-127.0.0.1}"

	if [[ -z "${domain}" ]]; then
		printf 'Usage: hostsfile::add_domain_to_hosts <domain> [ip]\n' >&2
		return 1
	fi

	if is_macos; then
		hostsfile::add_domain_to_hosts_macos "${domain}" "${ip_address}"
		return $?
	fi

	if is_linux; then
		hostsfile::add_domain_to_hosts_linux "${domain}" "${ip_address}"
		return $?
	fi

	if is_windows; then
		hostsfile::add_domain_to_hosts_windows "${domain}" "${ip_address}"
		return $?
	fi

	printf 'Unsupported OS: %s\n' "${OS:-unknown}" >&2
	return 1
}

# Allow direct script usage while still supporting source-as-module usage.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	hostsfile::add_domain_to_hosts "$@"
fi
