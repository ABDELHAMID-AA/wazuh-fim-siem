# Telegram integration

Forwards Wazuh alerts of level >= 8 to a Telegram chat through the Bot API.

## What is original and what is not

| File | Origin |
|---|---|
| `custom-telegram.py` | **[Documented]** - transcription of the script shown in the project documentation (itself adapted from a community example), with credentials moved to environment variables and minor hardening. |
| `ossec-integration-snippet.xml` | **[Documented]** - `<integration>` block from the project (`custom-telegram`, level 8, JSON). |
| `custom-telegram` (shell wrapper) | **[Recommendation]** - standard Wazuh pattern; not in the project documentation. |
| `telegram.env.example`, systemd drop-in below | **[Recommendation]** |
| `sample-alert.json` | **[Recommendation]** - synthetic alert with documentation-range IPs, for testing only. |

The original script had its bot token masked and its chat ID in clear text in the source. Neither value appears anywhere in this repository.

## Message content

Agent name, agent IP, level, rule ID, description, source IP (if present), location and timestamp.

## Setup

1. **Create a bot** with @BotFather and note the token; get the target chat ID (for example by messaging the bot and calling `getUpdates`).
2. **Install the files** on the Wazuh server:
   ```bash
   sudo cp custom-telegram custom-telegram.py /var/ossec/integrations/
   sudo chown root:wazuh /var/ossec/integrations/custom-telegram /var/ossec/integrations/custom-telegram.py
   sudo chmod 750 /var/ossec/integrations/custom-telegram /var/ossec/integrations/custom-telegram.py
   sudo apt install -y python3-requests      # or: pip3 install requests
   ```
3. **Store credentials outside the repo** **[Recommendation]**:
   ```bash
   sudo install -m 600 -o root -g root telegram.env.example /etc/wazuh-telegram.env
   sudo nano /etc/wazuh-telegram.env         # put the real values here
   ```
4. **Expose them to the manager service** **[Recommendation]** with a systemd drop-in:
   ```bash
   sudo mkdir -p /etc/systemd/system/wazuh-manager.service.d
   printf '[Service]\nEnvironmentFile=/etc/wazuh-telegram.env\n' | \
     sudo tee /etc/systemd/system/wazuh-manager.service.d/telegram.conf
   sudo systemctl daemon-reload
   ```
5. **Enable the integration** by adding `ossec-integration-snippet.xml` to `/var/ossec/etc/ossec.conf`, then:
   ```bash
   sudo systemctl restart wazuh-manager
   ```
6. **Check logs**: `/var/ossec/logs/integrations.log` and `/var/ossec/logs/ossec.log`.

> Untested note: the drop-in approach relies on the manager's child processes inheriting the service environment. If messages do not arrive, check `integrations.log`; as a fallback, restrict file permissions heavily and read the values from a root-owned file inside the script instead of the environment. Avoid putting the token in `ossec.conf` (`<hook_url>`/`<api_key>`), which is readable by more users and tends to end up in backups and screenshots.

## Test without waiting for a real alert

```bash
export TELEGRAM_BOT_TOKEN='...'      # in your shell only
export TELEGRAM_CHAT_ID='...'
python3 custom-telegram.py sample-alert.json
```

A message should arrive. Set `TELEGRAM_MIN_LEVEL=15` and re-run to confirm it is filtered.

## Security notes

- Revoke and regenerate the bot token immediately if it is ever pasted into a screenshot, chat or commit (BotFather: `/revoke`).
- Alerts may contain usernames, hostnames and IPs: use a private chat, not a public channel.
- The script never prints the request URL (it contains the token).
