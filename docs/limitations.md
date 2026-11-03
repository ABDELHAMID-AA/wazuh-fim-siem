# Limitations and future improvements

## Limitations stated by the project **[Documented]**

- Virtualized lab: does not reproduce production volume, network load or equipment diversity.
- Only four machines (one server, three endpoints): scalability was not assessed.
- No Wazuh cluster: all-in-one architecture, so high availability and load balancing were not evaluated.
- Attack scenarios are representative but simplified compared with stealthier, multi-stage real attacks.

## Additional observations about this repository

These come from reconstructing the project from its documentation; they are not claims made by the original report.

**Evidence and reproducibility**
- Validation evidence is provided as sanitized screenshots (redactions are visible as black boxes); detection results are as recorded, from a single run per scenario, and the screenshots cannot be independently verified.
- Screenshot agent labels (`windows-server`, `linux`) differ from the placeholder names used in the docs; scenarios 1-3 ran on the Windows Server VM, not on the workstation.
- No latency, false-positive or volume measurements.
- Ten rule IDs referenced by dashboards/scenarios have no recorded definitions (see [source-inventory.md](source-inventory.md)); the dashboards themselves were not exported.
- Some config excerpts in the source are truncated or contain elisions; this repo restores syntax only where noted.
- The source names the AD domain inconsistently (two different names), and its prose mentions Windows 10 for the workstation while some sections say "Windows workstation"; both sanitized to placeholders.

**Detection logic**
- 100700 (account compromise) mixes `if_matched_sid` and `if_sid` and has no explicit `frequency`; unvalidated, may need rework.
- 102020 is described as "privileged group" but matches any security group addition.
- 120104/120105 apply to all agents and paths and can be triggered by legitimate bulk changes.
- 120103 matches a hard-coded lab filename; 120100-120103 depend on parent rule 61603, which should be checked against the telemetry actually collected (Sysmon vs Event 4688).
- 100200 counts per target user, not per source IP (distributed or password-spraying patterns are only partially covered).
- Registry FIM entries in the source use the literal token `userid` under `HKEY_USERS`; confirm what resolves in your environment.

**Operational**
- Credentials: the source script hard-coded Telegram identifiers; this repo reads them from the environment instead.
- Default Wazuh/installer credentials, DSRM password and lab account passwords must be managed outside the repo.
- Audit policies must be present, otherwise rules never fire (e.g. 4688 and command-line logging).

## Future improvements

From the project:
- Add **Sysmon** on Windows for richer process, network and file telemetry.
- Integrate **threat-intelligence / IoC feeds** for alert enrichment.
- Advanced **Active Response** (automatic IP blocking, host isolation).
- Clustered deployment (several Manager and Indexer nodes) to test scalability and HA.

Suggested here **[Recommendation]**:
- Define and document the missing rules (RDP failures, LOLBins, GPO changes, AD user deletion) and export the dashboards as saved objects.
- Add custom Linux rules (success after failures, SSH config/`authorized_keys` changes).
- Scope FIM correlation per agent/path and tune thresholds; add a baseline period.
- Add automated rule tests (`wazuh-logtest` fixtures) and a CI check that runs `xmllint` on the rule files.
- Measure detection latency and false positives.
- Align detections with MITRE ATT&CK tags in rule metadata (`<mitre><id>...</id></mitre>`).
