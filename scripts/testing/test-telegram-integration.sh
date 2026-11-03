#!/usr/bin/env bash
# [Recommendation] Push the synthetic sample alert through the Telegram script.
# Credentials must already be in your environment (never put them on the command line / in git):
#   export TELEGRAM_BOT_TOKEN=... TELEGRAM_CHAT_ID=...
set -euo pipefail
: "${TELEGRAM_BOT_TOKEN:?not set}"; : "${TELEGRAM_CHAT_ID:?not set}"
HERE="$(cd "$(dirname "$0")" && pwd)"
python3 "$HERE/../../integrations/telegram/custom-telegram.py" "$HERE/../../integrations/telegram/sample-alert.json"
echo "Sent (check your Telegram chat)."
