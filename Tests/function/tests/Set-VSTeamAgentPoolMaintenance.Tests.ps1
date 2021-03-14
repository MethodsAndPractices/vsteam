Set-StrictMode -Version Latest

Describe 'VSTeamPool' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }

      $multipleResults = Open-SampleFile 'agentPoolMaintenanceMultipleResult.json'
      $singleResult = Open-SampleFile 'agentPoolMaintenanceSingleResult.json'

   }

   Context 'Set-VSTeamAgentPoolMaintenance with existing Schedule' {
      BeforeAll {
         Mock Invoke-RestMethod {
            return $multipleResults } -ParameterFilter { $Method -eq 'Get' }
         Mock Invoke-RestMethod {
            return $singleResult } -ParameterFilter { $Method -eq 'Put' }
      }

      it 'with disabled setting should be called' {
         ## Act
         Set-VSTeamAgentPoolMaintenance -Id 14 -Disable

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Get' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/14/maintenancedefinitions?api-version=$(_getApiVersion DistributedTask)"
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put' -and
            $Body -like '*"enabled":false*' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/14/maintenancedefinitions/4?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'with enabled setting should be called' {
         ## Act
         Set-VSTeamAgentPoolMaintenance `
               -Id 14 `
               -JobTimeoutInMinutes 5 `
               -MaxConcurrentAgentsPercentage 25`
               -NumberOfHistoryRecordsToKeep 6`
               -WorkingDirectoryExpirationInDays 7`
               -StartHours 3`
               -StartMinutes 30`
               -WeekDaysToBuild Monday,Friday `
               -TimeZoneId UTC

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Get' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/14/maintenancedefinitions?api-version=$(_getApiVersion DistributedTask)"
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put' -and
            $Body -like '*"enabled":true*' -and
            $Body -like '*"workingDirectoryExpirationInDays":7*' -and
            $Body -like '*"numberOfHistoryRecordsToKeep":6*' -and
            $Body -like '*"jobTimeoutInMinutes":5*' -and
            $Body -like '*"maxConcurrentAgentsPercentage":25*' -and
            $Body -like '*"timeZoneId":"UTC"*' -and
            $Body -like '*"startHours":3*' -and
            $Body -like '*"startMinutes":30*' -and
            $Body -like '*"daysToBuild":17*' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/14/maintenancedefinitions/4?api-version=$(_getApiVersion DistributedTask)"
         }
      }

   }

   Context 'Set-VSTeamAgentPoolMaintenance without Schedule' {
      BeforeAll {
         Mock Invoke-RestMethod {
            return { count = 0; value = @()} } -ParameterFilter { $Method -eq 'Get' }
         Mock Invoke-RestMethod {
            return $singleResult } -ParameterFilter { $Method -eq 'Post' }
      }

      it 'with all parameters should be called' {
         ## Act
         Set-VSTeamAgentPoolMaintenance -Name "TestPool" -Description "Test Description" -AutoProvision -AutoAuthorize -NoAutoUpdates

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*"System.AutoAuthorize":true*' -and
            $Body -like '*"autoProvision":true*' -and
            $Body -like '*"autoUpdate":false*' -and
            $Body -like '*"name":"TestPool"*' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools?api-version=$(_getApiVersion DistributedTask)"
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/$($singleResult.Id)/poolmetadata?api-version=$(_getApiVersion DistributedTask)"
         }
      }

   }
}