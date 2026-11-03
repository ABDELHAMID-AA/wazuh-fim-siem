<#
.SYNOPSIS
  [Recommendation] Create a burst of FIM events in a monitored test folder (benign).

.DESCRIPTION
  Creates N small dummy files and then appends a line to each, entirely inside a folder you
  point at (it must be a monitored path, e.g. the test directory from the agent config).
  No encryption, no user data, no deletion outside the files it created. Intended to push the
  FIM-event rate past rule 120105 (30 events in 60 s).

.EXAMPLE
  .\windows-fim-burst.ps1 -Path "C:\Users\LAB_USER\Desktop\FIM-Test" -ConfirmLab
#>
param(
  [Parameter(Mandatory = $true)][string]$Path,
  [ValidateRange(10,200)][int]$Files = 40,
  [switch]$ConfirmLab
)
if (-not $ConfirmLab) { Write-Error "Refusing to run: pass -ConfirmLab (isolated lab only)."; exit 1 }

$work = Join-Path $Path ("fim-burst-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
New-Item -ItemType Directory -Path $work -Force | Out-Null

1..$Files | ForEach-Object { Set-Content -Path (Join-Path $work "file$_.txt") -Value "dummy $_" }
1..$Files | ForEach-Object { Add-Content -Path (Join-Path $work "file$_.txt") -Value "modified $_" }
Write-Host "Generated about $($Files * 2) file events in $work. Expect 120104 per event and 120105 once 30 occur within 60 s."

Read-Host "Press Enter to delete the files this script created"
Remove-Item -Path $work -Recurse -Force
Write-Host "Cleaned up."
