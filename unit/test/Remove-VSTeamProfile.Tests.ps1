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
   ## Arrange
   $expectedPath = "$HOME/vsteam_profiles.json"
   
   Mock Set-Content { }
   Mock Get-VSTeamProfile { return '[{"Name":"test","URL":"https://dev.azure.com/test","Type":"Pat","Pat":"12345","Version":"VSTS"}]' | ConvertFrom-Json | ForEach-Object { $_ } }
   
   Context 'Remove-VSTeamProfile' {
      It 'should save remaining profiles to disk' {
         ## Act
         Remove-VSTeamProfile test

         ## Assert
         Assert-MockCalled Set-Content -Exactly -Times 1 -Scope It -ParameterFilter {
            $Path -eq $expectedPath -and ([string]$Value -eq '')
         }
      }

      It 'entry does not exist should save original profiles to disk' {
         ## Act
         Remove-VSTeamProfile demos

         ## Assert
         Assert-MockCalled Set-Content -Exactly -Times 1 -Scope It -ParameterFilter {
            $Path -eq $expectedPath -and $Value -like "*https://dev.azure.com/test*"
         }
      }
   }
}