# Sets the default branch for a Git repository in your Azure DevOps or Team Foundation Server account.
#
# Get-VSTeamOption 'git' 'repositories'
# id              : 225f7195-f9c7-4d14-ab28-a83f7ff77e1f
# area            : git
# resourceName    : repositories
# routeTemplate   : {project}/_apis/{area}/{resource}/{repositoryId}
# http://bit.ly/Add-VSTeamGitRepository
function Update-VSTeamGitRepositoryDefaultBranch {
   [CmdletBinding()]
   param(
      [parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Name,
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $DefaultBranch
   )
   begin {
      try {
         # $Repo = Get-VSTeamGitRepository -Name $Name -ProjectName $ProjectName
         $Repo = _callAPI -Method Get -ProjectName $ProjectName `
            -Area "git" `
            -Resource "repositories" `
            -id $Name `
            -Version $(_getApiVersion Git)
      } catch {
         Write-Warning "A repo named $Name could not be found in the project $ProjectName..."
         throw $PSItem.Exception.Message
      }
      if ($DefaultBranch -notlike "*refs/head*") {
         $DefaultBranch = 'refs/head/{0}' -f $DefaultBranch
      }
   }
   process {
      
      
      $body = @{  
         # name          = $Name
         defaultBranch = "refs/head/$DefaultBranch"
      }
      try {
         # Call the REST API
         $resp = _callAPI -Method PATCH -ProjectName $ProjectName `
            -Area "git" `
            -Resource "repositories" `
            -id $Repo.Id `
            -Body $body `
            -Version $(_getApiVersion Git)
         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         # $repo = [vsteam_lib.GitRepository]::new($resp, $ProjectName)
         Write-Output $resp   
      } catch {
         _handleException $_
      }
   }
}