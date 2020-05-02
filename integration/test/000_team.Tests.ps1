Set-StrictMode -Version Latest

##############################################################
#     THESE TEST ARE DESTRUCTIVE. USE AN EMPTY ACCOUNT.      #
##############################################################
# Before running these tests you must set the following      #
# Environment variables.                                     #
# $env:API_VERSION = TFS2017, TFS2018, AzD2019 or VSTS       #
#                    depending on the value used for ACCT    #
# $env:EMAIL = Email of user to remove and re-add to account #
# $env:ACCT = VSTS Account Name or full TFS URL including    #
#             collection                                     #
# $env:PAT = Personal Access token of ACCT                   #
##############################################################
#     THESE TEST ARE DESTRUCTIVE. USE AN EMPTY ACCOUNT.      #
##############################################################

Set-VSTeamAPIVersion -Target $env:API_VERSION

Describe 'Team' -Tag 'integration' {
   BeforeAll {
      $pat = $env:PAT
      $acct = $env:ACCT
      $api = $env:API_VERSION
      Set-VSTeamAccount -a $acct -pe $pat -version $api

      ##############################################################
      # THIS DELETES ALL EXISTING TEAM PROJECTS!!!!                #
      ##############################################################
      Get-VSTeamProject | Remove-VSTeamProject -Force
   }

   Context 'Get-VSTeamInfo' {
      # Set-VSTeamAccount is set in the Before All
      # so just set the default project here
      # Arrange
      Set-VSTeamDefaultProject -Project 'MyProject'

      # Act
      $info = Get-VSTeamInfo

      # Assert
      It 'should return account' {
         # The account for Server is formated different than for Services
         if ($acct -like "http://*") {
            $info.Account | Should Be $acct
         }
         else {
            $info.Account | Should Be "https://dev.azure.com/$($env:ACCT)"
         }
      }

      It 'should return default project' {
         $info.DefaultProject | Should Be "MyProject"
      }
   }

   Context 'Remove-VSTeamAccount run as normal user' {
      It 'should clear env at process level' {
         # Act
         Remove-VSTeamAccount

         # Assert
         $info = Get-VSTeamInfo

         $info.Account | Should Be ''
         $info.DefaultProject | Should Be $null
      }
   }
}