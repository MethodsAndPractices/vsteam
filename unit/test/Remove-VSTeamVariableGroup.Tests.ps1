Set-StrictMode -Version Latest

Describe 'VSTeamVariableGroup' {
   BeforeAll {
      Add-Type -Path "$PSScriptRoot/../../dist/bin/vsteam-lib.dll"
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
   
      
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Set-VSTeamAPIVersion.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
   
      # Prime the project cache with an empty list. This will make sure
      # any project name used will pass validation and Get-VSTeamProject 
      # will not need to be called.
      [vsteam_lib.ProjectCache]::Update([string[]]@())
   }

   Context 'Remove-VSTeamVariableGroup' {
      Context 'Services' {
         BeforeAll {
            Mock _getApiVersion { return '5.0-preview.1' } -ParameterFilter { $Service -eq 'VariableGroups' }

            Mock _getInstance { return 'https://dev.azure.com/test' }

            BeforeAll {
               Set-VSTeamAPIVersion -Target VSTS
            }

            Mock Invoke-RestMethod
         }

         It 'should delete variable group' {
            $projectID = 1
            Remove-VSTeamVariableGroup -projectName project -Id $projectID -Force

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$(_getApiVersion VariableGroups)" -and
               $Method -eq 'Delete'
            }
         }
      }

      Context 'Server' {
         BeforeAll {
            Mock _getApiVersion { return '3.2-preview.1' } -ParameterFilter { $Service -eq 'VariableGroups' }

            Mock _getInstance { return 'http://localhost:8080/tfs/defaultcollection' } -Verifiable

            BeforeAll {
               Set-VSTeamAPIVersion -Target TFS2017
            }

            Mock Invoke-RestMethod
         }

         It 'should delete variable group' {
            $projectID = 1
            Remove-VSTeamVariableGroup -projectName project -id $projectID -Force

            Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
               $Uri -eq "http://localhost:8080/tfs/defaultcollection/project/_apis/distributedtask/variablegroups/$($projectID)?api-version=$(_getApiVersion VariableGroups)" -and
               $Method -eq 'Delete'
            }
         }
      }
   }
}