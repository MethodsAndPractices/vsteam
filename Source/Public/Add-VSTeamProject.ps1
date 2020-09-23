# Adds a Team Project to your account.
#
# id              : 603fe2ac-9723-48b9-88ad-09305aa6c6e1
# area            : core
# resourceName    : projects
# routeTemplate   : _apis/{resource}/{*projectId}
# http://bit.ly/Add-VSTeamProject

function Add-VSTeamProject {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamProject')]
   param(
      [parameter(Mandatory = $true)]
      [Alias('Name')]
      [string] $ProjectName,

      [string] $Description,

      [switch] $TFVC,

      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      [string] $ProcessTemplate
   )

   process {
      if ($TFVC.IsPresent) {
         $srcCtrl = "Tfvc"
      }
      else {
         $srcCtrl = 'Git'
      }

      if ($ProcessTemplate) {
         Write-Verbose "Finding $ProcessTemplate id"
         $templateTypeId = (Get-VSTeamProcess -Name $ProcessTemplate).Id
      }
      else {
         # Default to Scrum Process Template
         $ProcessTemplate = 'Scrum'
         $templateTypeId = '6b724908-ef14-45cf-84f8-768b5384da45'
      }

      $body = @{
         name         = $ProjectName
         description  = $Description
         capabilities = @{
            versioncontrol  = @{
               sourceControlType = $srcCtrl
            }
            processTemplate = @{
               templateTypeId = $templateTypeId
            }
         }
      }

      try {
         # Call the REST API
         $resp = _callAPI -Method POST `
            -Resource "projects" `
            -Body ($body | ConvertTo-Json -Compress -Depth 100) `
            -Version $(_getApiVersion Core)

         _trackProjectProgress -resp $resp -title 'Creating team project' -msg "Name: $($ProjectName), Template: $($processTemplate), Src: $($srcCtrl)"

         # Invalidate any cache of projects.
         [vsteam_lib.ProjectCache]::Invalidate()
         Start-Sleep -Seconds 5

         return Get-VSTeamProject $ProjectName
      }
      catch {
         _handleException $_
      }
   }
}
