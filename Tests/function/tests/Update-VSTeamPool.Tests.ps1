Set-StrictMode -Version Latest

Describe 'VSTeamPool' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }

      $singleResult = Open-SampleFile 'poolSingleResult.json'

   }

   Context 'Update-VSTeamPool with parameters' {
      BeforeAll {
         Mock Invoke-RestMethod {
            return $singleResult } -ParameterFilter { $Method -eq 'Patch' }
         Mock Invoke-RestMethod {
            return $singleResult } -ParameterFilter { $Method -eq 'Put' }
      }

      it 'with all parameters should be called' {
         ## Act
         Update-VSTeamPool -Id $singleResult.Id -Name "TestPool" -Description "Test Description" -AutoProvision -NoAutoUpdates

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*"autoProvision":true*' -and
            $Body -like '*"autoUpdate":false*' -and
            $Body -like '*"name":"TestPool"*' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/$($singleResult.Id)?api-version=$(_getApiVersion DistributedTask)"
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Put' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/$($singleResult.Id)/poolmetadata?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'with all parameters without description should be called' {
         ## Act
         Update-VSTeamPool -Id $singleResult.Id -Name "TestPool" -AutoProvision -NoAutoUpdates

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*"autoProvision":true*' -and
            $Body -like '*"autoUpdate":false*' -and
            $Body -like '*"name":"TestPool"*' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/$($singleResult.Id)?api-version=$(_getApiVersion DistributedTask)"
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 0 -ParameterFilter {
            $Method -eq 'Put' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/$($singleResult.Id)/poolmetadata?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'with all parameters without description,NoAutoUpdates should be called' {
         ## Act
         Update-VSTeamPool -Id $singleResult.Id -Name "TestPool" -AutoProvision

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*"autoProvision":true*' -and
            $Body -like '*"autoUpdate":true*' -and
            $Body -like '*"name":"TestPool"*' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/$($singleResult.Id)?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'with all parameters without description,NoAutoUpdates,AutoProvision should be called' {
         ## Act
         Update-VSTeamPool -Id $singleResult.Id -Name "TestPool"

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*"autoProvision":false*' -and
            $Body -like '*"autoUpdate":true*' -and
            $Body -like '*"name":"TestPool"*' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/$($singleResult.Id)?api-version=$(_getApiVersion DistributedTask)"
         }
      }

      it 'with only Id should be called' {
         ## Act
         Update-VSTeamPool -Id $singleResult.Id

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 1 -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*"autoProvision":false*' -and
            $Body -like '*"autoUpdate":true*' -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/$($singleResult.Id)?api-version=$(_getApiVersion DistributedTask)"
         }
      }

   }
}