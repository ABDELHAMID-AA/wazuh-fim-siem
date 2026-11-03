<#
.SYNOPSIS
  [Recommendation] Create a disabled test user and add it to a dedicated test group, then clean up.

.DESCRIPTION
  Run on the domain controller (or a host with RSAT AD tools) as a lab administrator.
  Generates Event 4720 (user created) and 4728 (member added to a global security group).
  Uses a dedicated, unprivileged group - it does NOT touch Domain Admins or any real group.
  The original project also ran Atomic Red Team test T1098; see the scenario README.

.EXAMPLE
  .\windows-ad-user-group-test.ps1 -ConfirmLab
#>
param([switch]$ConfirmLab)
if (-not $ConfirmLab) { Write-Error "Refusing to run: pass -ConfirmLab (isolated lab only)."; exit 1 }
Import-Module ActiveDirectory

$user  = "lab-test-user"
$group = "Lab-Test-Group"
$pwd   = ConvertTo-SecureString ("Aa1!" + [guid]::NewGuid().ToString("N")) -AsPlainText -Force

if (-not (Get-ADGroup -Filter "Name -eq '$group'")) { New-ADGroup -Name $group -GroupScope Global -GroupCategory Security }
New-ADUser -Name $user -SamAccountName $user -AccountPassword $pwd -Enabled $false
Add-ADGroupMember -Identity $group -Members $user
Write-Host "Created $user and added it to $group. Expect rules 110152 and 102020."

Read-Host "Press Enter to clean up"
Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
Remove-ADUser -Identity $user -Confirm:$false
Remove-ADGroup -Identity $group -Confirm:$false
Write-Host "Cleaned up."
