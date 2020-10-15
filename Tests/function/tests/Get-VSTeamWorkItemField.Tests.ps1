Set-StrictMode -Version Latest

Describe 'VSTeamWorkItemField' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamProcess.ps1"
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamWorkItemType.ps1"

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' }

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
                              url           = 'http://bogus.none/98'
            }
            [psCustomObject]@{name          = 'Gub'
                                 customization = 'custom'
                                 icon          = 'icon_book'
                                 color         = 'ff0000'
                                 isDisabled    =  $false
                                 description   = 'Test Item'
                                 url           = 'http://bogus.none/99';
               }
         )
         if ($WorkItemType) { return $wits.where( { $_.name -like $WorkItemType }) }
         else               { return $wits }
      }
      Mock _callApi { return ([pscustomobject]@{Value=@([pscustomobject]@{name='History'},[pscustomobject]@{name='State'})})}
   }

   Context 'Get-VSTeamWorkItemField' {

      It 'should call the correct API and add the correct properties to returned objects' {
         ## Act
        $wif = Get-VSTeamWorkItemField -WorkItemType bug -ProcessTemplate Scrum

         ## Assert
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $url -match '^http://bogus.none/98/fields\?api-version'
         }
         $wif.count | should -BeGreaterThan 1
         $wif[0].psobject.TypeNames| should -contain 'vsteam_lib.WorkitemField'
         $wif[0].WorkItemType      | should -BeExactly 'Bug'
         $wif[0].ProcessTemplate   | should -BeExactly 'Scrum'
      }
   }
}