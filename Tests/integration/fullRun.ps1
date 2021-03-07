function Run-Tests {
   [CmdletBinding()]
   param (
      [string] $checkPoint,
      [string] $version
   )
   
   begin {
      Write-Host 'Applying checkpoint'
      Restore-VMCheckpoint -VMName VSTeamOnPremTester -Name $checkPoint -Confirm:$false

      # Make sure the DVD is empty
      Get-VM vsteamonpremtester | Get-VMDvdDrive | Set-VMDvdDrive -Path $null
      
      Write-Host 'Starting VM'
      start-vm -VMName VSTeamOnPremTester
   }
   
   process {
      Write-Host 'Giving VM time to spin up'
      Start-Sleep -Seconds 120
      
      Write-Host 'Starting tests'
      ./prime.ps1 -Version $version -RunTests
   }
   
   end {
      Write-Host 'Stopping VM'
      stop-vm -VMName VSTeamOnPremTester
   }
}

Push-Location
Set-Location ..
./Build-Module.ps1 -ipmo
Pop-Location

Write-Host 'Testing TFS2017 Update 3'
Run-Tests -checkPoint 'TFS2017 Update 3' -version 'TFS2017'

# Write-Host 'Testing TFS2018 Update 3'
# Run-Tests -checkPoint 'TFS2018 Update 3' -version 'TFS2018'

# Write-Host 'Testing AZD2019 Update 1'
# Run-Tests -checkPoint 'AZD2019 Update 1' -version 'AzD2019'
