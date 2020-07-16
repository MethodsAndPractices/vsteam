function Set-VSTeamDefaultAPITimeout {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0)]
      [int] $TimeoutSec
   )
   DynamicParam {
      $dp = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

      # Only add these options on Windows Machines
      if (_isOnWindows) {
         $ParameterName = 'Level'
         # Create the collection of attributes
         $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
         # Create and set the parameters' attributes
         $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
         $ParameterAttribute.Mandatory = $false
         $ParameterAttribute.HelpMessage = "On Windows machines allows you to store the default timeout at the process, user or machine level. Not available on other platforms."
         # Add the attributes to the attributes collection
         $AttributeCollection.Add($ParameterAttribute)
         # Generate and set the ValidateSet
         if (_testAdministrator) {
            $arrSet = "Process", "User", "Machine"
         }
         else {
            $arrSet = "Process", "User"
         }
         $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($arrSet)
         # Add the ValidateSet to the attributes collection
         $AttributeCollection.Add($ValidateSetAttribute)
         # Create and return the dynamic parameter
         $RuntimeParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName, [string], $AttributeCollection)
         $dp.Add($ParameterName, $RuntimeParameter)
      }

      return $dp
   }

   begin {
      if (_isOnWindows) {
         $Level = $PSBoundParameters[$ParameterName]
      }
   }

   process {
      if ($Force -or $pscmdlet.ShouldProcess($TimeoutSec, "Set-VSTeamDefaultAPITimeout")) {
         if (_isOnWindows) {
            if (-not $Level) {
               $Level = "Process"
            }

            # You always have to set at the process level or they will Not
            # be seen in your current session.
            $env:TEAM_TIMEOUT = $TimeoutSec
            [VSTeamVersions]::DefaultTimeout = $TimeoutSec

            [System.Environment]::SetEnvironmentVariable("TEAM_TIMEOUT", $TimeoutSec, $Level)
         }

         $Global:PSDefaultParameterValues["*-vsteam*:vsteamApiTimeout"] = $TimeoutSec
      }
   }
}
