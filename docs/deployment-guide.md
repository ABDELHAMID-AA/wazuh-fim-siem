# Deployment guide

Reproduces the lab described in the project. Provenance tags: **[Documented]** original, **[Recommendation]** added here. Hostnames, domains and addresses are placeholders:

| Placeholder | Meaning |
|---|---|
| `<WAZUH_MANAGER_IP>` | Address agents use to reach the manager (its Tailscale address in the lab) |
| `corp.example.local` | AD domain (the source used two different real names; neither is reproduced) |
| `DC01`, `WS01`, `WEB-SERVER` | Domain controller, workstation, Linux web server |

## 0. Prerequisites

- Hypervisor (VMware Workstation / VirtualBox), isolated network. **[Documented]**
- Wazuh server VM: Ubuntu Server 22.04 LTS, 4 vCPU, 8 GB RAM, enough disk for indexing. **[Documented]**
- DC VM: Windows Server 2022 Standard, 2 vCPU, 4 GB RAM, 60 GB disk. **[Documented]**
- Workstation VM (Windows 10), Linux web server VM (Ubuntu 22.04 with Apache and SSH). **[Documented]**
- Tailscale on all four machines. **[Documented]**

## 1. Connectivity (Tailscale)

Install Tailscale on every VM and join them to the same tailnet. Use the Tailscale address of the Wazuh server as `<WAZUH_MANAGER_IP>`. Verify with `ping` between hosts. **[Documented]** (no Tailscale settings were recorded; install per the vendor's documentation).

## 2. Wazuh server (all-in-one)

Original commands **[Documented]**:

```bash
curl -sO https://packages.wazuh.com/4.x/wazuh-install.sh
sudo bash ./wazuh-install.sh -a
```

`-a` installs Manager, Indexer and Dashboard on one host. When finished, the installer prints the admin credentials: store them in a password manager, never in the repo. The dashboard is reachable at `https://<WAZUH_SERVER_ADDRESS>:443`.

Validation **[Recommendation]**:

```bash
sudo systemctl status wazuh-manager wazuh-indexer wazuh-dashboard
```

## 3. Active Directory and domain **[Documented]**

On the Windows Server 2022 VM:

1. Server Manager > *Add roles and features* > select **Active Directory Domain Services**; finish the wizard and reboot if prompted.
2. Promote the server to a domain controller (AD DS configuration wizard).
3. Create a **new forest** with root domain `corp.example.local`.
4. Set forest and domain functional levels to **Windows Server 2016**.
5. Set the DSRM password (store securely).
6. Finish promotion and reboot; Active Directory Users and Computers becomes available.
7. Create the OU hierarchy and lab accounts (layout in [`configs/windows/ad-audit-policy.md`](../configs/windows/ad-audit-policy.md)). Administrator accounts go in Domain Admins; others stay standard users (least privilege).

### Group Policy

Configure the audit policy, password policy and lockout policy exactly as listed in [`configs/windows/ad-audit-policy.md`](../configs/windows/ad-audit-policy.md). **[Documented]**

### Workstation domain join **[Documented]**

1. Point the workstation's DNS to the DC.
2. On the DC firewall allow DNS (53), Kerberos (88), LDAP (389), SMB (445) from the workstation.
3. Make sure Tailscale is up on both machines.
4. Join `corp.example.local` and reboot.

## 4. Agent enrollment

Ports **[Documented]**: agents -> manager `TCP 1514`; enrollment `TCP 1515`.

Procedure **[Documented]**: Dashboard > *Agents* > *Deploy new agent* > enter the manager address and an agent name > copy the generated command and run it (PowerShell on Windows, terminal on Linux).

### Linux (original command, placeholders substituted)

```bash
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.5-1_amd64.deb && \
sudo WAZUH_MANAGER='<WAZUH_MANAGER_IP>' WAZUH_AGENT_GROUP='default' WAZUH_AGENT_NAME='WEB-SERVER' \
  dpkg -i ./wazuh-agent_4.7.5-1_amd64.deb
```

Then start the service **[Recommendation]**:

```bash
sudo systemctl daemon-reload && sudo systemctl enable --now wazuh-agent
```

Helper: [`scripts/linux/install-agent-ubuntu.sh`](../scripts/linux/install-agent-ubuntu.sh).

### Windows (DC01, WS01)

The project used the official MSI with the dashboard-generated command (exact text not recorded). A script following the standard Wazuh format is provided as a **[Recommendation]**: [`scripts/windows/install-agent.ps1`](../scripts/windows/install-agent.ps1).

Use the same agent version family as the manager; the project's Linux agent was 4.7.5 and the manager version was recorded only as "4.x".

### Validation **[Documented + Recommendation]**

- Dashboard > *Agents*: the three agents appear as **Active** **[Documented]**.
- On the manager **[Recommendation]**: `sudo /var/ossec/bin/agent_control -l`
- On agents **[Recommendation]**: `scripts/linux/verify-agent.sh`, `scripts/windows/verify-agent.ps1`

## 5. Collection and FIM configuration

Apply the files in `configs/` (details: [configuration-guide.md](configuration-guide.md)). Restart agents after editing:

```bash
sudo systemctl restart wazuh-agent          # Linux
```
```powershell
Restart-Service -Name wazuh                 # Windows
```

## 6. Detection rules

```bash
sudo cp detection-rules/local_rules.documented.xml /var/ossec/etc/rules/local_rules.xml   # or merge into the existing file
sudo /var/ossec/bin/wazuh-analysisd -t                                                     # [Recommendation] validate
sudo systemctl restart wazuh-manager
```

If `local_rules.xml` already contains rules, merge instead of overwriting. Rule catalogue: [detection-engineering.md](detection-engineering.md).

## 7. Telegram alerting (optional)

See [`integrations/telegram/README.md`](../integrations/telegram/README.md) and [alerting-integration.md](alerting-integration.md).

## 8. Dashboards

The project built five dashboards (details in [`dashboards/README.md`](../dashboards/README.md)). No exported objects exist; recreate them from the descriptions, or build your own on the stock modules.

## 9. End-to-end validation

Follow [testing-and-validation.md](testing-and-validation.md).
