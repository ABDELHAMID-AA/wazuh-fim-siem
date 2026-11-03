#!/usr/bin/env bash
# [Recommendation] Create then remove a local test account to trigger "new user added" detection.
# The original scenario created a secondary account with `sudo useradd <name>`.
#
# Usage: LAB_CONFIRM=yes ./linux-create-test-user.sh [username]   (run on the monitored Linux host)
set -euo pipefail

[ "${LAB_CONFIRM:-}" = "yes" ] || { echo "Refusing to run: set LAB_CONFIRM=yes (isolated lab only)." >&2; exit 1; }
NAME="${1:-labtest-user}"

sudo useradd "$NAME"
echo "Created '$NAME'. Check the dashboard now (expect stock rule 5902 and FIM events on /etc/passwd)."
read -r -p "Press Enter to remove the account ..." _
sudo userdel "$NAME"
echo "Removed '$NAME'."
