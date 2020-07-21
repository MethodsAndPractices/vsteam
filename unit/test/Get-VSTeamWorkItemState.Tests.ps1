Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemState' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"        
      . "$PSScriptRoot/../../Source/Classes/ProcessTemplateCompleter.ps1"  
      . "$PSScriptRoot/../../Source/Classes/ProcessValidateAttribute.ps1"  
      . "$PSScriptRoot/../../Source/Classes/VSTeamWorkItemTypeCache.ps1"   
      . "$PSScriptRoot/../../Source/Classes/WorkItemTypeCompleter.ps1"     
      . "$PSScriptRoot/../../Source/Classes/WorkItemTypeValidateAttribute.ps1"  
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamWorkItemType.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProcess.ps1"

      . "$PSScriptRoot/../../Source/Public/$sut"
      
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance   { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Processes' }
   }

   Context 'Get-VSTeamWorkItemState' {
      BeforeAll {
         $bug = @{
            name          = "Bug"
            referenceName = "Microsoft.VSTS.WorkItemTypes.Bug"
            description   = "Describes a divergence between required and actual behavior, and tracks the work done to correct the defect and verify the correction."
            color         = "CC293D"
            states          = @( 
               [PSCustomObject]@{
                  id                 = "7b7e3e8c-e500-40b6-ad56-d59b8d64d757"
                  name               = "New"
                  color              = "b2b2b2"
                  stateCategory      = "Proposed"
                  order              = 1
                  url                = "https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/7b7e3e8c-e500-40b6-ad56-d59b8d64d757"
                  customizationType  = "system"
               },
               [PSCustomObject]@{
                  id                 = "02cca570-0896-4a30-aff1-87ccffc68ce0"
                  name               = "Approved"
                  color              = "b2b2b2"
                  stateCategory      = "Proposed"
                  order              = 2
                  url                = "https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/02cca570-0896-4a30-aff1-87ccffc68ce0"
                  customizationType  = "system"
               }
               [PSCustomObject]@{
                  id                 = "abb54c86-d03a-44fe-8216-309d3c712296"
                  name               = "Committed"
                  color              = "007acc"
                  stateCategory      = "InProgress"
                  order              = 3
                  url                = "https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/abb54c86-d03a-44fe-8216-309d3c712296"
                  customizationType  = "system"
               }
               [PSCustomObject]@{
                  id                 = "0c926c15-68f7-467f-96c9-a26a19e9d718"
                  name               = "Done"
                  color              = "339933"
                  stateCategory      = "Completed"
                  order              = 4
                  url                = "https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/0c926c15-68f7-467f-96c9-a26a19e9d718"
                  customizationType  = "system"
               }
               [PSCustomObject]@{
                  id                 = "0293a2ce-2a42-4d0e-bbbf-d2237efa0db8"
                  name               = "Removed"
                  color              = "ffffff"
                  stateCategory      = "Removed"
                  order              = 5
                  url                = "https://dummy.none/workItemTypes/Microsoft.VSTS.WorkItemTypes.Bug/states/0293a2ce-2a42-4d0e-bbbf-d2237efa0db8"
                  customizationType  = "system"
               }
            )
         }  
         Mock Get-VSTeamWorkItemType {return $bug }
         Mock Get-VSTeamProcess { return @(
              [PSCustomObject]@{
                  Name = "Scrum"
                  URL  = "https://dummy.none/_apis/work/processes/6b724908-ef14-45cf-84f8-768b5384da45"
               }
            )
         }

      }

      It 'should get states and add WorkItem type and ProcessTemplate to them' {
         ## Act
         $states = Get-VSTeamWorkItemState -WorkItemType bug -ProcessTemplate Scrum  

         ## Assert
         Should -Invoke Get-VSTeamWorkItemType -Scope It -ParameterFilter {$Expand -eq 'States'} -Times 1 -Exactly
         $states.count                 | Should -Be 5
         $states[0].psobject.Typenames | Should -Contain 'Team.Workitemstate'
         $states[0].ProcessTemplate    | Should -Be      'Scrum'
         $states[0].WorkItemType       | Should -Be      'Bug'
      }
   }
}