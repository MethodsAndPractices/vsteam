function Set-VSTeamDefaultProject {
   [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
   param(
      [switch] $Force,

      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [string] $Project
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
         $ParameterAttribute.HelpMessage = "On Windows machines allows you to store the default project at the process, user or machine level. Not available on other platforms."
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
      if ($Force -or $pscmdlet.ShouldProcess($Project, "Set-VSTeamDefaultProject")) {
         [VSTeamVersions]::DefaultProject = $Project
         $env:TEAM_PROJECT = $Project

         $env:TEAM_PROCESS =  _callapi  -NoProject -area 'work' -resource 'processes' -version (_getAPIVersion ProcessDefinition) -QueryString @{'$expand'='projects'} |
                   Select-Object -ExpandProperty Value  | 
                     Where-Object {$_.psobject.properties['projects'] -and $_.projects.name -eq $ProjectName} |
                        Select-Object -ExpandProperty Name 
         [VSTeamVersions]::DefaultProcess = $env:TEAM_PROCESS

         if  ((_isOnWindows) -and $Level -and $level -ne "Process") {
            [System.Environment]::SetEnvironmentVariable("TEAM_PROJECT", $Project,           $Level)
            [System.Environment]::SetEnvironmentVariable("TEAM_PROCESS", $env:TEAM_PROCESS , $Level)
         }

         $Global:PSDefaultParameterValues["*-vsteam*:projectName"] = $Project
      }
   }
}
