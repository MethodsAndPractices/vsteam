Set-StrictMode -Version Latest

# Controls if some tests get skipped based on API version or platform

$global:skippedOnTFS = ($env:ACCT -like "http://*")
$global:skipVariableGroups = ($env:API_VERSION -eq 'TFS2017')
$global:skipReleaseDefs = ($env:API_VERSION -eq 'TFS2017')

Describe 'VSTeam Integration Tests' -Tag 'integration' {
   BeforeAll {
      . "$PSScriptRoot/testprep.ps1"

      Set-TestPrep
      
      $acct = $env:ACCT
      $email = $env:EMAIL
      $api = $env:API_VERSION
      
      Write-Host "SkippedOnTFS = $($global:skippedOnTFS)"
      Write-Host "SkipVariableGroups = $($global:skipVariableGroups)"
      Write-Host "SkipReleaseDefs = $($global:skipReleaseDefs)"
      
      $originalLocation = Get-Location

      $target = Set-Project
   }

   AfterAll {
      # Put everything back
      Set-Location $originalLocation
   }

   Context 'Project full exercise' -Tag "Project" {
      It 'Get-VSTeamProject Should return projects' {
         Get-VSTeamProject -Name $target.Name -IncludeCapabilities | Should -Not -Be $null
      }

      It 'Update-VSTeamProject Should update description' {
         Update-VSTeamProject -Name $target.Name -NewDescription $target.Description -Force

         Get-VSTeamProject -Name $target.Name | Select-Object -ExpandProperty 'Description' | Should -Be $target.Description
      }

      It 'Update-VSTeamProject Should update name' {
         Update-VSTeamProject -Name $target.Name -NewName $target.NewName -Force

         # Calling Get-VSTeamProject with new name verifies the name was changed.
         Get-VSTeamProject -Name $target.NewName | Select-Object -ExpandProperty 'Description' | Should -Be $target.Description
      }
   }

   Context 'Git full exercise' {
      BeforeAll {
         # Everytime you run the test a new "$newProjectName" is generated.
         # This is fine if you are running all the tests but not if you just
         # want to run these. So if the newProjectName can't be found in the 
         # target system change newProjectName to equal the name of the project
         # found with the correct description.
         $newProjectName = Get-ProjectName
      }

      It 'Get-VSTeamGitRepository Should return repository' {
         Get-VSTeamGitRepository -ProjectName $newProjectName | Select-Object -ExpandProperty Name | Should -Be $newProjectName
      }

      It 'Add-VSTeamGitRepository Should create repository' {
         Add-VSTeamGitRepository -ProjectName $newProjectName -Name 'testing'

         (Get-VSTeamGitRepository -ProjectName $newProjectName).Count | Should -Be 2
         Get-VSTeamGitRepository -ProjectName $newProjectName -Name 'testing' | Select-Object -ExpandProperty Name | Should -Be 'testing'
      }

      It 'Remove-VSTeamGitRepository Should delete repository' {
         Get-VSTeamGitRepository -ProjectName $newProjectName -Name 'testing' | Select-Object -ExpandProperty Id | Remove-VSTeamGitRepository -Force

         Get-VSTeamGitRepository -ProjectName $newProjectName | Where-Object { $_.Name -eq 'testing' } | Should -Be $null
      }
   }

   Context 'BuildDefinition full exercise' -Tag "BuildDefinition" {
      BeforeAll {
         # Everytime you run the test a new "$newProjectName" is generated.
         # This is fine if you are running all the tests but not if you just
         # want to run these. So if the newProjectName can't be found in the 
         # target system change newProjectName to equal the name of the project
         # found with the correct description.
         $newProjectName = Get-ProjectName
            
         Add-VSTeamGitRepository -ProjectName $newProjectName -Name 'CI'
         $project = $repo = Get-VSTeamProject -Name $newProjectName
         $repo = Get-VSTeamGitRepository -ProjectName $newProjectName -Name 'CI'

         if ($acct -like "http://*") {
            $defaultQueue = Get-VSTeamQueue -ProjectName $newProjectName | Where-Object { $_.poolName -eq "Default" }
         }
         else {
            $defaultQueue = Get-VSTeamQueue -ProjectName $newProjectName | Where-Object { $_.poolName -eq "Hosted" }
         }

         $srcBuildDef = Get-Content "$PSScriptRoot\sampleFiles\010_builddef_1.json" -Raw | ConvertFrom-Json
         $srcBuildDef.project.id = $project.Id
         $srcBuildDef.queue.id = $defaultQueue.Id
         $srcBuildDef.repository.id = $repo.Id
         $srcBuildDef.name = $newProjectName + "-CI1"
         $tmpBuildDef1 = (New-TemporaryFile).FullName
         $srcBuildDef | ConvertTo-Json -Depth 10 | Set-Content -Path $tmpBuildDef1

         $srcBuildDef = Get-Content "$PSScriptRoot\sampleFiles\010_builddef_2.json" -Raw | ConvertFrom-Json
         $srcBuildDef.project.id = $project.Id
         $srcBuildDef.queue.id = $defaultQueue.Id
         $srcBuildDef.repository.id = $repo.Id
         $srcBuildDef.name = $newProjectName + "-CI2"
         $tmpBuildDef2 = (New-TemporaryFile).FullName
         $srcBuildDef | ConvertTo-Json -Depth 10 | Set-Content -Path $tmpBuildDef2
      }

      AfterAll {
         Get-VSTeamGitRepository -ProjectName $newProjectName -Name 'CI' | Remove-VSTeamGitRepository -Force
      }

      It 'Add-VSTeamBuildDefinition should add a build definition' {
         Add-VSTeamBuildDefinition -ProjectName $newProjectName -InFile $tmpBuildDef1
         $buildDef = Get-VSTeamBuildDefinition -ProjectName $newProjectName
         $buildDef | Should -Not -Be $null
      }

      It 'Add-VSTeamBuildDefinition should add another build definition' {
         Add-VSTeamBuildDefinition -ProjectName $newProjectName -InFile $tmpBuildDef2
         $buildDefs = Get-VSTeamBuildDefinition -ProjectName $newProjectName
         $buildDefs.Count | Should -Be 2
      }

      It 'Get-VSTeamBuildDefinition by Type "build" should return 2 build definitions' {
         Mock Write-Warning
         $buildDefs = Get-VSTeamBuildDefinition -ProjectName $newProjectName -Type build
         $buildDefs.Count | Should -Be 2
      }

      It 'Get-VSTeamBuildDefinition by Id should return intended attribute values for 1st build definition' -Skip:$skippedOnTFS {
         $buildDefId = (Get-VSTeamBuildDefinition -ProjectName $newProjectName | Where-Object { $_.Name -eq $($newProjectName + "-CI1") }).Id
         $buildDefId | Should -Not -Be $null
         $buildDef = Get-VSTeamBuildDefinition -ProjectName $newProjectName -Id $buildDefId
         $buildDef.Name | Should -Be $($newProjectName + "-CI1")
         $buildDef.GitRepository | Should -Not -Be $null
         $buildDef.Process.Phases.Count | Should -Be 1
         $buildDef.Process.Phases[0].Name | Should -Be "Phase 1"
         $buildDef.Process.Phases[0].Steps.Count | Should -Be 1
         $buildDef.Process.Phases[0].Steps[0].Name | Should -Be "PowerShell Script"
         $buildDef.Process.Phases[0].Steps[0].Inputs.targetType | Should -Be "inline"
      }

      It 'Get-VSTeamBuildDefinition by Id should return 2 phases for 2nd build definition' -Skip:$skippedOnTFS {
         $buildDefId = (Get-VSTeamBuildDefinition -ProjectName $newProjectName | Where-Object { $_.Name -eq $($newProjectName + "-CI2") }).Id
         ((Get-VSTeamBuildDefinition -ProjectName $newProjectName -Id $buildDefId).Process.Phases).Count | Should -Be 2
      }

      It 'Remove-VSTeamBuildDefinition should delete build definition' {
         Get-VSTeamBuildDefinition -ProjectName $newProjectName | Remove-VSTeamBuildDefinition -ProjectName $newProjectName -Force
         Get-VSTeamBuildDefinition -ProjectName $newProjectName | Should -Be $null
      }
   }

   Context 'ReleaseDefinition full exercise' -Skip:$skipReleaseDefs {
      BeforeAll {
         # Everytime you run the test a new "$newProjectName" is generated.
         # This is fine if you are running all the tests but not if you just
         # want to run these. So if the newProjectName can't be found in the 
         # target system change newProjectName to equal the name of the project
         # found with the correct description.
         $newProjectName = Get-ProjectName

         if ($acct -like "http://*") {
            $defaultQueue = Get-VSTeamQueue -ProjectName $newProjectName | Where-Object { $_.poolName -eq "Default" }
         }
         else {
            $defaultQueue = Get-VSTeamQueue -ProjectName $newProjectName | Where-Object { $_.poolName -eq "Hosted" }
         }

         $srcReleaseDef = Get-Content "$PSScriptRoot\sampleFiles\010_releasedef_1.json" -Raw | ConvertFrom-Json
         $srcReleaseDef.name = "$newProjectName-CD1"
         $srcReleaseDef.environments[0].deployPhases[0].deploymentInput.queueId = $defaultQueue.Id
         $tmpReleaseDef1 = (New-TemporaryFile).FullName
         $srcReleaseDef | ConvertTo-Json -Depth 10 | Set-Content -Path $tmpReleaseDef1

         Add-VSTeamReleaseDefinition -ProjectName $newProjectName -InFile $tmpReleaseDef1

         $srcReleaseDef = Get-Content "$PSScriptRoot\sampleFiles\010_releasedef_2.json" -Raw | ConvertFrom-Json
         $srcReleaseDef.name = "$newProjectName-CD2"
         $srcReleaseDef.environments[0].deployPhases[0].deploymentInput.queueId = $defaultQueue.Id
         $tmpReleaseDef2 = (New-TemporaryFile).FullName
         $srcReleaseDef | ConvertTo-Json -Depth 10 | Set-Content -Path $tmpReleaseDef2

         Add-VSTeamReleaseDefinition -ProjectName $newProjectName -InFile $tmpReleaseDef2
      }

      It 'Should have 2 release definition' {
         $buildDefs = Get-VSTeamReleaseDefinition -ProjectName $newProjectName
         $buildDefs.Count | Should -Be 2
      }

      It 'Get-VSTeamReleaseDefinition by Id should return intended attribute values for 1st release definition' {
         $releaseDefId = (Get-VSTeamReleaseDefinition -ProjectName $newProjectName | Where-Object { $_.Name -eq $($newProjectName + "-CD1") }).Id
         $releaseDefId | Should -Not -Be $null
         $releaseDef = Get-VSTeamReleaseDefinition -ProjectName $newProjectName -Id $releaseDefId
         $releaseDef.Name | Should -Be $($newProjectName + "-CD1")
         $releaseDef.environments[0].deployPhases.Count | Should -Be 1
         $releaseDef.environments[0].deployPhases[0].Name | Should -Be "Phase 1"
         $releaseDef.environments[0].deployPhases[0].workflowTasks.Count | Should -Be 1
         $releaseDef.environments[0].deployPhases[0].workflowTasks[0].Name | Should -Be "PowerShell Script"
         $releaseDef.environments[0].deployPhases[0].workflowTasks[0].inputs.targetType | Should -Be "inline"
      }

      It 'Get-VSTeamReleaseDefinition by Id should return 2 phases for 2nd build definition' {
         $releaseDefId = (Get-VSTeamReleaseDefinition -ProjectName $newProjectName | Where-Object { $_.Name -eq $($newProjectName + "-CD2") }).Id
         ((Get-VSTeamReleaseDefinition -ProjectName $newProjectName -Id $releaseDefId).environments[0].deployPhases).Count | Should -Be 2
      }

      It 'Remove-VSTeamReleaseDefinition should delete build definition' {
         Get-VSTeamReleaseDefinition -ProjectName $newProjectName | Remove-VSTeamReleaseDefinition -ProjectName $newProjectName -Force
         Get-VSTeamReleaseDefinition -ProjectName $newProjectName | Should -Be $null
      }
   }

   Context 'WorkItem full exercise' {
      BeforeAll {
         # Everytime you run the test a new "$newProjectName" is generated.
         # This is fine if you are running all the tests but not if you just
         # want to run these. So if the newProjectName can't be found in the 
         # target system change newProjectName to equal the name of the project
         # found with the correct description.
         $newProjectName = Get-ProjectName

         # It is important for these tests that this returns a value.
         # This will allow the validator to run which was a source of
         # a bug we needed to fix. 
         Set-VSTeamDefaultProject  $newProjectName
      }

      AfterAll {
         Clear-VSTeamDefaultProject
      }

      It 'Add-VSTeamWorkItem' {
         $actual = Add-VSTeamWorkItem -ProjectName $newProjectName -Title "IntTestWorkItem" -WorkItemType "Product Backlog Item"

         $actual | Should -Not -Be $null
      }

      It 'Remove-VSTeamWorkItem' {
         $workItemId = Get-VSTeamWiql -Query "Select [System.Id] From WorkItems" -ProjectName $newProjectName | Select-Object -ExpandProperty WorkItemIds

         { Remove-VSTeamWorkItem -Force -Destroy -Id $workItemId } | Should -Not -Throw
      }
   }

   Context 'Pool full exercise' {
      It 'Get-VSTeamPool Should return agent pools' {
         $actual = Get-VSTeamPool

         # Test differently for TFS and VSTS
         if ($acct -like "http://*") {
            $actual.name | Should -Be 'Default'
         }
         else {
            $actual.Count | Should -Not -Be 0
         }
      }
   }

   Context 'Agent full exercise' {
      It 'Get-VSTeamAgent Should return agents' {
         if ($acct -like "http://*") {
            $pool = (Get-VSTeamPool)[0]
         }
         else {
            # Grabbing the first hosted pool on VSTS. Skipping index 0 which is
            # default and is empty on some accounts
            $pool = (Get-VSTeamPool)[1]
         }
         $actual = Get-VSTeamAgent -PoolId $pool.Id

         $actual | Should -Not -Be $null
      }
   }

   Context 'Queue full exercise' {
      BeforeAll {
         # Everytime you run the test a new "$newProjectName" is generated.
         # This is fine if you are running all the tests but not if you just
         # want to run these. So if the newProjectName can't be found in the 
         # target system change newProjectName to equal the name of the project
         # found with the correct description.
         $newProjectName = Get-ProjectName
      }

      It 'Get-VSTeamQueue Should return agent Queues' {
         $actual = Get-VSTeamQueue -ProjectName $newProjectName

         if ($acct -like "http://*") {
            $global:queueId = $actual.id
            $actual.name | Should -Be 'Default'
         }
         else {
            $global:queueId = $actual[0].id
            $actual.Count | Should -Not -Be 0
         }
      }

      It 'Get-VSTeamQueue By Id Should return agent Queue' {
         $actual = Get-VSTeamQueue -ProjectName $newProjectName -Id $global:queueId

         $actual | Should -Not -Be $null
      }
   }

   Context 'Get Service Endpoint types' {
      It 'Get-VSTeamServiceEndpointType' {
         Get-VSTeamServiceEndpointType | Should -Not -Be $null
      }
   }

   Context 'Get Work Item Types' -Tag "WorkItemType" {
      BeforeAll {
         # Everytime you run the test a new "$newProjectName" is generated.
         # This is fine if you are running all the tests but not if you just
         # want to run these. So if the newProjectName can't be found in the 
         # target system change newProjectName to equal the name of the project
         # found with the correct description.
         $newProjectName = Get-ProjectName
      }

      It 'Get-VSTeamWorkItemType' {
         Get-VSTeamWorkItemType -ProjectName $newProjectName | Should -Not -Be $null
      }

      It 'Get-VSTeamWorkItemType By Type' {
         Get-VSTeamWorkItemType -ProjectName $newProjectName -WorkItemType Bug | Should -Not -Be $null
      }
   }

   Context 'VSTeamVariableGroup' -Tag 'VariableGroup' -Skip:$skipVariableGroups {
      BeforeAll {
         # Everytime you run the test a new "$newProjectName" is generated.
         # This is fine if you are running all the tests but not if you just
         # want to run these. So if the newProjectName can't be found in the 
         # target system change newProjectName to equal the name of the project
         # found with the correct description.
         $newProjectName = Get-ProjectName
               
         $variableGroupName = "TestVariableGroup1"
         $variableGroupUpdatedName = "TestVariableGroup2"
      }

      It 'Add-VSTeamVariableGroup' {
         $parameters = @{
            ProjectName = $newProjectName
            Name        = $variableGroupName
            Description = "A test variable group"
            Variables   = @{
               key1 = @{
                  value = "value1"
               }
               key2 = @{
                  value    = "value2"
                  isSecret = $true
               }
            }
         }

         if ($api -ne 'TFS2017') {
            $parameters.Add("Type", "Vsts")
         }

         $newVariableGroup = Add-VSTeamVariableGroup @parameters
         $newVariableGroup | Should -Not -Be $null
      }

      It 'Get-VSTeamVariableGroup' {
         $existingVariableGroups = , (Get-VSTeamVariableGroup -ProjectName $newProjectName)
         $existingVariableGroups.Count | Should -BeGreaterThan 0

         $newVariableGroup = ($existingVariableGroups | Where-Object { $_.Name -eq $variableGroupName })
         $newVariableGroup | Should -Not -Be $null

         $existingVariableGroup = Get-VSTeamVariableGroup -ProjectName $newProjectName -Id $newVariableGroup.Id
         $existingVariableGroup | Should -Not -Be $null
      }

      It 'Update-VSTeamVariableGroup' {
         $newVariableGroup = (Get-VSTeamVariableGroup -ProjectName $newProjectName | Where-Object { $_.Name -eq $variableGroupName })
         $newVariableGroup | Should -Not -Be $null

         $parameters = @{
            ProjectName = $newProjectName
            Id          = $newVariableGroup.Id
            Name        = $variableGroupUpdatedName
            Description = "A test variable group update"
            Variables   = @{
               key3 = @{
                  value = "value3"
               }
            }
         }
         if ($api -ne 'TFS2017') {
            $parameters.Add("Type", "Vsts")
         }

         $updatedVariableGroup = Update-VSTeamVariableGroup @parameters
         $updatedVariableGroup | Should -Not -Be $null
      }

      It 'Remove-VSTeamVariableGroup' {
         $updatedVariableGroup = (Get-VSTeamVariableGroup -ProjectName $newProjectName | Where-Object { $_.Name -eq $variableGroupUpdatedName })
         $updatedVariableGroup | Should -Not -Be $null
         { Remove-VSTeamVariableGroup -ProjectName $newProjectName -Id $updatedVariableGroup.Id -Force } | Should -Not -Throw
      }
   }

   Context 'VSTeamPolicy' -Tag 'Policy' {
      BeforeAll {
         $newProjectName = Get-ProjectName

         $actualTypes = Get-VSTeamPolicyType -ProjectName $newProjectName
      }

      It 'Get-VSTeamPolicyType' {
         $actualTypes | Should -Not -Be $null
      }

      It 'Add-VSTeamPolicy' {
         $typeId = $($actualTypes | Where-Object displayName -eq 'Minimum number of reviewers' | Select-Object -ExpandProperty id)
         $repoId = $(Get-VSTeamGitRepository -ProjectName $newProjectName -Name $newProjectName | Select-Object -ExpandProperty Id)

         Add-VSTeamPolicy -ProjectName $newProjectName -type $typeId -enabled -blocking -settings @{MinimumApproverCount = 1; Scope = @(@{repositoryId = $repoId; matchKind = "Exact"; refName = "refs/heads/master" }) }

         Start-Sleep -Seconds 2

         $newPolicy = Get-VSTeamPolicy -ProjectName $newProjectName

         Start-Sleep -Seconds 2

         $newPolicy | Should -Not -Be $null
         $newPolicy.settings.minimumApproverCount | Should -Be 1
      }

      It 'Update-VSTeamPolicy' {
         $newPolicy = Get-VSTeamPolicy -ProjectName $newProjectName

         Start-Sleep -Seconds 2
         
         $typeId = $($actualTypes | Where-Object displayName -eq 'Minimum number of reviewers' | Select-Object -ExpandProperty id)
         $newPolicy = Update-VSTeamPolicy -id $newPolicy.Id -ProjectName $newProjectName -type $typeId -enabled -blocking `
            -settings @{MinimumApproverCount = 2; Scope = @(@{repositoryId = $repoId; matchKind = "Exact"; refName = "refs/heads/master" }) }

         $newPolicy.settings.minimumApproverCount | Should -Be 2
      }

      It 'Remove-VSTeamPolicy' {
         $newPolicy = Get-VSTeamPolicy -ProjectName $newProjectName
         
         Start-Sleep -Seconds 2

         Remove-VSTeamPolicy -id $newPolicy.Id -ProjectName $newProjectName
         
         # If you call Get-VSTeamPolicy too quickly it will return the item
         # we just deleted.
         Start-Sleep -Seconds 2

         Get-VSTeamPolicy -ProjectName $newProjectName | Should -Be $null
      }
   }

   Context 'Service Endpoints full exercise' {
      BeforeAll {
         $newProjectName = Get-ProjectName
      }
      It 'Add-VSTeamAzureRMServiceEndpoint Should add service endpoint' {
         { Add-VSTeamAzureRMServiceEndpoint -ProjectName $newProjectName -displayName 'AzureEndoint' `
               -subscriptionId '00000000-0000-0000-0000-000000000000' -subscriptionTenantId '00000000-0000-0000-0000-000000000000' `
               -servicePrincipalId '00000000-0000-0000-0000-000000000000' -servicePrincipalKey 'fakekey' } | Should -Not -Throw
      }

      It 'Get-VSTeamServiceEndpoint Should return service endpoints' {
         $actual = Get-VSTeamServiceEndpoint -ProjectName $newProjectName

         $actual | Should -Not -Be $null
      }

      It 'Remove-VSTeamServiceEndpoint Should delete service endpoints' {
         Get-VSTeamServiceEndpoint -ProjectName $newProjectName | Remove-VSTeamServiceEndpoint -ProjectName $newProjectName -Force

         Get-VSTeamServiceEndpoint -ProjectName $newProjectName | Should -Be $null
      }
   }

   Context 'Users exercise' -Skip:$skippedOnTFS {

      It 'Get-VSTeamUserEntitlement Should return all users' {
         Get-VSTeamUserEntitlement | Should -Not -Be $null
      }

      It 'Get-VSTeamUserEntitlement ById Should return Teams' {
         $id = (Get-VSTeamUserEntitlement | Where-Object email -eq $email).Id
         Get-VSTeamUserEntitlement -Id $id | Should -Not -Be $null
      }

      It 'Remove-VSTeamUserEntitlement should fail' {
         { Remove-VSTeamUserEntitlement -Email fake@NoteReal.foo -Force } | Should -Throw
      }

      It 'Remove-VSTeamUserEntitlement should delete the user' {
         Remove-VSTeamUserEntitlement -Email $email -Force
         Get-VSTeamUserEntitlement | Where-Object Email -eq $email | Should -Be $null
      }

      It 'Add-VSTeamUserEntitlement should add a user' {
         Add-VSTeamUserEntitlement -Email $email -License StakeHolder | Should -Not -Be $null
         (Get-VSTeamUserEntitlement).Count | Should -Be 3
      }

      It 'Remove-VSTeamUserEntitlement should delete the user' {
         Remove-VSTeamUserEntitlement -Email $email -Force
         Get-VSTeamUserEntitlement | Where-Object Email -eq $email | Should -Be $null
      }

      It 'Add-VSTeamUserEntitlement should add a user with MSDN license' {
         Add-VSTeamUserEntitlement -Email $email -License none -LicensingSource msdn -MSDNLicenseType professional | Should -Not -Be $null
         (Get-VSTeamUserEntitlement).Count | Should -Be 3
      }
   }

   Context 'Feed exercise' -Tag 'Feed' -Skip:$skippedOnTFS {
      BeforeAll {
         $FeedName = 'TeamModuleIntegration' + [guid]::NewGuid().toString().substring(0, 5)
      }

      It 'Add-VSTeamFeed should add a feed' {
         Add-VSTeamFeed -Name $FeedName | Should -Not -Be $null
      }

      It 'Get-VSTeamFeed Should return all feeds' {
         Get-VSTeamFeed | Should -Not -Be $null
      }

      It 'Get-VSTeamFeed ById Should return feed' {
         $FeedID = (Get-VSTeamFeed | Where-Object name -eq $FeedName).Id
         Get-VSTeamFeed -Id $FeedID | Should -Not -Be $null
      }

      It 'Remove-VSTeamFeed should fail' -Tag 'Remove-VSTeamFeed' {
         Mock Write-Warning
         { Remove-VSTeamFeed -Id '00000000-0000-0000-0000-000000000000' -Force } | Should -Throw
      }

      It 'Remove-VSTeamFeed should delete the feed' -Tag 'Remove-VSTeamFeed' {
         Get-VSTeamFeed | Remove-VSTeamFeed -Force
         Get-VSTeamFeed | Where-Object name -eq $FeedName | Should -Be $null
      }
   }

   Context 'Access control list' -Skip:$skippedOnTFS {
      It 'Get-VSTeamAccessControlList should return without error' {
         $(Get-VSTeamSecurityNamespace | Select-Object -First 1 | Get-VSTeamAccessControlList) | Should -Not -Be $null
      }

      It 'Get-VSTeamAccessControlList -IncludeExtendedInfo should return without error' {
         $(Get-VSTeamSecurityNamespace | Select-Object -First 1 | Get-VSTeamAccessControlList -IncludeExtendedInfo) | Should -Not -Be $null
      }
   }

   Context 'Teams full exercise' {
      BeforeAll {
         # Everytime you run the test a new "$newProjectName" is generated.
         # This is fine if you are running all the tests but not if you just
         # want to run these. So if the newProjectName can't be found in the 
         # target system change newProjectName to equal the name of the project
         # found with the correct description.
         $newProjectName = Get-ProjectName
            
         $global:id = (Get-VSTeam -ProjectName $newProjectName).Id
      }

      
      It 'Get-VSTeam ByName Should return Teams' {
         Get-VSTeam -ProjectName $newProjectName -Name "$newProjectName Team" | Should -Not -Be $null
      }

      It 'Get-VSTeam ById Should return Teams' {
         Get-VSTeam -ProjectName $newProjectName -Id $global:id | Should -Not -Be $null
      }

      It 'Get-VSTeamMembers Should return TeamMembers' {
         Get-VSTeamMember -ProjectName $newProjectName -TeamId $global:id | Should -Not -Be $null
      }

      It 'Add-VSTeam should add a team' {
         Add-VSTeam -ProjectName $newProjectName -Name 'testing' | Should -Not -Be $null
         (Get-VSTeam -ProjectName $newProjectName).Count | Should -Be 2
      }

      It 'Update-VSTeam should update a team' {
         Update-VSTeam -ProjectName $newProjectName -Name 'testing' -NewTeamName 'testing123'
         Get-VSTeam -ProjectName $newProjectName -Name 'testing123' | Should -Not -Be $null
      }

      It 'Remove-VSTeam should delete the team' {
         Remove-VSTeam -ProjectName $newProjectName -Name 'testing123' -Force
         Get-VSTeam -ProjectName $newProjectName | Where-Object { $_.Name -eq 'testing123' } | Should -Be $null
      }
   }

   Context 'Team full exercise' {
      BeforeAll {
         # Everytime you run the test a new "$newProjectName" is generated.
         # This is fine if you are running all the tests but not if you just
         # want to run these. So if the newProjectName can't be found in the 
         # target system change newProjectName to equal the name of the project
         # found with the correct description.
         $newProjectName = Get-ProjectName
      }

      It 'Set-VSTeamAPIVersion to TFS2018' {
         Set-VSTeamAPIVersion TFS2018

         $info = Get-VSTeamInfo

         $info.Version | Should -Be 'TFS2018'
      }

      It 'Set-VSTeamAPIVersion to TFS2017' {
         Set-VSTeamAPIVersion TFS2017

         $info = Get-VSTeamInfo

         $info.Version | Should -Be 'TFS2017'
      }

      It 'Clear-VSTeamDefaultProject should clear project' {
         Set-VSTeamDefaultProject -Project $newProjectName

         Clear-VSTeamDefaultProject

         $info = Get-VSTeamInfo

         $info.DefaultProject | Should -BeNullOrEmpty
      }
   }
}
