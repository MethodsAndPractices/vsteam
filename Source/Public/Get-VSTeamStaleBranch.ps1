function Get-VSTeamStaleBranch {
   [CmdletBinding(DefaultParameterSetName="ByProjectId")]
   param (
      [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "ByRepositoryId")]
      [Alias("Id")]
      [guid] $RepositoryId,

      [int] $MaximumAgeDays = 90
   )

   DynamicParam {
      try { [void] $RepositoryId }
      catch { $RepositoryId = $null }

      if ($null -ne $RepositoryId) {
         $dynamic = _buildProjectNameDynamicParam -ParameterSetName "ByRepositoryId" -Mandatory $true
      } else {
         $dynamic = _buildProjectNameDynamicParam -ParameterSetName "ByProjectId" -Mandatory $false
      }

      $dynamic
   }

   process {
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]
      $maximumAge = (Get-Date).AddDays(-$MaximumAgeDays)

      try {
         if ($RepositoryId) # Retrieve single repository
         {
            Write-Verbose "Retrieving Branches for Repository ID $RepositoryId in Project $ProjectName"
            $repository = Get-VSTeamGitRepository -ProjectName $ProjectName -RepositoryId $RepositoryId
            $branches = $repository | Get-VSTeamGitRef -Filter "heads"
            foreach ($branch in $branches)
            {
               Write-Verbose "Processing Branch $($branch.RefName)"
               $isStale = ((Get-VSTeamGitCommit -ProjectName $ProjectName -RepositoryId $RepositoryId -FromDate $maximumAge -Top 1) | Measure-Object).Count -ne 1
               if ($isStale)
               {
                  Write-Verbose "Branch $($branch.RefName) is stale!"
                  $branchStats = Get-VSTeamGitStat -ProjectName $ProjectName -RepositoryId $RepositoryId -BranchName ($branch.RefName -replace 'refs/heads/', '')
                  
                  $object =
                     [PSCustomObject]@{
                        ProjectName = $ProjectName
                        RepositoryName = $repository.Name
                        BranchName = ($branch.RefName -replace 'refs/heads/', '')
                        Creator = $branch.Creator
                        LastCommitId = $branchStats.commit.commitId
                        LastCommitter = $branchStats.commit.committer.name
                        LastCommitDate = $branchStats.commit.committer.date
                        Ahead = $branchStats.aheadCount
                        Behind = $branchStats.behindCount
                     }

                  _applyTypes $object "Team.GitStaleBranch"
                  Write-Output $object
               }
            }
         } elseif ($ProjectName) { # Retrieve whole project (recursive)
            Write-Verbose "Retrieving Repositories for Project $ProjectName"
            $repos = Get-VSTeamGitRepository -ProjectName $ProjectName
            foreach ($repo in $repos)
            {
               $staleBranchesResult = Get-VSTeamStaleBranch -ProjectName $ProjectName -RepositoryId $repo.Id -MaximumAgeDays $MaximumAgeDays
               foreach ($result in $staleBranchesResult)
               {
                  Write-Output $result
               }
            }
         } else { # Retrieve all projects (recursive)
            Write-Verbose "Retrieving all Projects"
            $projects = Get-VSTeamProject 
            foreach ($project in $projects)
            {
               $staleBranchesResult = Get-VSTeamStaleBranch -ProjectName $project.Name -MaximumAgeDays $MaximumAgeDays
               foreach ($result in $staleBranchesResult)
               {
                  Write-Output $result
               }
            }
         }
      }
      catch {
         throw $_
      }
   }
}