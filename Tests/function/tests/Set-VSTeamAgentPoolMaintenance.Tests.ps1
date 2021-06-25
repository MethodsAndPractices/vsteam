Set-StrictMode -Version Latest

Describe 'VSTeamPool' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }

      $multipleResults = Open-SampleFile 'agentPoolMaintenanceMultipleResult.json'
      $singleResult = Open-SampleFile 'agentPoolMaintenanceSingleResult.json'

      $testParam = @{
         Id                               = 14
         JobTimeoutInMinutes              = 5
         MaxConcurrentAgentsPercentage    = 25
         NumberOfHistoryRecordsToKeep     = 6
         WorkingDirectoryExpirationInDays = 7
         StartHours                       = 3
         StartMinutes                     = 30
         WeekDaysToBuild                  = @("Monday"; "Friday")
         TimeZoneId                       = "UTC"
      }
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
         Set-VSTeamAgentPoolMaintenance @testParam

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

      it 'with enabled setting and more than 100% should throw' {
         ## Act
         $localParam = $testParam.Clone()
         $localParam.MaxConcurrentAgentsPercentage = 101
         { Set-VSTeamAgentPoolMaintenance @localParam } | `
            Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'MaxConcurrentAgentsPercentage'. The 101 argument is greater than the maximum allowed range of 100. Supply an argument that is less than or equal to 100 and then try the command again."
      }

      it 'with enabled setting and StartMinutes more than 59 should throw' {
         ## Act
         $localParam = $testParam.Clone()
         $localParam.StartMinutes = 60
         { Set-VSTeamAgentPoolMaintenance @localParam } | `
            Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'StartMinutes'. The 60 argument is greater than the maximum allowed range of 59. Supply an argument that is less than or equal to 59 and then try the command again."
      }

      it 'with enabled setting and StartHours more than 23 should throw' {
         ## Act
         $localParam = $testParam.Clone()
         $localParam.StartHours = 24
         { Set-VSTeamAgentPoolMaintenance @localParam} | `
            Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'StartHours'. The 24 argument is greater than the maximum allowed range of 23. Supply an argument that is less than or equal to 23 and then try the command again."
      }

      it 'with enabled setting and wrong time zone id should throw' {
         ## Act
         $localParam = $testParam.Clone()
         $localParam.TimeZoneId = "NoTimeZone"
         { Set-VSTeamAgentPoolMaintenance @localParam} | `
            Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'TimeZoneId'. 'NoTimeZone' is invalid"
      }

      it 'with enabled setting and wrong week days should throw' {
         ## Act
         $localParam = $testParam.Clone()
         $localParam.WeekDaysToBuild = @("Mo","Tue")
         { Set-VSTeamAgentPoolMaintenance @localParam } | Should -Throw
      }

   }

   Context 'Set-VSTeamAgentPoolMaintenance without existing Schedule' {
      BeforeAll {
         Mock Invoke-RestMethod {
            return @{ count = 0; value = @() } } -ParameterFilter { $Method -eq 'Get' }
         Mock Invoke-RestMethod {
            return $singleResult } -ParameterFilter { $Method -eq 'Post' }
      }

      it 'with disabled setting should throw' -Tag "Throws" {
         ## Act
         {
            Set-VSTeamAgentPoolMaintenance -Id 14 -Disable
         } | Should -Throw
      }

      it 'with enabled setting should be called' {
         ## Act
         Set-VSTeamAgentPoolMaintenance @testParam

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Get' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/14/maintenancedefinitions?api-version=$(_getApiVersion DistributedTask)"
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Post' -and
            $Body -like '*"enabled":true*' -and
            $Body -like '*"workingDirectoryExpirationInDays":7*' -and
            $Body -like '*"numberOfHistoryRecordsToKeep":6*' -and
            $Body -like '*"jobTimeoutInMinutes":5*' -and
            $Body -like '*"maxConcurrentAgentsPercentage":25*' -and
            $Body -like '*"timeZoneId":"UTC"*' -and
            $Body -like '*"startHours":3*' -and
            $Body -like '*"startMinutes":30*' -and
            $Body -like '*"daysToBuild":17*' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/14/maintenancedefinitions?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'with enabled setting and more than 100% should throw' {
         ## Act
         $localParam = $testParam.Clone()
         $localParam.MaxConcurrentAgentsPercentage = 101
         { Set-VSTeamAgentPoolMaintenance @localParam } | `
            Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'MaxConcurrentAgentsPercentage'. The 101 argument is greater than the maximum allowed range of 100. Supply an argument that is less than or equal to 100 and then try the command again."
      }

      it 'with enabled setting and StartMinutes more than 59 should throw' {
         ## Act
         $localParam = $testParam.Clone()
         $localParam.StartMinutes = 60
         { Set-VSTeamAgentPoolMaintenance @localParam } | `
            Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'StartMinutes'. The 60 argument is greater than the maximum allowed range of 59. Supply an argument that is less than or equal to 59 and then try the command again."
      }

      it 'with enabled setting and StartHours more than 23 should throw' {
         ## Act
         $localParam = $testParam.Clone()
         $localParam.StartHours = 24
         { Set-VSTeamAgentPoolMaintenance @localParam} | `
            Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'StartHours'. The 24 argument is greater than the maximum allowed range of 23. Supply an argument that is less than or equal to 23 and then try the command again."
      }

      it 'with enabled setting and wrong time zone id should throw' {
         ## Act
         $localParam = $testParam.Clone()
         $localParam.TimeZoneId = "NoTimeZone"
         { Set-VSTeamAgentPoolMaintenance @localParam} | `
            Should -Throw -ExpectedMessage "Cannot validate argument on parameter 'TimeZoneId'. 'NoTimeZone' is invalid"
      }

      it 'with enabled setting and wrong week days should throw' {
         ## Act
         $localParam = $testParam.Clone()
         $localParam.WeekDaysToBuild = @("Mo","Tue")
         { Set-VSTeamAgentPoolMaintenance @localParam } | Should -Throw
      }
   }
}