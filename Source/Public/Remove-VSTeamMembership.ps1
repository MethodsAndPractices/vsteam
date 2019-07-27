function Remove-VSTeamMembership {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      [string] $MemberDescriptor,
      [Parameter(Mandatory = $true)]
      [string] $ContainerDescriptor
   )

   process {
      return _callMembershipAPI -Id "$MemberDescriptor/$ContainerDescriptor" -Method Delete
   }
}
