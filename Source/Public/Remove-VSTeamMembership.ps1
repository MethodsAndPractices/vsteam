function Remove-VSTeamMembership {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
   param(
      [Parameter(Mandatory = $true)]
      [string] $MemberDescriptor,
      [Parameter(Mandatory = $true)]
      [string] $ContainerDescriptor,
      [switch] $Force
   )

   process {
      if ($Force -or $PSCmdlet.ShouldProcess("$MemberDescriptor/$ContainerDescriptor", "Delete Membership")) {
         return _callMembershipAPI -Id "$MemberDescriptor/$ContainerDescriptor" -Method Delete
      }
   }
}
