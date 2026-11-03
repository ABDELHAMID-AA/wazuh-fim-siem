<#
.SYNOPSIS
  Enable the audit subcategories that generate the events used by the detection rules.

.NOTES
  Origin: [Recommendation]. The project configured these settings through Group Policy
  (see configs/windows/ad-audit-policy.md). This script is a local-machine equivalent for
  quick lab setups; on a domain controller prefer the GPO so settings are not overwritten.
  Subcategory names below are the English ones; adjust for localized Windows.
  Run in an elevated PowerShell.
#>
$ErrorActionPreference = "Stop"

$both = @(
  "Logon",                        # 4624 / 4625
  "User Account Management",      # 4720 / 4726
  "Security Group Management",    # 4728 / 4732 / 4756
  "Audit Policy Change",          # 4719
  "Sensitive Privilege Use",      # 4673
  "Special Logon",                # 4672
  "File System",                  # 4663 (also needs SACLs on the objects to audit)
  "Directory Service Access"      # 4662
)
foreach ($sub in $both) {
  auditpol /set /subcategory:"$sub" /success:enable /failure:enable | Out-Null
}
auditpol /set /subcategory:"Process Creation" /success:enable | Out-Null   # 4688

# Include the command line in 4688 events (needed by command-line based rules)
$key = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
New-Item -Path $key -Force | Out-Null
Set-ItemProperty -Path $key -Name "ProcessCreationIncludeCmdLine_Enabled" -Value 1 -Type DWord

auditpol /get /category:* | Select-String -Pattern "Logon|Account Management|Process Creation|Policy Change|Privilege Use|Directory Service|File System"
