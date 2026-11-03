<#
.SYNOPSIS
  [Recommendation] Add then remove a benign value under HKCU\...\Run to exercise registry FIM.

.DESCRIPTION
  The value points at notepad.exe (harmless) and is removed afterwards.
  Run as the logged-in lab user on the monitored Windows host.

.EXAMPLE
  .\windows-run-key-test.ps1 -ConfirmLab
#>
param([switch]$ConfirmLab)
if (-not $ConfirmLab) { Write-Error "Refusing to run: pass -ConfirmLab (isolated lab only)."; exit 1 }

$key  = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$name = "LabFimTest"
Set-ItemProperty -Path $key -Name $name -Value "C:\Windows\System32\notepad.exe"
Write-Host "Added $name. Wait for the next syscheck cycle (frequency 60 s), then check the Integrity monitoring dashboard."

Read-Host "Press Enter to remove the value"
Remove-ItemProperty -Path $key -Name $name
Write-Host "Removed $name (this removal is also a registry change and should alert)."
