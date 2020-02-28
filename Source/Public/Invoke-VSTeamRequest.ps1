function Invoke-VSTeamRequest {
   [CmdletBinding()]
   param(
      [string]$resource,
      [string]$area,
      [string]$id,
      [string]$version,
      [string]$subDomain,
      [ValidateSet('Get', 'Post', 'Patch', 'Delete', 'Options', 'Put', 'Default', 'Head', 'Merge', 'Trace')]
      [string]$method,
      [Parameter(ValueFromPipeline = $true)]
      [object]$body,
      [string]$InFile,
      [string]$OutFile,
      [switch]$JSON,
      [string]$ContentType,
      [string]$Url,
      [hashtable]$AdditionalHeaders,
      [object]$QueryString,
      [string]$Team,
      [Parameter( Position = 0 )]
      [ValidateProject()]
      [ArgumentCompleter([ProjectCompleter])]
      $ProjectName
   )
   process {
      $params = $PSBoundParameters

      # We have to remove any extra parameters not used by Invoke-RestMethod
      $params.Remove('JSON') | Out-Null

      $output = _callAPI @params

      if ($JSON.IsPresent) {
         $output | ConvertTo-Json -Depth 99
      }
      else {
         $output
      }
   }
}
