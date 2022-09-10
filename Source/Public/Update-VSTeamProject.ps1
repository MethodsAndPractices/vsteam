function Update-VSTeamProject {
   [CmdletBinding(DefaultParameterSetName = 'ByName', SupportsShouldProcess = $true, ConfirmImpact = "High",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamProject')]
   param(
      [string] $NewName = '',

      [string] $NewDescription = '',

      [validateset('private','public')]
      [string] $Visibility = '',

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

      if ($Force -or $pscmdlet.ShouldProcess($ProjectName, "Update Project")) {
         # At the end we return the project and need it's name
         # this is used to track the final name.
         $finalName = $ProjectName

         $body = @{}

         if ($NewName -ne '' -and $NewDescription -ne '') {
            $finalName = $NewName
            $msg = "Changing name and description"
            $body.name = $NewName
            $body.description = $NewDescription
         }
         elseif ($NewName -ne '') {
            $finalName = $NewName
            $msg = "Changing name"
            $body.name = $NewName
         }
         else {
            $msg = "Changing description"
            $body.description = $newDescription
         }

         if ($Visibility -ne '') {
            $msg += " and visibility"
            $body.visibility = $Visibility
         }

         # Call the REST API
         $resp = _callAPI -Method PATCH -NoProject `
            -Resource projects `
            -id $id `
            -body ($body | ConvertTo-Json -Compress -Depth 100) `
            -Version $(_getApiVersion Core)

         _trackProjectProgress -resp $resp -title 'Updating team project' -msg $msg

         # Invalidate any cache of projects.
         _invalidate

         # Return the project now that it has been updated
         return Get-VSTeamProject -Id $finalName
      }
   }
}
