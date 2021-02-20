function Set-VSTeamDefaultProjectCount {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int] $Count
   )
   DynamicParam {
      _buildLevelDynamicParam
   }

   begin {
      if (_isOnWindows) {
         $Level = $PSBoundParameters['Level']
      }
   }

   process {
      if ($Force -or $pscmdlet.ShouldProcess($Count, "Set-VSTeamDefaultProjectCount")) {
         if (_isOnWindows) {
            if (-not $Level) {
               $Level = "Process"
            }

            [System.Environment]::SetEnvironmentVariable("TEAM_PROJECTCOUNT", $Count, $Level)
         }

         # You always have to set at the process level or they will Not
         # be seen in your current session.
         $env:TEAM_PROJECTCOUNT = $Count
      }
   }
}
