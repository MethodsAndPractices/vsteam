function Set-VSTeamDefaultProject {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $Project
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
      if ($Force -or $pscmdlet.ShouldProcess($Project, "Set-VSTeamDefaultProject")) {
         if (_isOnWindows) {
            if (-not $Level) {
               $Level = "Process"
            }

            # You always have to set at the process level or they will Not
            # be seen in your current session.
            $env:TEAM_PROJECT = $Project
            [vsteam_lib.Versions]::DefaultProject = $Project

            [System.Environment]::SetEnvironmentVariable("TEAM_PROJECT", $Project, $Level)
         }

         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = $Project
      }
   }
}
