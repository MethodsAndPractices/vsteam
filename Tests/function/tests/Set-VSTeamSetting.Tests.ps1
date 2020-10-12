Set-StrictMode -Version Latest

Describe 'VSTeamSetting' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
      ## Arrange
      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance       { return 'https://dev.azure.com/test' }
      Mock _getApiVersion     { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Processes' }
      Mock _getDefaultProject { return "MockProject"}
   }

   Context 'set-VSTeamSetting' {
      BeforeAll {
         ## Arrange
         Mock _callAPi {}
      }

      It 'should get make the correct api call to get settings' {
         ## Act
         $settings = Set-VSTeamSetting -project "MockProject" -WorkingDays saturday -BugsBehavior asTasks

         ## Assert
         Should -Invoke _callapi -Scope It -ParameterFilter {
            $resource -eq "teamsettings" -and  $area -eq "work"} -Times 1 -Exactly

      }
   }
}