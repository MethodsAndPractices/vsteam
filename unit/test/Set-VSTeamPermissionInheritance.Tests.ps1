Set-StrictMode -Version Latest

# Loading System.Web avoids issues finding System.Web.HttpUtility
Add-Type -AssemblyName 'System.Web'
$env:testing=$true
# Loading the code from source files will break if functionality moves from one file to another, instead
# the InModuleScope command allows you to perform white-box unit testing on the
# internal \(non-exported\) code of a Script Module, ensuring the module is loaded.


InModuleScope VSTeam {
   Describe 'Set-VSTeamPermissionInheritance' {
      Mock _getInstance { return 'https://dev.azure.com/test' } -Verifiable

      $buildDefresults = Get-Content "$PSScriptRoot\sampleFiles\buildDefAzD.json" -Raw | ConvertFrom-Json
      $releaseDefresults = Get-Content "$PSScriptRoot\sampleFiles\releaseDefAzD.json" -Raw | ConvertFrom-Json
      $gitRepoResult = Get-Content "$PSScriptRoot\sampleFiles\singleGitRepo.json" -Raw | ConvertFrom-Json
      $gitRepoHierarchyUpdateResults = Get-Content "$PSScriptRoot\sampleFiles\gitReopHierarchyQuery_Update.json" -Raw | ConvertFrom-Json
      $buildDefHierarchyUpdateResults = Get-Content "$PSScriptRoot\sampleFiles\buildDefHierarchyQuery_Update.json" -Raw | ConvertFrom-Json
      $accesscontrollistsResult = Get-Content "$PSScriptRoot\sampleFiles\repoAccesscontrollists.json" -Raw | ConvertFrom-Json
      $releaseDefHierarchyUpdateResults = Get-Content "$PSScriptRoot\sampleFiles\releaseDefHierarchyQuery_Update.json" -Raw | ConvertFrom-Json

      $singleResult = [PSCustomObject]@{
         name        = 'Project'
         description = ''
         url         = ''
         id          = '123-5464-dee43'
         state       = ''
         visibility  = ''
         revision    = 0
         defaultTeam = [PSCustomObject]@{}
         _links      = [PSCustomObject]@{}
      }

   Mock _getInstance { return 'https://dev.azure.com/test' }
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Build' -or $Service -eq 'Release' -or $Service -eq 'Git' }

      # Mock the call to Get-Projects by the dynamic parameter for ProjectName
      Mock Invoke-RestMethod { return @() } -ParameterFilter {
         $Uri -like "*_apis/projects*"
      }

      Context 'Set-VSTeamPermissionInheritance buildDef' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Get-VSTeamProject { return $singleResult }
         Mock Get-VSTeamBuildDefinition { return $buildDefresults.value }
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args
            # Write-Host $([VSTeamVersions]::Build)

            return $buildDefHierarchyUpdateResults
         }

         It 'should return true' {
            Set-VSTeamPermissionInheritance -projectName project -Name dynamTest-Docker-CI -resourceType BuildDefinition -NewState $false -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Body -like '*123-5464-dee43/1432*' -and
               $Body -like '*33344d9c-fc72-4d6f-aba5-fa317101a7e9*' -and
               $Uri -like "*/_apis/Contribution/HierarchyQuery/123-5464-dee43*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Build)*"
            }
         }
      }

      Context 'Set-VSTeamPermissionInheritance releaseDef' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Get-VSTeamProject { return $singleResult }
         Mock Get-VSTeamReleaseDefinition { return $releaseDefresults.value }
         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            # Write-Host $args
            # Write-Host $([VSTeamVersions]::Release)

            return $releaseDefHierarchyUpdateResults
         }

         It 'should return true' {
            Set-VSTeamPermissionInheritance -projectName project -Name PTracker-CD -resourceType ReleaseDefinition -NewState $false -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Body -like '*c788c23e-1b46-4162-8f5e-d7585343b5de*' -and
               $Body -like '*123-5464-dee43//2*' -and
               $Uri -like "*/_apis/Contribution/HierarchyQuery/123-5464-dee43*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Release)*"
            }
         }
      }

      Context 'Set-VSTeamPermissionInheritance repository' {
         Mock _useWindowsAuthenticationOnPremise { return $true }
         Mock Get-VSTeamProject { return $singleResult }
         Mock Get-VSTeamGitRepository { return $gitRepoResult }
         Mock Get-VSTeamAccessControlList { return $accesscontrollistsResult.value } -Verifiable

         Mock Invoke-RestMethod {
            # If this test fails uncomment the line below to see how the mock was called.
            #Write-Host $args
            #Write-Host $([VSTeamVersions]::Git)

            return $gitRepoHierarchyUpdateResults
         }

         It 'should return true' {
            Set-VSTeamPermissionInheritance -projectName project -Name project -resourceType Repository -NewState $false -Force

            Assert-MockCalled Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Method -eq 'Post' -and
               $Body -like '*2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87*' -and
               $Body -like '*repoV2/123-5464-dee43/00000000-0000-0000-0000-000000000001*' -and
               $Uri -like "*/_apis/Contribution/HierarchyQuery/123-5464-dee43*" -and
               $Uri -like "*api-version=$([VSTeamVersions]::Git)*"
            }
         }
      }
   }
}