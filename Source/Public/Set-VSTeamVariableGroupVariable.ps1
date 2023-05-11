function Set-VSTeamVariableGroupVariable {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Set-VSTeamVariableGroupVariable')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $GroupName,

      [Parameter(Mandatory = $true)]
      [string] $Name,

      [string] $Value,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($Force -or $pscmdlet.ShouldProcess("$GroupName.$Name", "Set Variable Value")) {
         try {
            $gl = Get-VSTeamVariableGroup -ProjectName $ProjectName
            # Exception if a group with a name is not found is not particularly descriptive
            $g = $gl | Where-Object -FilterScript {$_.Name -eq $GroupName}
            if($g) {
               if($g.variables | Get-Member -Name $Name) {
                  if(($g.variables.$Name | Get-Member -Name isSecret) -and $g.variables.$Name.isSecret) {
                     Write-Error "The variable $Name is a secret one. Updating secret variables is not currently supported."
                     return
                  }
                  else {
                      $g.variables.$Name.value = $Value
                  }
               }
               else {
                  Add-Member -InputObject $g.variables -MemberType NoteProperty -Name $Name -Value ([pscustomobject]@{value=$Value})
               }
               $body = $g | ConvertTo-Json -Depth 20 -Compress
               Update-VSTeamVariableGroup -ProjectName $ProjectName -Id $g.Id -Body $body -Force | Out-Null
            }
            else {
               Write-Error "Group $GroupName was not found."
               return
            }
         }
         catch {
            _handleException $_
         }
      }
   }
}
