Set-StrictMode -Version Latest

Describe 'VSTeamAccessControlEntry' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      ## Arrange
      # Some of the functions return VSTeam classes so turn the PSCustomeObject
      # into the correct type.
      $securityNamespaceObject = [vsteam_lib.SecurityNamespace]::new($(Open-SampleFile 'securityNamespace.json' -Index 0))

      # Set the account to use for testing. A normal user would do this using the
      # Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '5.0-unitTests' } -ParameterFilter { $Service -eq 'Core' }

      # This is only called when you need to test that the function can handle an
      # exception. To make sure this mock is called make sure the descriptor in
      # the body of your call has the value of 'boom'.
      Mock Invoke-RestMethod { throw 'Error' }  -ParameterFilter { $Body -like "*`"descriptor`": `"boom`",*" }
      Mock Invoke-RestMethod { Open-SampleFile 'accessControlEntryResult.json' }
   }

   Context 'Add-VSTeamAccessControlEntry' -Tag 'Add' {
      It 'should return ACEs by SecurityNamespace (pipeline)' {
         ## Act
         $securityNamespaceObject | Add-VSTeamAccessControlEntry -Descriptor abc `
            -Token xyz `
            -AllowMask 12 `
            -DenyMask 15

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            # The write-host below is great for seeing how many ways the mock is called.
            # Write-Host "Assert Mock $Uri"
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"xyz`",*" -and
            $Body -like "*`"descriptor`": `"abc`",*" -and
            $Body -like "*`"allow`": 12,*" -and
            $Body -like "*`"deny`": 15,*" -and
            $Method -eq "Post"
         }
      }

      It 'should return ACEs by SecurityNamespaceId' {
         ## Act
         Add-VSTeamAccessControlEntry -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 `
            -Descriptor abc `
            -Token xyz `
            -AllowMask 12 `
            -DenyMask 15

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            # The write-host below is great for seeing how many ways the mock is called.
            # Write-Host "Assert Mock $Uri"
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/5a27515b-ccd7-42c9-84f1-54c998f03866*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"xyz`",*" -and
            $Body -like "*`"descriptor`": `"abc`",*" -and
            $Body -like "*`"allow`": 12,*" -and
            $Body -like "*`"deny`": 15,*" -and
            $Method -eq "Post"
         }
      }

      It 'should return ACEs by SecurityNamespace' {
         ## Act
         Add-VSTeamAccessControlEntry -SecurityNamespace $securityNamespaceObject `
            -Descriptor abc `
            -Token xyz `
            -AllowMask 12 `
            -DenyMask 15

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            # The write-host below is great for seeing how many ways the mock is called.
            # Write-Host "Assert Mock $Uri"
            $Uri -like "https://dev.azure.com/test/_apis/accesscontrolentries/58450c49-b02d-465a-ab12-59ae512d6531*" -and
            $Uri -like "*api-version=$(_getApiVersion Core)*" -and
            $Body -like "*`"token`": `"xyz`",*" -and
            $Body -like "*`"descriptor`": `"abc`",*" -and
            $Body -like "*`"allow`": 12,*" -and
            $Body -like "*`"deny`": 15,*" -and
            $Method -eq "Post"
         }
      }

      It 'by securityNamespaceId throws should throw' -Tag "Throws" {
         ## Act / Assert
         { Add-VSTeamAccessControlEntry -SecurityNamespaceId 5a27515b-ccd7-42c9-84f1-54c998f03866 `
               -Descriptor boom `
               -Token xyz `
               -AllowMask 12 `
               -DenyMask 15 } | Should -Throw
      }

      It 'by SecurityNamespace should throw' -Tag "Throws" {
         ## Act / Assert
         { Add-VSTeamAccessControlEntry -SecurityNamespace $securityNamespaceObject `
               -Descriptor boom `
               -Token xyz `
               -AllowMask 12 `
               -DenyMask 15 } | Should -Throw
      }
   }
}