# Adds a task group.
#
# Get-VSTeamOption 'distributedtask' 'taskgroups'
# id              : 6c08ffbf-dbf1-4f9a-94e5-a1cbd47005e7
# area            : distributedtask
# resourceName    : taskgroups
# routeTemplate   : {project}/_apis/{area}/{resource}/{taskGroupId}
# http://bit.ly/Add-VSTeamTaskGroup

function Add-VSTeamTaskGroup {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamTaskGroup')]
   param(
      [Parameter(ParameterSetName = 'ByFile', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $InFile,

      [Parameter(ParameterSetName = 'ByBody', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $Body,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $commonArgs = @{
         Method      = 'Post'
         Area        = 'distributedtask'
         Resource    = 'taskgroups'
         ProjectName = $ProjectName
         Version     = $(_getApiVersion TaskGroups)
      }

      if ($InFile) {
         $resp = _callAPI @commonArgs -InFile $InFile
      }
      else {
         $resp = _callAPI @commonArgs -Body $Body
      }

      return $resp
   }
}
