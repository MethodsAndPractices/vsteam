Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamProfile' {
   $contents = @"
      [
         {
            "Name": "http://localhost:8080/tfs/defaultcollection",
            "URL": "http://localhost:8080/tfs/defaultcollection",
            "Pat": "",
            "Type": "OnPremise",
            "Version": "TFS2017"
         },
         {
            "Name": "http://192.168.1.3:8080/tfs/defaultcollection",
            "URL": "http://192.168.1.3:8080/tfs/defaultcollection",
            "Pat": "OnE2cXpseHk0YXp3dHpz",
            "Type": "Pat",
            "Version": "TFS2017"
         },
         {
            "Name": "test",
            "URL": "https://dev.azure.com/test",
            "Pat": "OndrejR0ZHpwbDM3bXUycGt5c3hm",
            "Type": "Pat",
            "Version": "VSTS"
         }
      ]
"@

   Context 'Get-VSTeamProfile' {
      Mock Get-Content { return '' }
      Mock Test-Path { return $true }
      
      It 'empty profiles file should return 0 profiles' {
         $actual = Get-VSTeamProfile
         $actual | Should BeNullOrEmpty
      }
   }

   Context 'Get-VSTeamProfile invalid profiles file' {
      Mock Test-Path { return $true }
      Mock Write-Error { } -Verifiable
      Mock Get-Content { return 'Not Valid JSON. This might happen if someone touches the file.' }
      
      It 'invalid profiles file should return 0 profiles' {
         $actual = Get-VSTeamProfile
         $actual | Should BeNullOrEmpty
         Assert-VerifiableMock
      }
   }

   Context 'Get-VSTeamProfile no profiles' {
      Mock Test-Path { return $false }

      $actual = Get-VSTeamProfile

      It 'no profiles should return 0 profiles' {
         $actual | Should BeNullOrEmpty
      }
   }

   Context 'Get-VSTeamProfile by name' {
      Mock Test-Path { return $true }
      Mock Get-Content { return $contents }

      $actual = Get-VSTeamProfile test

      It 'by name should return 1 profile' {
         $actual.URL | Should be 'https://dev.azure.com/test'
      }

      It 'by name profile Should by Pat' {
         $actual.Type | Should be 'Pat'
      }

      It 'by name token Should be empty string' {
         # This is testing that the Token property is added
         # to existing profiles loaded from file created before
         # the bearer token support was added.
         $actual.Token | Should be ''
      }
   }

   Context 'Get-VSTeamProfile' {
      Mock Test-Path { return $true }
      Mock Get-Content { return $contents }

      $actual = Get-VSTeamProfile

      It 'Should return 3 profiles' {
         $actual.Length | Should be 3
      }

      It '1st profile Should by OnPremise' {
         $actual[0].Type | Should be 'OnPremise'
      }
   }

   Context 'Get-VSTeamProfile with old URL' {
      Mock Test-Path { return $true }
      Mock Get-Content { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' }

      $actual = Get-VSTeamProfile

      It 'Should return new URL' {
         $actual.URL | Should Be "https://dev.azure.com/test"
      }
   }

   Context 'Get-VSTeamProfile with old URL and multiple entries' {
      Mock Test-Path { return $true }
      Mock Get-Content { return '[{"Name":"test","URL":"https://test.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"},{"Name":"demo","URL":"https://demo.visualstudio.com","Type":"Pat","Pat":"12345","Version":"VSTS"}]' }

      $actual = Get-VSTeamProfile -Name "test"

      It 'Should return new URL' {
         $actual.URL | Should Be "https://dev.azure.com/test"
      }
   }
}