Set-StrictMode -Version Latest

Describe 'VSTeamSecurityNamespace' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$baseFolder/Source/Public/Get-VSTeamSecurityNamespace.ps1"

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      # You have to set the version or the api-version will not be Removed when
      # versions = ''
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }
      Mock Get-VSTeamSecurityNamespace { Open-SampleFile 'Get-VSTeamSecurityNamespace.json' -Index 0 }

      $secNamespaceId = "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87"
      $testDescriptor = @("vssgp.Uy0xLTktMTU1MTM3NDI0NS0yMTkxNDc4NTk1LTU1MDM1MzIxOC0yNDM3MjM2NDgzLTQyMjkyNzUyNDktMC0wLTAtOC04")
   }

   Context 'Remove-VSTeamAccessControlEntry by SecurityNamespaceId' {
      It 'Should succeed with a properly formatted descriptor if descriptor is on ACL' {
         Mock _callAPI { return $true }

         Remove-VSTeamAccessControlEntry -SecurityNamespaceId $secNamespaceId `
            -Descriptor $testDescriptor `
            -Token xyz `
            -force | Should -Be "Removal of ACE from ACL succeeded."
      }

      It 'Should fail with a properly formatted descriptor if descriptor is not on ACL already' {
         Mock _callAPI { return $false }

         # The original implementation used -confirm:$false so I am leaving this test
         Remove-VSTeamAccessControlEntry -SecurityNamespaceId $secNamespaceId `
            -Descriptor $testDescriptor `
            -Token xyz `
            -confirm:$false `
            -ErrorVariable err `
            -ErrorAction SilentlyContinue

         $err.count | Should -Be 1
         $err[0].Exception.Message | Should -Be "Removal of ACE from ACL failed. Ensure descriptor and token are correct."
      }

      It 'Should fail with an improperly formatted descriptor' {
         Remove-VSTeamAccessControlEntry -SecurityNamespaceId $secNamespaceId `
            -Descriptor @("vssgp.NotARealDescriptor") `
            -Token xyz `
            -force `
            -ErrorVariable err `
            -ErrorAction SilentlyContinue

         $err.count | Should -Be 2
         $err[1].Exception.Message | Should -Be "Could not convert base64 string to string."
      }

      It 'Should fail if the REST API gives a non true/false response' {
         Mock _callAPI { return "Not a valid return" }

         Remove-VSTeamAccessControlEntry -SecurityNamespaceId $secNamespaceId `
            -Descriptor $testDescriptor `
            -Token xyz `
            -force `
            -ErrorVariable err `
            -ErrorAction SilentlyContinue

         $err.count | Should -Be 1
         $err[0].Exception.Message | Should -Be "Unexpected response from REST API."
      }
   }

   Context 'Remove-VSTeamAccessControlEntry by SecurityNamespace' {
      It 'Should succeed with a properly formatted descriptor if descriptor is on ACL' {
         Mock _callAPI { return $true }

         $securityNamespace = Get-VSTeamSecurityNamespace -Id "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87"

         Remove-VSTeamAccessControlEntry -SecurityNamespace $securityNamespace `
            -Descriptor $testDescriptor `
            -Token xyz `
            -force | Should -Be "Removal of ACE from ACL succeeded."
      }
      It 'Should fail with a properly formatted descriptor if descriptor is not on ACL already' {
         Mock _callAPI { return $false }

         $securityNamespace = Get-VSTeamSecurityNamespace -Id "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87"

         Remove-VSTeamAccessControlEntry -SecurityNamespace $securityNamespace `
            -Descriptor $testDescriptor `
            -Token xyz `
            -force `
            -ErrorVariable err `
            -ErrorAction SilentlyContinue

         $err.count | Should -Be 1
         $err[0].Exception.Message | Should -Be "Removal of ACE from ACL failed. Ensure descriptor and token are correct."
      }
      It 'Should fail with an improperly formatted descriptor' {
         $securityNamespace = Get-VSTeamSecurityNamespace -Id "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87"

         Remove-VSTeamAccessControlEntry -SecurityNamespace $securityNamespace `
            -Descriptor @("vssgp.NotARealDescriptor") `
            -Token xyz `
            -force `
            -ErrorVariable err `
            -ErrorAction SilentlyContinue

         $err.count | Should -Be 2
         $err[1].Exception.Message | Should -Be "Could not convert base64 string to string."
      }
      It 'Should fail if the REST API gives a non true/false response' {
         Mock _callAPI { return "Not a valid return" }

         Remove-VSTeamAccessControlEntry -SecurityNamespaceId $secNamespaceId `
            -Descriptor $testDescriptor `
            -Token xyz `
            -force `
            -ErrorVariable err `
            -ErrorAction SilentlyContinue

         $err.count | Should -Be 1
         $err[0].Exception.Message | Should -Be "Unexpected response from REST API."
      }
   }
}