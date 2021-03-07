# Adds a membership to a container.
#
# Get-VSTeamOption 'graph' 'memberships' -subDomain 'vssps'
# id              : 3fd2e6ca-fb30-443a-b579-95b19ed0934c
# area            : Graph
# resourceName    : Memberships
# routeTemplate   : _apis/{area}/{resource}/{subjectDescriptor}/{containerDescriptor}
# http://bit.ly/Add-VSTeamMembership

function Add-VSTeamMembership {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamMembership')]
   param(
      [Parameter(Mandatory = $true)]
      [string] $MemberDescriptor,

      [Parameter(Mandatory = $true)]
      [string] $ContainerDescriptor
   )

   process {
      return _callMembershipAPI -Method PUT `
         -Id "$MemberDescriptor/$ContainerDescriptor"
   }
}