Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemField' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamWorkItemType.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Unlock-VSTeamWorkItemType.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamField.ps1"

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' }
      [vsteam_lib.Versions]::Account='test'
      #Ensure that only the items returned from cache come from the mock
      [vsteam_lib.ProcessTemplateCache]::Invalidate()
      Mock Get-VSTeamProcess {
         $processes = @(
            [PSCustomObject]@{Name = 'Scrum';            url = 'http://bogus.none/1'; ID = '6b724908-ef14-45cf-84f8-768b5384da45' },
            [PSCustomObject]@{Name = 'Basic';            url = 'http://bogus.none/2'; ID = 'b8a3a935-7e91-48b8-a94c-606d37c3e9f2' },
            [PSCustomObject]@{Name = 'CMMI';             url = 'http://bogus.none/3'; ID = '27450541-8e31-4150-9947-dc59f998fc01' },
            [PSCustomObject]@{Name = 'Agile';            url = 'http://bogus.none/4'; ID = 'adcc42ab-9882-485e-a3ed-7678f01f66bc' },
            [PSCustomObject]@{Name = 'Scrum With Space'; url = 'http://bogus.none/5'; ID = '12345678-0000-0000-0000-000000000000' }
         )
         if ($name) { return $processes.where( { $_.name -like $name }) }
         else { return $processes }
      }

      Mock Get-VSTeamWorkItemType   {
         $wits = @(
            [psCustomObject]@{name          = 'Bug'
                              customization = 'system'
                              referenceName = 'Microsoft.VSTS.WorkItemTypes.Bug'
                              icon          = 'icon_insect'
                              color         = 'cc293d'
                              isDisabled    =  $false
                              description   = 'A divergence...'
                              url           = 'http://bogus.none/workItemTypes/98'
            }
            [psCustomObject]@{name          = 'Gub'
                                 customization = 'custom'
                                 icon          = 'icon_book'
                                 color         = 'ff0000'
                                 isDisabled    =  $false
                                 description   = 'Test Item'
                                 url           = 'http://bogus.none/workItemTypes/99';
               }
         )
         if ($WorkItemType) { return $wits.where( { $_.name -like $WorkItemType }) }
         else               { return $wits }
      }
      Mock Get-VSTeamField { return [PSCustomObject]@{Name = "Office";ReferenceName="Custom.Office"}
      }
      [vsteam_lib.FieldCache]::Invalidate()
      Mock _callApi { return ([pscustomobject]@{name='Bug';url = 'http://bogus.none/workItemTypes/98'})}

   }

   Context 'Get-VSTeamWorkItemField' {

      It 'should create an inherited type, add a field to it & return result with correct properties' {
         ## Act
        $wif = Add-VSTeamWorkItemField -WorkItemType bug -ProcessTemplate Scrum -ReferenceName Office -Force

         ## Assert
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -match '^http://bogus.none/workItemTypes\?api-version' -and
            $method -eq "Post" -and
            $body -match '"inheritsFrom":\s*"Microsoft\.VSTS\.WorkItemTypes\.Bug"'
         }
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -match '^http://bogus.none/workItemTypes/98/fields\?api-version' -and
            $body -match '"referenceName":\s*"Custom\.Office"'
         }
         $wif.count  | should -BeExactly 1
         $wif.psobject.TypeNames| should -contain 'vsteam_lib.WorkitemField'
         $wif.WorkItemType      | should -BeExactly 'Bug'
         $wif.ProcessTemplate   | should -BeExactly 'Scrum'
      }

      It 'should add the field directly to a custom item type & return result with correct properties' {
         ## Act
        $wif = Add-VSTeamWorkItemField -WorkItemType gub -ProcessTemplate Scrum -ReferenceName Office -Force

         ## Assert
         Should -Invoke _callApi -Scope It -ParameterFilter {
            $url -notmatch '^http://bogus.none/workItemTypes/99/fields\?api-version'
         } -Times 0 -Exactly
         Should -Invoke _callApi -Scope It  -ParameterFilter {
            $url  -match '^http://bogus.none/workItemTypes/99/fields\?api-version' -and
            $body -match '"referenceName":\s*"Custom\.Office"'
         } -Times 1 -Exactly
         $wif.count  | should -BeExactly 1
         $wif.psobject.TypeNames| should -contain 'vsteam_lib.WorkitemField'
         $wif.WorkItemType      | should -BeExactly 'Gub'
         $wif.ProcessTemplate   | should -BeExactly 'Scrum'
      }

   }
}