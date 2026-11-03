#!/usr/bin/env python3
"""
Wazuh -> Telegram alert forwarder.

Origin: [Documented] This is a transcription of the script shown in the project
documentation, which was itself adapted from a community example. Differences
from that version (all intentional):
  * The bot token and chat ID are read from environment variables instead of
    being hard-coded.
  * The minimum alert level is configurable (default 8, same as the project).
  * Decorative emoji in the message were omitted (they could not be read
    reliably from the source figure).
  * Errors go to stderr so they land in Wazuh's integrations.log.

Wazuh calls integrations as:  <script> <alert_file> <api_key> <hook_url>
Only <alert_file> (argv[1]) is used here.

Required environment variables:
  TELEGRAM_BOT_TOKEN   token issued by @BotFather
  TELEGRAM_CHAT_ID     chat or channel ID that receives the alerts
Optional:
  TELEGRAM_MIN_LEVEL   minimum rule level to forward (default: 8)
"""
import json
import os
import sys

import requests

TOKEN = os.environ.get("TELEGRAM_BOT_TOKEN", "")
CHAT_ID = os.environ.get("TELEGRAM_CHAT_ID", "")
MIN_LEVEL = int(os.environ.get("TELEGRAM_MIN_LEVEL", "8"))


def main():
    try:
        if not TOKEN or not CHAT_ID:
            print("Telegram integration error: TELEGRAM_BOT_TOKEN / TELEGRAM_CHAT_ID not set",
                  file=sys.stderr)
            sys.exit(1)

        alert_file = sys.argv[1]
        with open(alert_file, "r", encoding="utf-8") as f:
            alert = json.load(f)

        rule = alert.get("rule", {})
        level = int(rule.get("level", 0))

        # Send only high severity alerts
        if level < MIN_LEVEL:
            sys.exit(0)

        agent_name = alert.get("agent", {}).get("name", "Unknown")
        agent_ip = alert.get("agent", {}).get("ip", "Unknown")

        rule_id = rule.get("id", "N/A")
        description = rule.get("description", "No description")

        timestamp = alert.get("timestamp", "Unknown")
        location = alert.get("location", "Unknown")
        srcip = alert.get("data", {}).get("srcip", "N/A")

        message = (
            "WAZUH HIGH ALERT\n"
            "--------------------\n"
            f"Agent: {agent_name}\n"
            f"Agent IP: {agent_ip}\n"
            f"Level: {level}\n"
            f"Rule ID: {rule_id}\n"
            f"Description: {description}\n"
            f"Source IP: {srcip}\n"
            f"Location: {location}\n"
            f"Time: {timestamp}"
        )

        url = f"https://api.telegram.org/bot{TOKEN}/sendMessage"

        response = requests.post(
            url,
            data={
                "chat_id": CHAT_ID,
                "text": message,
            },
            timeout=10,
        )

        if response.status_code != 200:
            # Do not echo the URL: it contains the token.
            print(f"Telegram API error: HTTP {response.status_code} {response.text}",
                  file=sys.stderr)

    except SystemExit:
        raise
    except Exception as e:  # noqa: BLE001 - integration must never crash the daemon
        # Avoid printing the exception object if it could embed the request URL (token).
        print(f"Telegram integration error: {type(e).__name__}", file=sys.stderr)


if __name__ == "__main__":
    main()
