Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemField' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamWorkItemType.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Unlock-VSTeamWorkItemType.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamField.ps1"

      ## Arrange
      # Set the account to use for testing.
      # A normal user would do this using the Set-VSTeamAccount function.
      [vsteam_lib.Versions]::Account = 'https://dev.azure.com/test'
      Mock _getApiVersion { return '1.0-unitTests' }

      # Prime the process cache with an empty list,
      # So any name will be validated without calling Get-VSTeamProcess
      [vsteam_lib.ProcessTemplateCache]::Update([string[]]@(), 120)

      Mock Get-VSTeamWorkItemType  {
         $wits = Open-SampleFile "BugAndChangeReqLayout.json"
            if ($WorkItemType) { return $wits.where( { $_.name -like $WorkItemType }) }
            else               { return $wits }
      }

      Mock Get-VSTeamField { return [PSCustomObject]@{Name = "Office";ReferenceName="Custom.Office"}
      }
      [vsteam_lib.FieldCache]::Invalidate()
      Mock _callApi { return ([pscustomobject]@{name='Bug';url = 'http://bogus.none/workItemTypes/999'})}

   }

   Context 'Get-VSTeamWorkItemField' {

      It 'should create an inherited type, add a field to it & return result with correct properties' {
         ## Act
        $wif = Add-VSTeamWorkItemField -WorkItemType bug -ProcessTemplate Scrum5 -ReferenceName Office -Force

         ## Assert
         #Should create the inherited type - mock for that gives the add call a bogus URL
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -match '^http.*workItemTypes\?api-version' -and
            $method -eq "Post" -and
            $body -match '"inheritsFrom":\s*"Microsoft\.VSTS\.WorkItemTypes\.Bug"'
         }
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -match '^http://bogus.none/workItemTypes/999/fields\?api-version' -and
            $body -match '"referenceName":\s*"Custom\.Office"'
         }
         $wif.count  | should -BeExactly 1
         $wif.psobject.TypeNames| should -contain 'vsteam_lib.WorkitemField'
         $wif.WorkItemType      | should -BeExactly 'Bug'
         $wif.ProcessTemplate   | should -BeExactly 'Scrum5'
      }

      It 'should add the field directly to a custom item type & return result with correct properties' {
         ## Act
        $wif = Add-VSTeamWorkItemField -WorkItemType Change* -ProcessTemplate Scrum5 -ReferenceName Office -Force

         ## Assert
         #No inherited types this time add uses the URL from the sample data.
         Should -Invoke _callApi -Scope It  -ParameterFilter {
            $method -match 'post' -and
            $url    -match '^http.*ChangeReq/fields\?api-version' -and
            $body   -match '"referenceName":\s*"Custom\.Office"'
         } -Times 1 -Exactly
         #should not make any other calls.
         Should -Invoke _callApi -Scope It -ParameterFilter {
            $url -notmatch '^http.*ChangeReq/fields\?api-version'
         } -Times 0 -Exactly
         $wif.count  | should -BeExactly 1
         $wif.psobject.TypeNames| should -contain 'vsteam_lib.WorkitemField'
         $wif.WorkItemType      | should -BeExactly 'ChangeReq'
         $wif.ProcessTemplate   | should -BeExactly 'Scrum5'
      }

   }
}