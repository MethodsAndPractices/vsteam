function Add-VSTeamProcess {
   [cmdletbinding(SupportsShouldProcess=$true)]
   param(
      [parameter(Mandatory = $true)]
      [Alias('Name')]
      [string] $ProcessName,

      [string] $Description,

      [string] $ReferenceName,

      [parameter(Mandatory = $true)]
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      $ParentProcess
   )

   $parentProcess = Get-VSTeamProcess -Name $ParentProcess
   if (-not $parentProcess) { Write-Warning "Couldn't turn '$ParentProcess' into a process GUID."; return   }
   #Create a new process
   $body          =  @{ 'parentProcessTypeId'  = $parentProcess.id
                        'name'                 = $ProcessName
   }
   if ($ReferenceName) {$body['referenceName'] = $ReferenceName}
   if ($Description)   {$body['description']   = $Description  }
   $url  = (_getInstance) + "/_apis/work/processes?api-version=" + (_getApiVersion ProcessDefinition)
   if ($PSCmdlet.ShouldProcess($ProcessName,'Create New Process')) {
      $resp = _callAPI -Url $url -method Post  -ContentType "application/json" -body (ConvertTo-Json  $body)

      if ($resp.psobject.Properties.name -contains 'typeid') {
         [VSTeamProcessCache]::processes +=  $resp.name
         [VSTeamProcessCache]::urls[$resp.name] =  _getInstance + "/_apis/work/processes/" + $resp.typeId
         $obj = [VSTeamProcess]::new($resp)
         return $obj
      }
      else {Write-Warning 'The server did not return an ID for a newly created process. '}
   }
}
