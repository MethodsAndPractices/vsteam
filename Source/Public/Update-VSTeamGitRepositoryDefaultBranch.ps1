# Sets the default branch for a Git repository in your Azure DevOps or Team Foundation Server account.
#
# Get-VSTeamOption 'git' 'repositories'
# id              : 225f7195-f9c7-4d14-ab28-a83f7ff77e1f
# area            : git
# resourceName    : repositories
# routeTemplate   : {project}/_apis/{area}/{resource}/{repositoryId}
# https://docs.microsoft.com/en-us/rest/api/azure/devops/git/repositories/update?view=azure-devops-rest-6.1&tabs=HTTP
function Update-VSTeamGitRepositoryDefaultBranch {
   [CmdletBinding(HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamGitRepositoryDefaultBranch', SupportsShouldProcess = $true)]
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
      if ($DefaultBranch -notlike "*refs/heads*") {
         $DefaultBranch = 'refs/heads/{0}' -f $DefaultBranch
      }
      try {
         $Repo = Get-VSTeamGitRepository -Name $Name -ProjectName $ProjectName
      } catch {
         Write-Warning "A repo named $Name could not be found in the project $ProjectName..."
         throw $PSItem.Exception.Message
      }
      $Refs = Get-VSTeamGitRef -RepositoryID $Repo.Id -ProjectName $ProjectName
      $BranchNames = $Refs.Name
      if ($DefaultBranch -notin $BranchNames) {
         $rawDefaultBranch = $DefaultBranch.replace('refs/heads/', $null)
         throw "No branch named $rawDefaultBranch was found..." 
      }
   }
   process {
      $body = @{  
         defaultBranch = "$DefaultBranch"
      } | ConvertTo-Json -Compress
      try {
         # Call the REST API 
         if ($PSCmdlet.ShouldProcess("$ProjectName", "Setting default branch to $DefaultBranch")) {
            $Parameters = @{
               Method      = 'PATCH'
               ProjectName = $ProjectName
               Area        = "git"
               Resource    = "repositories"
               id          = $Repo.Id
               Body        = $body
               Version     = $(_getApiVersion Git)
            }
            $resp = _callApi @Parameters
            
         }
      } catch {
         _handleException $_
      }
   }
   end {
      Write-Output $resp
   }
}