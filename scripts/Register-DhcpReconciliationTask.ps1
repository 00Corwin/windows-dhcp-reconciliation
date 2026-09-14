<#
.SYNOPSIS
    Registers a scheduled task for DHCP reconciliation.

.PARAMETER ScriptPath
    Full path to Invoke-DhcpReconciliation.ps1.

.PARAMETER DailyAt
    Local time at which the task should run each day.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$ScriptPath,

    [datetime]$DailyAt = [datetime]'02:00',

    [string]$TaskName = 'DHCP IPv4 Reconciliation'
)

$PowerShell = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe"
$Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`""

$Action = New-ScheduledTaskAction -Execute $PowerShell -Argument $Arguments
$Trigger = New-ScheduledTaskTrigger -Daily -At $DailyAt
$Principal = New-ScheduledTaskPrincipal `
    -UserId 'SYSTEM' `
    -LogonType ServiceAccount `
    -RunLevel Highest

if ($PSCmdlet.ShouldProcess($TaskName, 'Register scheduled task')) {
    Register-ScheduledTask `
        -TaskName $TaskName `
        -Action $Action `
        -Trigger $Trigger `
        -Principal $Principal `
        -Description 'Runs Windows DHCPv4 record reconciliation outside business hours.' `
        -Force
}
