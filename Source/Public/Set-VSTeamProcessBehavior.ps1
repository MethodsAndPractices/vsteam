function Set-VSTeamProcessBehavior {
   [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
   param (
      [Parameter(ValueFromPipelineByPropertyName=$true,Position=1)]
      [vsteam_lib.ProcessTemplateValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.ProcessTemplateCompleter])]
      $ProcessTemplate = $env:TEAM_PROCESS,

      [Parameter(ValueFromPipelineByPropertyName=$true, Mandatory=$true,Position=0)]
      [string]
      $Name,

      [ArgumentCompleter([vsteam_lib.ColorCompleter])]
      [vsteam_lib.ColorTransformToHexAttribute()]
      [String]
      $Color,

      [string]
      $NewName,

      [switch]
      $Force

   )
   Process {
      
      if (-not $color -and -not $NewName) {Write-Warning "Nothing to do!"; return}
      else {
         $body = @{}
         if ($Color)   {$body['color']= $Color}
         if ($NewName) {$body['name'] = $NewName}
         else          {$body['name'] = $Name}
      }
      $behavior = Get-VSTeamProcessBehavior -ProcessTemplate $ProcessTemplate | 
                     Where-Object -Property name -eq $Name

      if (-not $behavior) {Write-Warning "'$Name' is not a process behavior in $ProcessTemplate" ; return}
      $Params= @{
         url         = $behavior.url + "?api-version=" + (_getApiVersion Processes) 
         method      = 'Put'
         body        = ConvertTo-Json $body
         ContentType = 'application/json'
      }
      if ($Force -or $PSCmdlet.ShouldProcess($ProcessTemplate,"Modify behavior named '$Name' to process")) {
         #Call the Rest API
         $resp = _callAPI @params 
         
         # Apply a Type Name so we can use custom format view and custom type extensions
         # and add the processTemplate name so it can become a parameter when the object is piped into other functions
         $resp.psobject.TypeNames.Insert(0,'vsteam_lib.Processbehavior')
         Add-Member -InputObject $resp -MemberType NoteProperty -Name ProcessTemplate -Value $ProcessTemplate

         return $resp 
      }
   }
}
