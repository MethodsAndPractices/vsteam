
function Set-VSTeamProcess {
   [CmdletBinding(DefaultParameterSetName='LeaveAlone',SupportsShouldProcess=$true,ConfirmImpact='High')]
   param (
      [parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true,Position=1)]
      [ProcessValidateAttribute()]
      [ArgumentCompleter([ProcessTemplateCompleter])]
      [Alias('Name')]
      $ProcessTemplate,

      [String]$Description,

      [String]$NewName,

      [parameter(ParameterSetName='Hide', Mandatory = $true)]
      [switch]$Disabled,

      [parameter(ParameterSetName='Show', Mandatory = $true)]
      [switch]$Enabled,

      [parameter(ParameterSetName='LeaveAlone')]
      [parameter(ParameterSetName='Show')]
      [switch]$AsDefault,

      [switch]$Force

   )
   process {
      if ($PSBoundParameters.Keys.count -lt 2 -or ($Force -and $PSBoundParameters.Keys.count -lt 2)) {
         Write-Warning "Nothing to do!" ; return
      }
      $body = @{}
      if ($Description) {$body['description'] = $Description}
      if ($NewName    ) {$body['name']        = $NewName}
      if ($Disabled   ) {$body['IsEnabled']   = $false}
      if ($Enabled    ) {$body['IsEnabled']   = $true}
      if ($AsDefault  ) {$body['IsDefault']   = $true}

      $url =  [VSTeamProcessCache]::GetURl($ProcessTemplate)
      if (-not $url) {Write-Warning "Could not find the Process for '$ProcessTemplate" ; return}
      else   { $url += "?api-version=" + (_getApiVersion ProcessDefinition)}

      if ($Force -or $PSCmdlet.ShouldProcess($ProcessTemplate,'Update Devops Process template')) {
         $resp = _callAPI -Url $url -method Patch -ContentType "application/json" -body (ConvertTo-Json $body)
         if ($resp.psobject.Properties.name -contains 'typeid') { [VSTeamProcess]::new($resp)      }
         else {Write-Warning 'The server did not return an ID for a modified created process. '}
      }
   }
}
