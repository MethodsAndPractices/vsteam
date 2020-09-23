function Update-VSTeamProject {
   [CmdletBinding(DefaultParameterSetName = 'ByName', SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamProject')]
   param(
      [string] $NewName = '',

      [string] $NewDescription = '',

      [switch] $Force,

      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByName', Position = 0, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter]) ]
      [Alias('Name')]
      [string] $ProjectName
   )
   process {
      if ($id) {
         $ProjectName = $id
      }
      else {
         $id = (Get-VSTeamProject $ProjectName).id
      }

      if ($newName -eq '' -and $newDescription -eq '') {
         # There is nothing to do
         Write-Verbose 'Nothing to update'
         return
      }

      if ($Force -or $pscmdlet.ShouldProcess($ProjectName, "Update Project")) {
         # At the end we return the project and need it's name
         # this is used to track the final name.
         $finalName = $ProjectName

         if ($newName -ne '' -and $newDescription -ne '') {
            $finalName = $newName
            $msg = "Changing name and description"
            $body = '{"name": "' + $newName + '", "description": "' + $newDescription + '"}'
         }
         elseif ($newName -ne '') {
            $finalName = $newName
            $msg = "Changing name"
            $body = '{"name": "' + $newName + '"}'
         }
         else {
            $msg = "Changing description"
            $body = '{"description": "' + $newDescription + '"}'
         }

         # Call the REST API
         $resp = _callAPI -Method PATCH -NoProject `
            -Resource projects `
            -id $id `
            -body $body `
            -Version $(_getApiVersion Core)

         _trackProjectProgress -resp $resp -title 'Updating team project' -msg $msg

         # Invalidate any cache of projects.
         [vsteam_lib.ProjectCache]::Invalidate()

         # Return the project now that it has been updated
         return Get-VSTeamProject -Id $finalName
      }
   }
}
