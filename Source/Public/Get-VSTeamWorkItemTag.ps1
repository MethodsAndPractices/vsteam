function Get-VSTeamWorkItemTag {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamWorkItemTag')]
   param (
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('TagName')]
      [Alias('TagId')]
      [string] $TagIdOrName,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $commonArgs = @{         
         area        = 'wit'
         resource    = 'tags'
         projectName = $ProjectName
         version     = $(_getApiVersion WorkItemTracking)
      }

      if ($TagIdOrName) { # TagIdOrName was specified, fetch a specific tag    
         $resp = _callAPI @commonArgs -id $TagIdOrName         
         Write-Output $resp         
      }
      else { # TagIdOrName not specified, list all tags
         $listurl = _buildRequestURI @commonArgs         
         $resp = _callAPI -url $listurl
         $objs = @()
         foreach ($item in $resp.value) {         
            $objs += $item
         }
         Write-Output $objs
      }
   }
}