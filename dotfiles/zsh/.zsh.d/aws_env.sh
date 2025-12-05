aws_update_env() {
  # Default to tanderton_ds, but allow override: aws_update_env some_other_profile
  local profile="${1:-tanderton_ds}"
  local env_file=".env"
  local exports_file=".aws_exports.sh"

  # Run the whole update in a subshell so strict mode / exits don't kill your shell
  (
    set -euo pipefail

    local tmp_export tmp_env_base tmp_env_new
    tmp_export="$(mktemp)"
    tmp_env_base="$(mktemp)"
    tmp_env_new="$(mktemp)"

    cleanup() {
      rm -f "$tmp_export" "$tmp_env_base" "$tmp_env_new" "${tmp_export}.env"
    }
    trap cleanup EXIT

    echo "Logging in to AWS SSO (profile: $profile)..."
    aws sso login --profile "$profile"

    echo "Exporting AWS credentials..."
    if ! aws configure export-credentials --profile "$profile" --format env > "$tmp_export"; then
      echo "Failed to export credentials. Check your profile and SSO setup."
      exit 1
    fi

    awk '
      /^export AWS_/ {
        sub(/^export[[:space:]]+/, "", $0);
        gsub(/"/, "", $0);
        print
      }
    ' "$tmp_export" > "${tmp_export}.env"

    if ! grep -q '^AWS_ACCESS_KEY_ID=' "${tmp_export}.env"; then
      echo "No AWS credentials generated. Verify SSO login."
      exit 1
    fi

    if [ ! -f "$env_file" ]; then
      echo "No .env found — creating a new one."
      : > "$env_file"
    fi

    # Strip old AWS_* lines from .env, then append fresh ones
    grep -vE '^AWS_(ACCESS_KEY_ID|SECRET_ACCESS_KEY|SESSION_TOKEN|REGION|DEFAULT_REGION)=' "$env_file" > "$tmp_env_base" || true
    cat "$tmp_env_base" "${tmp_export}.env" > "$tmp_env_new"
    mv "$tmp_env_new" "$env_file"

    # Ensure region is set
    if ! grep -qE '^AWS_(REGION|DEFAULT_REGION)=' "$env_file"; then
      echo 'AWS_REGION=us-east-1' >> "$env_file"
    fi

    echo "AWS credentials updated in $env_file"

    {
      echo '#!/usr/bin/env bash'
      echo '# Autogerado; exporta AWS_* do .env'
      grep -E '^(AWS_[A-Z0-9_]+)=' "$env_file" | while IFS='=' read -r k v; do
        printf 'export %s=%q\n' "$k" "$v"
      done
    } > "$exports_file"
    chmod 600 "$exports_file"
  )
  local rc=$?

  if (( rc != 0 )); then
    echo "aws_update_env: failed with status $rc"
    return $rc
  fi

  # If we got here, update succeeded; load into current shell
  if [ -f "$exports_file" ]; then
    # shellcheck disable=SC1090
    source "$exports_file"
    echo "AWS env exported to current shell from $exports_file"
  else
    echo "aws_update_env: $exports_file not found after update"
    return 1
  fi
}
