# Windows DHCP Reconciliation

A reusable PowerShell project for Windows DHCPv4 reconciliation and optional
scheduled execution outside business hours.

## Scripts

- `Invoke-DhcpReconciliation.ps1` enumerates scopes and calls
  `Repair-DhcpServerv4IPRecord`.
- `Register-DhcpReconciliationTask.ps1` registers a daily SYSTEM scheduled
  task for the reconciliation script.

## Requirements

Run on a Windows system with the **DHCP Server PowerShell module** installed and
with rights to administer the target DHCP server.

## Examples

```powershell
.\scripts\Invoke-DhcpReconciliation.ps1 -WhatIf

.\scripts\Invoke-DhcpReconciliation.ps1 `
    -ComputerName DHCP01

.\scripts\Register-DhcpReconciliationTask.ps1 `
    -ScriptPath C:\Scripts\Invoke-DhcpReconciliation.ps1 `
    -DailyAt 02:00
```
