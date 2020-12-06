function Clear-VSTeamDefaultProject {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
   [CmdletBinding()]
   param()

   DynamicParam {
      _buildLevelDynamicParam
   }

   begin {
      if (_isOnWindows) {
         # Bind the parameter to a friendly variable
         $Level = $PSBoundParameters['Level']
      }
   }

   process {
      if (_isOnWindows) {
         if (-not $Level) {
            $Level = "Process"
         }
      }
      else {
         $Level = "Process"
      }

      # You always have to set at the process level or they will Not
      # be seen in your current session.
      $env:TEAM_PROJECT = $null

      if (_isOnWindows) {
         [System.Environment]::SetEnvironmentVariable("TEAM_PROJECT", $null, $Level)
      }

      [vsteam_lib.Versions]::DefaultProject = ''
      $Global:PSDefaultParameterValues.Remove("*-vsteam*:projectName")

      Write-Output "Removed default project"
   }
}