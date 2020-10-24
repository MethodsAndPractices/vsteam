Set-StrictMode -Version Latest

Describe 'VSTeamField' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      . "$PSScriptRoot\..\..\..\Source\Public\Get-VSTeamField.ps1"

      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }
      Mock _getApiVersion { return '1.0-unitTests' }
      [vsteam_lib.Versions]::Account='test'
      #Ensure that only the items returned from cache come from the mock
      [vsteam_lib.ProcessTemplateCache]::Invalidate()

      [vsteam_lib.FieldCache]::Invalidate()
      Mock _callApi { return $null}
      Mock Get-VSTeamField { return [PSCustomObject]@{Name = "Office";ReferenceName="Custom.Office"}}
   }

   Context 'Remove-VSTeamField' {

      It 'Should call the correct API to remove a fieldt' {
         ## Act
        Remove-VSTeamField -ReferenceName "custom.Office" -force

         ## Assert
         Should -Invoke _callApi -Exactly -Scope It -Times 1 -ParameterFilter {
            $method   -eq "delete" -and
            $area     -eq "wit"    -and
            $resource -eq "fields" -and
            $id       -eq "Custom.Office"
         }
      }
   }
}