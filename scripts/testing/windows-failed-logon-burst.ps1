<#
.SYNOPSIS
  [Recommendation] Generate failed network logons (Event 4625) for a test account.

.DESCRIPTION
  Uses one fixed wrong password against a dedicated test account. Not a guessing tool.
  The lab lockout policy (5 invalid attempts) WILL lock the account for a while.

.EXAMPLE
  .\windows-failed-logon-burst.ps1 -Target DC01 -TestUser "CORP\lab-test-user" -ConfirmLab
#>
param(
  [Parameter(Mandatory = $true)][string]$Target,
  [Parameter(Mandatory = $true)][string]$TestUser,
  [ValidateRange(1,12)][int]$Count = 6,
  [switch]$ConfirmLab
)
if (-not $ConfirmLab) { Write-Error "Refusing to run: pass -ConfirmLab (isolated lab, test account only)."; exit 1 }

for ($i = 1; $i -le $Count; $i++) {
  cmd /c "net use \\$Target\IPC`$ /user:$TestUser Wrong-Password-LabTest 2>nul" | Out-Null
  Start-Sleep -Seconds 1
}
cmd /c "net use \\$Target\IPC`$ /delete 2>nul" | Out-Null
Write-Host "Sent $Count failed logons to $Target as $TestUser. Expect rule 100110 per failure and 100200 after 5 within 300 s."
