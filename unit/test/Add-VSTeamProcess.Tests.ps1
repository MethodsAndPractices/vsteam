Set-StrictMode -Version Latest

Describe 'Add-VSTeamProcess' {
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

   Context 'Create a new process template' {

      It 'Posts with basic parameters.' {
         Add-VsteamProcess -Parent "Scrum" -processName "Scrum2"
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like     'https://dev.azure.com/test/_apis/work/processes?api-version*'    -and
            $Body   -match    '"parentProcessTypeId":\s+"6b724908-ef14-45cf-84f8-768b5384da45"' -and  
            $Body   -match    '"name":\s+"Scrum2"'        -and
            $Body   -notmatch 'ReferenceName|Description' -and
            $Method -eq       'Post'
         }
      }
      It 'Uses more than one template and Posts with ref name and description.' {
         Add-VsteamProcess -Parent "Agile" -processName "Agile2" -referenceName "Custom.agile2" -Desc "Custom agile process"
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like  'https://dev.azure.com/test/_apis/work/processes?api-version*'  -and
            $Body   -match '"parentProcessTypeId":\s+"adcc42ab-9882-485e-a3ed-7678f01f66bc"' -and  
            $Body   -match '"name":\s+"Agile2"'                       -and
            $Body   -match '"ReferenceName":\s+"Custom\.agile2"'      -and 
            $Body   -match '"Description":\s+"Custom agile process"'  -and
            $Method -eq       'Post'
         }
      }

   }
}