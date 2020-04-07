Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/callMembershipAPI.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamMembership' {
   ## Arrange
   # You have to set the version or the api-version will not be added when [VSTeamVersions]::Graph = ''
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Graph' }

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }   

   Mock Invoke-RestMethod
   Mock _supportsGraph
   
   $UserDescriptor = 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'
   $GroupDescriptor = 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'

   Context 'Add-VSTeamMembership' {
      It 'Should add membership' {
         ## Act
         $null = Add-VSTeamMembership -MemberDescriptor $UserDescriptor -ContainerDescriptor $GroupDescriptor

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Put" -and
            $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/memberships/$UserDescriptor/$GroupDescriptor*" -and
            $Uri -like "*api-version=$(_getApiVersion Graph)*"
         }
      }
   }
}