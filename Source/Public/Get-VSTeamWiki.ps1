function Get-VSTeamWiki {
   [CmdletBinding(DefaultParameterSetName = 'ListAllProjects',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamWiki')]
   param(      
      [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
      [Alias('WikiName')]
      [Alias('WikiId')]
      [string] $Name,      
      
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true , ParameterSetName = 'ListSingleProject')]
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true , ParameterSetName = 'ById')]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      $commonArgs = @{         
         area        = 'wiki'
         resource    = 'wikis'
         projectName = $ProjectName
         version     = $(_getApiVersion Wiki)
      }

      if ($Name) { # Name was specified, do a GET request      
         $resp = _callAPI @commonArgs -id $Name         
         Write-Output $resp         
      }
      else { # Name not specified, do LIST
         $listurl = _buildRequestURI @commonArgs         
         # Call the REST API
         $resp = _callAPI -url $listurl
         $objs = @()
         foreach ($item in $resp.value) {         
            $objs += $item
         }
         Write-Output $objs
      }
   }
}
