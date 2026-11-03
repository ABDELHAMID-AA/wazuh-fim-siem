#!/usr/bin/env bash
# [Recommendation] Quick health check of a Linux Wazuh agent.
set -uo pipefail

echo "== Service status =="
systemctl is-active wazuh-agent || true

echo; echo "== Last connection messages =="
sudo grep -E "Connected to the server|Unable to connect|ERROR" /var/ossec/logs/ossec.log | tail -n 5

echo; echo "== Monitored log files expected by the project config =="
for f in /var/log/auth.log /var/log/syslog /var/log/apache2/access.log /var/log/apache2/error.log; do
  [ -r "$f" ] && echo "present : $f" || echo "MISSING : $f (or unreadable)"
done

echo; echo "== syscheck (FIM) activity =="
sudo grep -E "syscheck|realtime" /var/ossec/logs/ossec.log | tail -n 5
