# Screenshots

Evidence captured in the original lab and **sanitized before publication**: IP addresses, internal hostnames, domain names, personal and account names, URL bars and browser chrome were blacked out or cropped. Branding, third-party/vendor diagrams, and any capture showing credentials or delivery details were excluded entirely.

Notes for readers:
- Agent names in the images (`windows-server`, `linux`) are the lab's real agent labels; the documentation uses placeholder names (`DC01`, `WEB-SERVER`). They refer to the same machines: `windows-server` is the Windows Server 2022 VM and `linux` is the Ubuntu web server.
- Black boxes are redactions, not rendering glitches.
- Dates in the images (2026) are lab dates.

## Index

| File | What it shows | Used in |
|---|---|---|
| `01-wazuh-modules-overview.png` | Wazuh Dashboard home with the security modules and agent counts | README |
| `02-gpo-audit-policy.png` | Group Policy editor, audit policy settings | [AD audit policy](../configs/windows/ad-audit-policy.md) |
| `03-security-events-linux.png` | Security events for the Linux agent (alert groups, top rules, PCI DSS) | README, [dashboards](../dashboards/README.md) |
| `04-fim-dashboard-linux.png` | Integrity monitoring dashboard, Linux agent | README, dashboards |
| `05-fim-alert-linux-webroot.png` | FIM alert (rule 550) for a change to the web root `index.html`, with hash diff | [Testing](../docs/testing-and-validation.md) |
| `06-security-events-windows-24h.png` | Security events for the Windows server, last 24 h, with MITRE ATT&CK | dashboards |
| `07-fim-dashboard-windows.png` | FIM / registry integrity dashboard, Windows server | dashboards |
| `08-auth-event-counters.png` | Authentication event counters (success / failure) | dashboards |
| `09-dashboard-identity-authentication.png` | Custom identity and authentication attack dashboard | dashboards, [scenario 03](../attack-scenarios/03-active-directory-monitoring/) |
| `10-dashboard-process-execution.png` | Custom process execution and PowerShell dashboard | dashboards, [scenario 02](../attack-scenarios/02-windows-process-and-persistence/) |
| `11-dashboard-ad-users-groups.png` | Custom AD users and groups dashboard (30-day view) | dashboards |
| `12-dashboard-ad-single-run.png` | Same dashboard, 1-hour view after one attack run (1 user created, 1 group change) | scenario 03 |
| `13-alert-linux-pam-multiple-failures.png` | PAM "multiple failed logins" alert document from SSH failures | [scenario 04](../attack-scenarios/04-linux-ssh-compromise/) |
| `14-alert-linux-new-user.png` | New-user-added alert (rule 5902) for a secondary account | scenario 04 |
| `15-alert-ransomware-correlation.png` | Alert 120105 (level 14) document | [scenario 01](../attack-scenarios/01-windows-ransomware-simulation/) |
| `16-ransomware-test-screen.png` | Cropped screen of the lab's ransomware-like test binary (wallet and contact details removed) | scenario 01 |
| `17-atomic-red-team-t1098.png` | Atomic Red Team T1098 listing and execution | scenario 03 |
| `18-telegram-suspicious-process.png` | Telegram alert, rule 101300 | scenario 02 |
| `19-telegram-ransomware.png` | Telegram alert, rule 120105 | scenario 01 |
| `20-telegram-brute-force.png` | Telegram alert, rule 100200 | scenario 03 |
| `21-telegram-user-created.png` | Telegram alert, rule 110152 | scenario 03 |
| `22-telegram-privileged-group.png` | Telegram alert, rule 102020 | scenario 03 |

The architecture diagram is in [`docs/images/architecture-overview.png`](../docs/images/architecture-overview.png).

## Adding more screenshots
- Keep unredacted originals in `screenshots/_unsanitized/` (git-ignored); commit only cleaned copies.
- Black out (do not blur) IPs, hostnames, domains, usernames, tokens, chat IDs; crop browser chrome and taskbars.
- Name files `NN-short-description.png` and add a row above.
