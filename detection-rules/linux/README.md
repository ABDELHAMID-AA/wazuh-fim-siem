# Linux detections

The project did **not** define custom Linux rules. Linux detections rely on Wazuh's built-in ruleset, which is why this folder contains no XML.

| Rule | Type | Purpose | Status |
|---|---|---|---|
| 5715 | Stock | `sshd: authentication success` (level 3) | **[Documented]** (decoder + rule shown for illustration) |
| PAM / sshd authentication-failure family | Stock | Repeated failures on SSH (alert text: "PAM: Multiple failed logins in a small period of time") | **[Validated]** - scenario 4; rule ID not visible in the evidence |
| 5902 | Stock | `New user added to the system` | **[Validated]** - scenario 4 |
| FIM (syscheck) on `/etc`, `/var/www`, `/home` | Stock module | File changes, including `/etc/passwd`, `/etc/shadow`, SSH config; web-root change shown as rule 550 "Integrity checksum changed" (level 7) | **[Validated]** (rule 550 alert on `/var/www/html/index.html`, see [testing](../../docs/testing-and-validation.md)) |

## Decoder example (stock) **[Documented]**

SSH events are decoded by the stock decoders in `0310-ssh_decoders.xml`. The project documentation walks through this example:

```xml
<decoder name="sshd">
  <program_name>^sshd</program_name>
</decoder>

<decoder name="sshd-success">
  <parent>sshd</parent>
  <prematch>^Accepted</prematch>
  <regex offset="after_prematch">^ \S+ for (\S+) from (\S+) port (\S+)</regex>
  <order>user, srcip, srcport</order>
  <fts>name, user, location</fts>
</decoder>
```

Sample (sanitized) log line and the fields extracted:

```
<timestamp> linux-web sshd[3824]: Accepted password for labuser from 100.64.0.20 port 46425 ssh2
```

| Field | Value |
|---|---|
| user | `labuser` |
| srcip | `100.64.0.20` |
| srcport | `46425` |

## Stock rule example **[Documented]**

```xml
<rule id="5715" level="3">
  <if_sid>5700</if_sid>
  <match>Accepted</match>
  <description>sshd: authentication success.</description>
</rule>
```

## [Recommendation] Ideas for custom Linux rules (not implemented in the project)

- Alert on `sudo` use by newly created accounts.
- Alert on SSH success from a source IP that previously failed repeatedly (the Linux analogue of rule 100700).
- Alert on modification of `/etc/ssh/sshd_config` or `authorized_keys` via FIM-path-based rules.
