# PowerCLI Script for adding syslogserver to the hosts on a cluster
# Written By Yajuvendra Singh
# Version 1.0

Write-Host "This script will change syslog server on a given cluster"
$vi_server = Read-Host “Please Input Your vCenter Server FQDN Name (or) IP”
$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter your user name

and password.", "", "NetBiosUserName")
Write-Host "Connecting to Vcenter `n"
Connect-VIServer -Server $vi_server -Credential $Credential
Write-Host "`n`n"
$Cluster = Get-Cluster
$Cluster.Name
$VCluster = Read-Host "Enter Cluster Name"
$syslogservers = Read-Host “Enter syslog server name Example udp://example.com:514"

# Make sure to tweak the protocol and ports below to match your environment
$Vmhosts = @(Get-Cluster $VCluster | Get-VMHost )

# Configure syslog on each host in vCenter
foreach ($Vmhost in $Vmhosts) {
Write-Host "Setting Syslog on $Vmhost" -BackgroundColor Black -ForegroundColor Green
Set-VMHostAdvancedConfiguration -Name Syslog.global.logHost -Value "$syslogservers" -VMHost

$vmhost
$esxcli = Get-EsxCli -VMHost $vmhost
$esxcli.system.syslog.reload()
}
foreach($Vmhost in $Vmhosts){
$syslogserver = Get-VMHostSysLogServer -VMhost $Vmhost
Write-Host "Syslog server for $vmhost is set to $syslogserver " -BackgroundColor Black -

ForegroundColor Green
}

Disconnect-VIServer $vi_server -Confirm:$false
