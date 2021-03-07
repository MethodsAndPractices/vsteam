function Get-VSTeamMembership {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamMembership')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "ByContainerId")]
      [string] $ContainerDescriptor,

      [Parameter(Mandatory = $true, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = "ByMemberId")]
      [string] $MemberDescriptor
   )

   process {
      if ($MemberDescriptor) {
         Write-Verbose 'Up with MemberDescriptor'

         Write-Output $(_callMembershipAPI -Id $MemberDescriptor -Direction Up)
      }
      else {
         Write-Verbose 'Down with ContainerDescriptor'

         Write-Output $(_callMembershipAPI -Id $ContainerDescriptor -Direction Down)
      }
   }
}
