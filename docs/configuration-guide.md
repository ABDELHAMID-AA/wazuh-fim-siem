# Configuration guide

Where things live and what was configured. Tags: **[Documented]**, **[Recommendation]**.

## File locations

| Item | Location |
|---|---|
| Manager configuration | `/var/ossec/etc/ossec.conf` **[Documented]** |
| Custom rules | `/var/ossec/etc/rules/local_rules.xml` **[Documented]** |
| Stock decoders | `/var/ossec/ruleset/decoders/` (e.g. `0310-ssh_decoders.xml`) **[Documented]** |
| Stock rules | `/var/ossec/ruleset/rules/` **[Documented]** |
| Linux agent configuration | `/var/ossec/etc/ossec.conf` **[Documented]** |
| Windows agent configuration | `C:\Program Files (x86)\ossec-agent\ossec.conf` (standard Wazuh path) |
| Integrations | `/var/ossec/integrations/` and logs in `/var/ossec/logs/integrations.log` **[Recommendation]** |

Most monitoring configuration was applied **directly on each agent** through its local `ossec.conf`; only minor changes were made on the manager. **[Documented]** For larger deployments consider centralized agent groups (`agent.conf`) **[Recommendation]**.

## Log collection

| Source | Format | Configured on | Files |
|---|---|---|---|
| Windows Event Log | `eventchannel` | DC01, WS01 | [`configs/windows/agent-ossec-snippets.xml`](../configs/windows/agent-ossec-snippets.xml) |
| Linux logs | `syslog`, `apache` | WEB-SERVER | [`configs/linux/agent-ossec-snippets.xml`](../configs/linux/agent-ossec-snippets.xml) |
| Manager host logs | `syslog` | Wazuh server | [`configs/wazuh-manager/ossec-manager-snippets.xml`](../configs/wazuh-manager/ossec-manager-snippets.xml) |

## FIM options explained

| Option | Meaning |
|---|---|
| `<frequency>` | Seconds between scheduled scans (30 s Linux, 60 s Windows in the lab; stock default is 12 h) |
| `<scan_on_start>` | Scan when the agent starts |
| `realtime="yes"` | Immediate detection on change (inotify on Linux) |
| `check_all="yes"` | Full set of checks (hashes, size, owner, permissions, mtime) |
| `recursion_level="0"` + `restrict=` | Watch only the named files in the directory |
| `<windows_registry>` | Registry keys to monitor (persistence keys such as `Run`/`RunOnce`) |

FIM detects: file creation, deletion, modification, permission changes and registry modifications. **[Documented]**

## Windows prerequisites for the rules

Audit policy must generate the events (4624, 4625, 4688, 4720, 4728/4732/4756, ...). See [`configs/windows/ad-audit-policy.md`](../configs/windows/ad-audit-policy.md).

## Severity scale

Wazuh levels from 3 (low) to 15 (critical) were used; dashboards highlight level >= 12, Telegram forwards level >= 8. **[Documented]**

## Security of communications **[Documented as requirements]**

- Agent <-> manager: encrypted channel on 1514/tcp.
- Manager/dashboard <-> indexer: TLS.
- Underlay: Tailscale VPN.

## [Recommendation] Hardening reminders

- Change all default and installer-generated credentials; store them outside the repo.
- Restrict dashboard exposure to the VPN/lab network.
- Back up `/var/ossec/etc` (including `local_rules.xml`) after each tested change.
