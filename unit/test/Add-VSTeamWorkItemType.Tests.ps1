Set-StrictMode -Version Latest

Describe 'Add-VSTeamWorkItemType' {
   BeforeAll {

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessTemplateCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamWorkItemTypeCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ColorCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ColorTransformToHexAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/IconCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/IconCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/IconTransformAttribute.ps1"
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

#      (_callAPI -area wit -resource workitemicons -noproject ).value.id 
      Mock _callApi -ParameterFilter {$resource -eq 'workitemicons' }  -MockWith {
            return [pscustomobject]@{'Value' = @(
                           [pscustomobject]@{'ID' = 'icon_airplane'}
                           [pscustomobject]@{'ID' = 'icon_asterisk'}
                           [pscustomobject]@{'ID' = 'icon_Book'}
                     ) }

         }
      Mock _callApi -ParameterFilter {$Method -eq 'Post'}          {
            return ([psCustomObject]@{name   = 'Dummy' })
      }

   }


   Context 'Create New work Item Type' {
      BeforeAll {
         [VSTeamProcessCache]::invalidate()
      }
      It 'Calls the API with the expected body. ' {
         Add-VSTeamWorkItemType -ProcessTemplate Scrum -WorkItemType NewWit -Description "New Work item Type" -Color Red  -Icon asterisk 
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like     'http://bogus.none/1/workitemtypes?api-version=*'  -and
            $Body   -match    '"name":\s+"NewWit"'                               -and  
            $Body   -match    '"color":\s+"ff0000"'                              -and
            $Body   -match    '"icon":\s+"icon_asterisk"'                        -and  
            $Body   -match    '"description":\s+"New Work item Type"'            -and  
            $Method -eq       'Post'
         }
      }

   }
}