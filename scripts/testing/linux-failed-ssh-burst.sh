#!/usr/bin/env bash
# [Recommendation] Generate a handful of failed SSH logins for detection testing.
# One fixed, obviously wrong password is used - this is not a password-guessing tool.
#
# Usage: LAB_CONFIRM=yes ./linux-failed-ssh-burst.sh <target-host> [test-user] [count<=12]
# Requires: sshpass (sudo apt install sshpass)
set -euo pipefail

[ "${LAB_CONFIRM:-}" = "yes" ] || { echo "Refusing to run: set LAB_CONFIRM=yes (isolated lab only)." >&2; exit 1; }
command -v sshpass >/dev/null || { echo "sshpass not installed." >&2; exit 1; }

TARGET="${1:?usage: $0 <target-host> [test-user] [count<=12]}"
USER_NAME="${2:-labtest-invalid}"
COUNT="${3:-10}"
[ "$COUNT" -le 12 ] || { echo "count capped at 12" >&2; exit 1; }

echo "Sending ${COUNT} failed SSH logins as '${USER_NAME}' to ${TARGET} ..."
for i in $(seq 1 "$COUNT"); do
  sshpass -p 'wrong-password-labtest' ssh \
    -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    -o PreferredAuthentications=password -o PubkeyAuthentication=no \
    -o ConnectTimeout=5 "${USER_NAME}@${TARGET}" true 2>/dev/null || true
  sleep 1
done
echo "Done. Look for sshd authentication-failure / brute-force alerts for agent '${TARGET}'."
