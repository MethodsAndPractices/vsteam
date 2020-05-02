Set-StrictMode -Version Latest

#region include
Import-Module SHiPS

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

. "$here/../../Source/Classes/VSTeamLeaf.ps1"
. "$here/../../Source/Classes/$sut"
#endregion

Describe "VSTeamAccessControlEntry" {
   Context 'Constructor' {
      $accessControlEntryResult = Get-Content "$PSScriptRoot\sampleFiles\accessControlEntryResult.json" -Raw | ConvertFrom-Json
      $securityNamespaceObject = [VSTeamAccessControlEntry]::new($accessControlEntryResult.value[0])
      
      It 'constructor should create VSTeamAccessControlEntry' {
         $securityNamespaceObject | Should Not Be $null
      }

      It 'ToString should return full description' {
         $securityNamespaceObject.ToString() | Should Be "Descriptor=Microsoft.TeamFoundation.Identity;S-1-9-1551374245-1204400969-2402986413-2179408616-0-0-0-0-1; Allow=8; Deny=0; ExtendedInfo=@{message=Hello World}"
      }
   }
}