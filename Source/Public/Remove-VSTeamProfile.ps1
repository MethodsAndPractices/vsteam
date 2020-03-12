function Remove-VSTeamProfile {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      # Name is an array so I can pass an array after -Name
      # I can also use pipe
      [parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
      [string[]] $Name,
      [switch] $Force
   )

   begin {
      $profiles = Get-VSTeamProfile
   }

   process {
      foreach ($item in $Name) {
         if ($Force -or $pscmdlet.ShouldProcess($item, "Remove-VSTeamProfile")) {
            # See if this item is already in there
            $profiles = $profiles | Where-Object Name -ne $item
         }
      }
   }

   end {
      $contents = ConvertTo-Json $profiles

      # As of version 7.0 of PowerShell core To-Json contains the string null
      if ([string]::isnullorempty($contents) -or 'null' -eq $contents) {
         $contents = ''
      }

      Set-Content -Path $profilesPath -Value $contents
   }
}