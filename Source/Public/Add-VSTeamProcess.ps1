function Add-VSTeamProcess {
   [cmdletbinding(SupportsShouldProcess=$true)]
   param(
      [parameter(Mandatory = $true)]
      [Alias('Name')]
      [string] $ProcessName,

      [string] $Description,

      [string] $ReferenceName,

      [parameter(Mandatory = $true)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ParentProcessName,

      [switch]$Force
   )

   $parentProcess = Get-VSTeamProcess -Name $ParentProcessName
   if (-not $parentProcess) { Write-Warning "Couldn't turn '$ParentProcessName' into a process GUID."; return   }

   $body          =  @{ 'parentProcessTypeId'  = $parentProcess.id
                        'name'                 = $ProcessName
   }
   if ($ReferenceName) {$body['referenceName'] = $ReferenceName}
   if ($Description)   {$body['description']   = $Description  }

   $commonArgs = @{
      Method      = "Post"
      NoProject   = $true
      Area        = 'work'
      Resource    = 'processes'
      Version     = _getApiVersion Processes
      Body        = ConvertTo-Json  $body
   }
   if ($Force -or $PSCmdlet.ShouldProcess($ProcessName,'Create New Process')) {
      # Call the REST API
      $resp = _callAPI @commonArgs

      if ($resp.psobject.Properties.name -notcontains 'typeid') {
         Write-Warning 'The server did not return an ID for a newly created process. '
      }
      else {
         [vsteam_lib.ProcessTemplateCache]::Invalidate()

         return [vsteam_lib.Process]::new($resp)
      }

   }
}
