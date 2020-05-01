Set-StrictMode -Version Latest

#region include
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamVersions.ps1"
. "$here/../../Source/Classes/VSTeamProjectCache.ps1"
. "$here/../../Source/Classes/ProjectValidateAttribute.ps1"
. "$here/../../Source/Private/common.ps1"
. "$here/../../Source/Private/callMembershipAPI.ps1"
. "$here/../../Source/Public/Get-VSTeamProject.ps1"
. "$here/../../Source/Public/$sut"
#endregion

Describe 'VSTeamMembership' {
   ## Arrange
   # You have to set the version or the api-version will not be added when [VSTeamVersions]::Graph = ''
   Mock _supportsGraph
   Mock _getApiVersion { return '1.0-unitTests' } -ParameterFilter { $Service -eq 'Graph' }

   # Set the account to use for testing. A normal user would do this
   # using the Set-VSTeamAccount function.
   Mock _getInstance { return 'https://dev.azure.com/test' }   

   Mock Invoke-RestMethod
   
   $UserDescriptor = 'aad.OTcyOTJkNzYtMjc3Yi03OTgxLWIzNDMtNTkzYmM3ODZkYjlj'
   $GroupDescriptor = 'vssgp.Uy0xLTktMTU1MTM3NDI0NS04NTYwMDk3MjYtNDE5MzQ0MjExNy0yMzkwNzU2MTEwLTI3NDAxNjE4MjEtMC0wLTAtMC0x'

   Context 'Get-VSTeamMembership' {      
      It "for member should get a container's members" {
         ## Act
         $null = Get-VSTeamMembership -MemberDescriptor $UserDescriptor
         
         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Get" -and
            $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/memberships/$MemberDescriptor*" -and
            $Uri -like "*api-version=$(_getApiVersion Graph)*"
         }
      }

      It "for Group should get a container's members" {
         ## Act
         $null = Get-VSTeamMembership -ContainerDescriptor $GroupDescriptor

         ## Assert
         Assert-MockCalled Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            $Method -eq "Get" -and
            $Uri -like "https://vssps.dev.azure.com/test/_apis/graph/memberships/$GroupDescriptor*" -and
            $Uri -like "*api-version=$(_getApiVersion Graph)*" -and
            $Uri -like "*direction=Down*"
         }
      }
   }
}