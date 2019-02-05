function Get-VSTeamGitRepository {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param (
      [Parameter(ParameterSetName = 'ByID', ValueFromPipeline = $true)]
      [Alias('RepositoryID')]
      [guid[]] $Id,

      [Parameter(ParameterSetName = 'ByName', ValueFromPipeline = $true)]
      [string[]] $Name
   )

   DynamicParam {
      _buildProjectNameDynamicParam -mandatory $false
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      if ($id) {
         foreach ($item in $id) {
            try {
               $resp = _callAPI -ProjectName $ProjectName -Id $item -Area git -Resource repositories -Version $([VSTeamVersions]::Git)

               # Storing the object before you return it cleaned up the pipeline.
               # When I just write the object from the constructor each property
               # seemed to be written
               $item = [VSTeamGitRepository]::new($resp, $ProjectName)

               Write-Output $item
            }
            catch {
               throw $_
            }
         }
      }
      elseif ($Name) {
         foreach ($item in $Name) {
            try {
               $resp = _callAPI -ProjectName $ProjectName -Id $item -Area git -Resource repositories -Version $([VSTeamVersions]::Git)

               # Storing the object before you return it cleaned up the pipeline.
               # When I just write the object from the constructor each property
               # seemed to be written
               $item = [VSTeamGitRepository]::new($resp, $ProjectName)

               Write-Output $item
            }
            catch {
               throw $_
            }
         }
      }
      else {
         if($ProjectName) {
            $resp = _callAPI -ProjectName $ProjectName -Area git -Resource repositories -Version $([VSTeamVersions]::Git)
         } else {
            $resp = _callAPI -Area git -Resource repositories -Version $([VSTeamVersions]::Git)
         }

         $objs = @()

         foreach ($item in $resp.value) {
            $objs += [VSTeamGitRepository]::new($item, $ProjectName)
         }

         Write-Output $objs         
      }
   }
}