Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/Get-VSTeamProfile.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamProfile' {
   $expectedPath = "$HOME/vsteam_profiles.json"

   Mock Get-Content { return '' }
   Mock Test-Path { return $true }
      
   Context 'Update-VSTeamProfile entry does not exist' {
      Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

      It 'Should throw' {
         { Update-VSTeamProfile -Name Testing -PersonalAccessToken 678910 } | Should -Throw
      }
   }

   Context 'Update-VSTeamProfile with PAT to empty file' {
      Mock Set-Content { }
      Mock Write-Warning -Verifiable
      Mock Get-VSTeamProfile { }

      Update-VSTeamProfile -name demos -PersonalAccessToken 12345

      It 'Should save profile to disk' {
         Assert-VerifiableMock
      }
   }

   Context 'Update-VSTeamProfile with securePersonalAccessToken' {
      Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*VSTS*" }
      Mock Set-Content { }
      Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

      $password = '678910' | ConvertTo-SecureString -AsPlainText -Force

      Update-VSTeamProfile -Name test -SecurePersonalAccessToken $password

      It 'Should update profile' {
         Assert-VerifiableMock
      }
   }

   Context 'Update-VSTeamProfile with PAT' {
      Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*VSTS*" }
      Mock Set-Content { }
      Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test/","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }

      Update-VSTeamProfile -Name test -PersonalAccessToken 678910

      It 'Should update profile' {
         Assert-VerifiableMock
      }
   }

   Context 'Update-VSTeamProfile with old URL' {
      Mock Test-Path { return $true }
      Mock Get-Content { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' }
      Mock Set-Content { } -Verifiable -ParameterFilter { $Path -eq $expectedPath -and $Value -like "*OjY3ODkxMA==*" -and $Value -like "*https://dev.azure.com/test*" -and $Value -like "*VSTS*" }
      Mock Set-Content { }

      Update-VSTeamProfile -Name test -PersonalAccessToken 678910

      It 'Should update profile with new URL' {
         Assert-VerifiableMock
      }
   }
}