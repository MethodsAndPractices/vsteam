function Get-VSTeamMembership {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "ByContainerId")]
      [string] $ContainerDescriptor,
      [Parameter(Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "ByMemberId")]
      [string] $MemberDescriptor
   )

   process {
      if ($MemberDescriptor) {
         return _callMembershipAPI -Id $MemberDescriptor -Method Get -Direction Up
      }
      else {
         return _callMembershipAPI -Id $ContainerDescriptor -Method Get -Direction Down
      }
   }
}
