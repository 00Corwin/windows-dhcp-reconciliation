<#
.SYNOPSIS
    Reconciles Windows DHCPv4 scope lease and reservation records.

.DESCRIPTION
    Enumerates DHCPv4 scopes on the target DHCP server and runs
    Repair-DhcpServerv4IPRecord for each scope.

.PARAMETER ComputerName
    DHCP server to process. Defaults to the local computer.

.PARAMETER ScopeId
    Optional single IPv4 scope ID. If omitted, all IPv4 scopes are processed.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$ComputerName = $env:COMPUTERNAME,

    [System.Net.IPAddress]$ScopeId
)

Import-Module DhcpServer -ErrorAction Stop

if ($ScopeId) {
    $Scopes = @(
        Get-DhcpServerv4Scope -ComputerName $ComputerName -ScopeId $ScopeId -ErrorAction Stop
    )
}
else {
    $Scopes = @(
        Get-DhcpServerv4Scope -ComputerName $ComputerName -ErrorAction Stop
    )
}

foreach ($Scope in $Scopes) {
    $Target = "$ComputerName / $($Scope.ScopeId)"

    if ($PSCmdlet.ShouldProcess($Target, 'Repair DHCPv4 IP records')) {
        try {
            Repair-DhcpServerv4IPRecord `
                -ComputerName $ComputerName `
                -ScopeId $Scope.ScopeId `
                -ErrorAction Stop

            [PSCustomObject]@{
                ComputerName = $ComputerName
                ScopeId      = $Scope.ScopeId
                ScopeName    = $Scope.Name
                Status       = 'Success'
                Error        = $null
            }
        }
        catch {
            [PSCustomObject]@{
                ComputerName = $ComputerName
                ScopeId      = $Scope.ScopeId
                ScopeName    = $Scope.Name
                Status       = 'Failed'
                Error        = $_.Exception.Message
            }
        }
    }
}
