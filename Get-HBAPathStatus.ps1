#add input files
$VMHosts = get-cluster (Get-content C:\temp\cluster.txt) | Get-VMHost | ? { $_.ConnectionState -eq “Connected” } | Sort-Object -Property Name
$allresults= @()
$datastore = @()
foreach ($VMHost in $VMHosts) {
 write-host “Working on host $VMHost”
[ARRAY]$HBAs = $VMHost | Get-VMHostHba -Type “FibreChannel”
$datastore = Get-Datastore -VMHost $VMHost

foreach ($HBA in $HBAs) {
 $results = “” | select Name, Device, Cluster, ActiveP, DeadP, StandbyP , Datastore
 $pathState = $HBA | Get-ScsiLun | ? { $_.Vendor -match “EMC”} | Get-ScsiLunPath | Group-Object -Property state
 $results.Name = $VMHost.Name
 $results.Device = $HBA.Device
 $results.Cluster = $VMHost.Parent
 $results.ActiveP = [INT]($pathState | ? { $_.Name -eq “Active”}).Count
 $results.DeadP = [INT]($pathState | ? { $_.Name -eq “Dead”}).Count
 $results.StandbyP = [INT]($pathState | ? { $_.Name -eq “Standby”}).Count
 $results.Datastore = ([ARRAY]$datastore.name) -join ','
 $allresults += $results
 }

}

# Display the results in Gridview
 $allresults | ft -AutoSize
 # Or export to a CSV
  $allresults | export-csv -Path C:\Temp\path.csv 
  C:\Temp\path.csv
disconnect-viserver -confirm:$false
