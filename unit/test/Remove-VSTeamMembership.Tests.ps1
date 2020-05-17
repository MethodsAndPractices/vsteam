Set-StrictMode -Version Latest

Describe 'VSTeamMembership' {
   BeforeAll {
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamVersions.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamProjectCache.ps1"
      . "$PSScriptRoot/../../Source/Classes/ProjectValidateAttribute.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Private/callMembershipAPI.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamProject.ps1"
      . "$PSScriptRoot/../../Source/Public/$sut"
      
      ## Arrange
      # You have to set the version or the api-version will not be added when [VSTeamVersions]::Graph = ''
      Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Graph' }
      Mock _supportsGraph

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com/test' }

      Mock Invoke-RestMethod

      $UserDescriptor = 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'
      $GroupDescriptor = 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'
   }

   Context 'Remove-VSTeamMembership' {
      It 'Should remove a membership' {
         ## Act
         $null = Remove-VSTeamMembership -MemberDescriptor $UserDescriptor -ContainerDescriptor $GroupDescriptor -Force

         ## Assert
         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Delete" -and
            $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/memberships/$UserDescriptor/$GroupDescriptor*" -and
            $Uri -like "*api-version=$(_getApiVersion Graph)*"
         }
      }
   }
}