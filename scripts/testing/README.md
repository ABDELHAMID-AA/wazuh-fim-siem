# Detection test helpers

**[Recommendation]** - these scripts are *not* from the original project. They reproduce the **telemetry** needed to exercise the documented detections in a safe, repeatable way, without malware, payloads, password lists or encryption.

> Run them **only** in your own isolated lab, on machines you own, against accounts created for testing. Each script refuses to run without an explicit lab confirmation (`LAB_CONFIRM=yes` for shell, `-ConfirmLab` for PowerShell) and cleans up after itself where it creates anything.

| Script | Generates | Expected alert | Scenario |
|---|---|---|---|
| `linux-failed-ssh-burst.sh` | A few SSH logins with one fixed wrong password for a test user | Stock PAM/sshd authentication-failure alert | [04](../../attack-scenarios/04-linux-ssh-compromise/) |
| `linux-create-test-user.sh` | A local test account (create, then remove) | Stock rule 5902 (new user); FIM on `/etc/passwd`, `/etc/shadow` | [04](../../attack-scenarios/04-linux-ssh-compromise/) |
| `windows-failed-logon-burst.ps1` | Failed network logons (Event 4625) for a test account | 100110, then 100200 (5 in 300 s) | [03](../../attack-scenarios/03-active-directory-monitoring/) |
| `windows-ad-user-group-test.ps1` | Test user creation (4720) and group add (4728), then cleanup | 110152, 102020 | [03](../../attack-scenarios/03-active-directory-monitoring/) |
| `windows-run-key-test.ps1` | Benign `Run` registry value (add, then remove) | FIM registry alert | [02](../../attack-scenarios/02-windows-process-and-persistence/) |
| `windows-fim-burst.ps1` | Bursts of benign file creations/edits in a monitored test folder | 120104, then 120105 (30 in 60 s) | [01](../../attack-scenarios/01-windows-ransomware-simulation/) |
| `test-telegram-integration.sh` | A synthetic alert through the Telegram script | Telegram message | all |

Account lockout warning: the lab password policy locks an account after 5 invalid attempts for 10 minutes. Use a dedicated test account, and expect lockout events.

Always confirm what actually fired in the dashboard (Security events / Integrity monitoring) and with `wazuh-logtest` rather than assuming.
