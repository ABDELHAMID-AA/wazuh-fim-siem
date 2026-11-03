# Attack scenarios

Simulated attacks used to validate detections in an **isolated, authorized lab**. Each folder has its own README.

> **Safety:** no malware, payloads, delivery URLs, wordlists or destructive instructions are included. Where the original exercise used offensive tooling (a ransomware-like test binary, Hydra), the READMEs describe *what happened and what telemetry resulted* at a level useful for defenders, and point to benign helpers in [`scripts/testing/`](../scripts/testing/) that generate the same telemetry. Never run any of this against systems you do not own or lack written permission to test.

| Folder | Phase / scenario | ATT&CK | Result |
|---|---|---|---|
| [`01-windows-ransomware-simulation`](01-windows-ransomware-simulation/) | Impact: mass file modification | T1486 | Detected |
| [`02-windows-process-and-persistence`](02-windows-process-and-persistence/) | Delivery, execution, Run-key persistence | T1059.001, T1105, T1204, T1547.001 | Detected |
| [`03-active-directory-monitoring`](03-active-directory-monitoring/) | Brute force -> valid account -> new user -> privileged group | T1110, T1078, T1136, T1098 | Detected |
| [`04-linux-ssh-compromise`](04-linux-ssh-compromise/) | SSH brute force -> valid account -> new account | T1110, T1078, T1136 | Detected |

Folders 01 and 02 are the two phases of the project's single "ransomware attack" scenario. In kill-chain order, read **02 first, then 01**.

Lab used by all scenarios: Wazuh all-in-one server, Windows Server 2022 DC (`DC01`), Windows 10 domain-joined workstation (`WS01`), Ubuntu 22.04 web server (`WEB-SERVER`), all on a Tailscale overlay. See [../docs/architecture.md](../docs/architecture.md).

Provenance tags: **[Documented]**, **[Validated]**, **[Recommendation]**, **[Not recorded]**.
