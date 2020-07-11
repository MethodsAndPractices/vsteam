function Update-VSTeamProject {
   [CmdletBinding(DefaultParameterSetName = 'ByName', SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [string] $NewName = '',

      [string] $NewDescription = '',

      [switch] $Force,

      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [string] $Id,

      [Alias('ProjectName')]
      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter]) ]
      [Parameter(ParameterSetName = 'ByName', Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $Name
   )
   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["Name"]

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
         $resp = _callAPI -Area 'projects' -id $id -NoProject `
            -Method Patch -ContentType 'application/json' -body $body -Version $(_getApiVersion Core)

         _trackProjectProgress -resp $resp -title 'Updating team project' -msg $msg

         # Invalidate any cache of projects.
         [VSTeamProjectCache]::Invalidate()

         # Return the project now that it has been updated
         return Get-VSTeamProject -Id $finalName
      }
   }
}
