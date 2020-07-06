Set-StrictMode -Version Latest

Describe 'Set-VSTeamWorkItemType' {
   BeforeAll {

      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")

      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProcessCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessTemplateCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProcessValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamWorkItemTypeCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/WorkItemTypeCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ColorCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/ColorTransformToHexAttribute.ps1"
      . "$PSScriptRoot/../../Source/Classes/IconCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/IconCompleter.ps1"
      . "$PSScriptRoot/../../Source/Classes/IconTransformAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProcess.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamWorkItemType.ps1"
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
                           [pscustomobject]@{'ID' = 'icon_book'}
                     ) }

         }
      Mock _callApi -ParameterFilter {$Method -eq 'Post' -or $Method -eq 'Patch'}          {
            return ([psCustomObject]@{name   = 'Dummy' })
      }
      Mock Get-VSTeamWorkItemType   {
            return @(
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
      } 
   }
   Context 'Update WorkItem Types' {

      It 'Catches invalid WorkItem Type names.' {
         Set-VSTeamWorkItemType -ProcessTemplate "Scrum With Space" -WorkItemType NewWit -Description "New Work item Type" -Color ff0000  -Icon icon_asterisk  -WarningVariable "Warn" -warningAction SilentlyContinue
         # Should not call the rest API from the function body, but may populate the work-item icons cache 
         Should -Invoke _callApi -Exactly -Times 0 -Scope It {-not ($resource -eq "workitemicons")} 
         $warn | Should -Be "'NewWit' does not appear to be a valid Workitem type."
      }
      It 'Patches custom WorkItem Types.' {
         Set-VSTeamWorkItemType -ProcessTemplate "Scrum With Space" -WorkItemType Gub -Description 'New Text' -Color Green  -Icon icon_book  -Force
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like     '*99?api-version=*'           -and  #found expected item
            $Body   -match    '"isDisabled":\s+false'       -and  #Should expressly set   
            $Body   -match    '"color":\s+"008000"'         -and  #Should convert from green
            $Body   -match    '"icon":\s+"icon_book"'       -and  
            $Body   -match    '"description":\s+"New Text'  -and  
            $Method -eq       'Patch'
         }
      }
       It 'Posts changes for system WorkItem Types' {
         Set-VSTeamWorkItemType -ProcessTemplate "Scrum With Space" -WorkItemType Bug -Disabled -Force
         Should -Invoke _callApi -Exactly -Times 1 -Scope It -ParameterFilter {
            $Url    -like     '*98?api-version=*'           -and  #found expected item
            $Body   -match    '"isDisabled":\s+true'        -and   
            $Body   -match    '"inheritsFrom":\s+"Microsoft.VSTS.WorkItemTypes.Bug"' -and  
            $Method -eq       'Post'
         }
      }
   }
}
