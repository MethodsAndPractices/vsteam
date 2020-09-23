Set-StrictMode -Version Latest

Describe 'VSTeamNuGetEndpoint' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Add-VSTeamServiceEndpoint.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamServiceEndpoint.ps1"
   }
   
   Context 'Add-VSTeamNuGetEndpoint' {
      BeforeAll {
         Mock _getInstance { return 'https://dev.azure.com/test' }

         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'DistributedTask' }
         Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'ServiceEndpoints' }

         Mock Write-Progress
         Mock Invoke-RestMethod { _trackProcess }
         Mock Invoke-RestMethod { return @{id = '23233-2342' } } -ParameterFilter { $Method -eq 'Post' }
      }

      It 'with ApiKey should create a new NuGet Serviceendpoint' {
         Add-VSTeamNuGetEndpoint -ProjectName 'project' `
            -EndpointName 'PowerShell Gallery' `
            -NuGetUrl 'https://www.powershellgallery.com/api/v2/package' `
            -ApiKey '00000000-0000-0000-0000-000000000000'
         
         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/serviceendpoints?api-version=$(_getApiVersion DistributedTask)" -and
            $Method -eq 'POST' -and
            $Body -like '*"nugetkey": *"00000000-0000-0000-0000-000000000000"*' -and
            $Body -like '*"scheme": *"None"*'
         }
      }

      It 'with Username and Password should create a new NuGet Serviceendpoint' {
         $password = '00000000-0000-0000-0000-000000000000' | ConvertTo-SecureString -AsPlainText -Force
         Add-VSTeamNuGetEndpoint -ProjectName 'project' `
            -EndpointName 'PowerShell Gallery' `
            -NuGetUrl 'https://www.powershellgallery.com/api/v2/package' `
            -Username 'testUser' `
            -SecurePassword $password

         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/serviceendpoints?api-version=$(_getApiVersion DistributedTask)" -and
            $Method -eq 'POST' -and
            $Body -like '*"username": *"testUser"*' -and
            $Body -like '*"password": *"00000000-0000-0000-0000-000000000000"*' -and
            $Body -like '*"scheme": *"UsernamePassword"*'
         }
      }

      It 'with Token should create a new NuGet Serviceendpoint' {
         Add-VSTeamNuGetEndpoint -ProjectName 'project' `
            -EndpointName 'PowerShell Gallery' `
            -NuGetUrl 'https://www.powershellgallery.com/api/v2/package' `
            -PersonalAccessToken '00000000-0000-0000-0000-000000000000'
            
         Should -Invoke Invoke-RestMethod -Exactly -Scope Context -Times 1 -ParameterFilter {
            $Uri -eq "https://dev.azure.com/test/project/_apis/distributedtask/serviceendpoints?api-version=$(_getApiVersion DistributedTask)" -and
            $Method -eq 'POST' -and
            $Body -like '*"apitoken":*"00000000-0000-0000-0000-000000000000"*' -and
            $Body -like '*"scheme":*"Token"*'
         }
      }
   }
}
