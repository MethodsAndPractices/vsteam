Set-StrictMode -Version Latest

Describe 'Set-VSTeamProcess' {
   BeforeAll {

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessTemplateCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"


      Mock Get-VSTeamProcess {
         $processes =  @(
            [PSCustomObject]@{Name = "Scrum";            url='http://bogus.none/1'; ID = "6b724908-ef14-45cf-84f8-768b5384da45"},
            [PSCustomObject]@{Name = "Basic";            url='http://bogus.none/2'; ID = "b8a3a935-7e91-48b8-a94c-606d37c3e9f2"},
            [PSCustomObject]@{Name = "CMMI";             url='http://bogus.none/3'; ID = "27450541-8e31-4150-9947-dc59f998fc01"},
            [PSCustomObject]@{Name = "Agile";            url='http://bogus.none/4'; ID = "adcc42ab-9882-485e-a3ed-7678f01f66bc"},
            [PSCustomObject]@{Name = "Scrum With Space"; url='http://bogus.none/5'; ID = "12345678-0000-0000-0000-000000000000"}
         )
         if ($name) {return $processes.where({$_.name -like $name})}
         else       {return $processes}  
      }
      Mock _getInstance      { return 'https://dev.azure.com/test' }
      Mock _getApiVersion    { return '1.0-unitTests' }
      Mock _callApi          {
            #Return a single process object. Any process will do. 
            return ([psCustomObject]@{
               typeId              = '6b724908-ef14-45cf-84f8-768b5384da45'
               name                = 'Scrum' 
               referenceName       = ''
               description         = 'This template is for teams who follow the Scrum framework.'
               parentProcessTypeId = '00000000-0000-0000-0000-000000000000' 
               isEnabled           = $True 
               isDefault           = $True
               customizationType   = 'system'
               })
      }
   }

   Context 'Enable / Disable, set as Default, Set Description' {

      It 'Calls set-as-default. ' {
         Set-VsteamProcess -ProcessTemplate "Scrum" -AsDefault -Force
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like     'http://bogus.none/1*'       -and
            $Body   -match    '"IsDefault":\s+true'        -and  
            $Body   -notmatch 'IsEnabled|Description|Name' -and
            $Method -eq       'Patch'
         }
      }
      It 'Calls Enabled and uses multiple processes. ' {
         Set-VsteamProcess -ProcessTemplate "Agile" -Enabled -Force

         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like  'http://bogus.none/4?api-version*' -and
            $Body   -match '"IsEnabled":\s+true'              -and
            $Body   -notmatch 'IsDefault|Description|Name'    -and 
            $Method -eq    'Patch'
         }
      }
      It 'Calls Disabled , Name and Description. ' {
         Set-VsteamProcess -ProcessTemplate "Scrum With Space" -Disabled -Description "Do Not Use" -NewName "Old Version of Scrum" -Force

         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Uri    -like  'http://bogus.none/5?api-version*' -and
            $Body   -match '"IsEnabled":\s+false'             -and
            $Body   -match '"name":\s+"Old Version of Scrum"' -and
            $Body   -match '"Description":\s+"Do Not Use"'
            $Method -eq    'Patch'
         }
      }

   }
}