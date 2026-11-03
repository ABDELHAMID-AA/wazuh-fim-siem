<# [Recommendation] Quick health check of a Windows Wazuh agent (run elevated). #>
$base = "C:\Program Files (x86)\ossec-agent"
Write-Host "== Service =="
Get-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue | Format-Table Name, Status -AutoSize

Write-Host "== Recent agent log lines =="
Get-Content "$base\ossec.log" -Tail 200 |
  Select-String -Pattern "Connected to the server|Unable to connect|ERROR|syscheck" |
  Select-Object -Last 8

Write-Host "== Event channels readable =="
foreach ($c in "Security","System","Application") {
  try { Get-WinEvent -LogName $c -MaxEvents 1 | Out-Null; Write-Host "ok      : $c" }
  catch { Write-Host "FAILED  : $c" }
}
