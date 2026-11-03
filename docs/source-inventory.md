# Source inventory

Internal inventory of what the project documentation provides, produced before building this repository. It records the **status** of each element so nothing is presented as more complete or more tested than it is.

Status legend: **Validated** (shown to fire in an attack scenario) - **Documented** (config/rule text available, no explicit validation shown) - **Described only** (mentioned in prose, no config/rule text) - **Proposed** (listed as future work) - **Not recorded** (referenced, content unavailable).

## Infrastructure

| Element | Status | Notes |
|---|---|---|
| Wazuh all-in-one (Manager, Indexer, Dashboard) | Documented | Quickstart installer, Ubuntu 22.04, 4 vCPU / 8 GB. Exact Wazuh server version not recorded ("4.x"). |
| Windows Server 2022 AD DS DC | Documented | Specs, promotion steps, functional level 2016, OU layout. |
| Windows 10 domain-joined workstation | Documented | Join prerequisites recorded. |
| Linux web server (Apache + SSH) | Documented | Agent install command, version 4.7.5. |
| Tailscale connectivity | Described only | No Tailscale configuration recorded. |
| Domain / account / GPO design | Documented | Audit policy table, password/lockout policy table. Domain name appears inconsistently in the source (two different names); both replaced by a placeholder here. |

## Collection and FIM

| Element | Status | Notes |
|---|---|---|
| Windows `eventchannel` collection (Security, System, Application) | Documented | Exact XML recorded. |
| Linux `localfile` collection | Documented | Annex excerpt (auth, syslog, dpkg, kern, Apache). |
| Manager `localfile` (auth.log, syslog) | Documented | |
| Linux FIM (`syscheck`) | Documented | Body snippet is truncated in the source; closing tag restored here. |
| Windows FIM (`syscheck` + registry) | Documented | Annex excerpt contains elisions ("..."). |
| FIM alerts seen on Linux and Windows registry | Validated | Registry Run-key change detected in scenario 2. |

## Detection rules

| Rule ID(s) | Status |
|---|---|
| 100110, 100200 | Documented (100200 shown firing in scenario 3) -> Validated |
| 100100, 100700 | Documented; no firing of 100700 shown |
| 110152 | Validated (scenario 3) |
| 102020 | Validated (scenario 3) |
| 120100, 120101, 120102, 120103 | Documented; download/execution reported detected, rule IDs of the specific alerts not recorded |
| 120104, 120105 | 120105 Validated (scenario 1); 120104 Documented |
| 101100 (encoded PowerShell) | Documented in prose and visible in the process-dashboard screenshot (so it ran in the lab), but its parent rule 100900 is **Not recorded** |
| 100111, 100900, 101000 (seen only in a dashboard legend), 101002, 101200, 101201, 101300, 110100, 110101, 110102, 110153 | **Not recorded** (referenced by dashboards/scenarios; 101300 shown firing in scenario 2) |
| Stock rules 5715, 5902 (and sshd failure rules) | Built-in Wazuh rules, not custom; 5902 Validated |

## Integrations, dashboards, scenarios

| Element | Status | Notes |
|---|---|---|
| Telegram integration script | Documented | Source is a screenshot of the script; transcribed with credentials externalized. Token was masked and chat ID was visible in the source; neither is reproduced. |
| `<integration>` block (`custom-telegram`, level 8, JSON) | Documented | |
| Dashboards (5) | Described + screenshots | Panels and dependent rules described, five dashboards shown in sanitized screenshots; no saved-object exports. |
| Scenario 1 - ransomware-like chain | Validated | Payload and delivery details intentionally excluded. |
| Scenario 2 - AD compromise | Validated | |
| Scenario 3 - Linux SSH compromise | Validated | |

## Proposed / future work (from the source)

Sysmon on Windows, threat-intelligence enrichment, advanced Active Response (IP blocking, host isolation), clustered Wazuh deployment.

## Gaps worth knowing about

- No recorded definitions for ten referenced rule IDs (above).
- No detection-latency, false-positive or volume measurements.
- No exported dashboards, no Tailscale settings, no decoder customizations beyond stock SSH decoder examples.
- Screenshots were provided separately and are included here **only after redaction** (see `screenshots/README.md`). Images containing branding, third-party diagrams, credentials, payload/delivery details or ransom wallet/contact data were excluded or cropped.
