function Invoke-VSTeamRequest {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Invoke-VSTeamRequest')]
   param(
      [ArgumentCompleter([vsteam_lib.InvokeCompleter])]
      [string] $Resource,

      [ArgumentCompleter([vsteam_lib.InvokeCompleter])]
      [string] $Area,

      [string] $Id,

      [string] $Version,

      [string] $SubDomain,

      [ValidateSet('Get', 'Post', 'Patch', 'Delete', 'Options', 'Put', 'Default', 'Head', 'Merge', 'Trace')]
      [string] $Method,

      [Parameter(ValueFromPipeline = $true)]
      [object] $Body,

      [string] $InFile,

      [string] $OutFile,

      [switch] $JSON,

      [string] $ContentType,

      [string] $Url,

      [hashtable] $AdditionalHeaders,

      [object] $QueryString,

      [string] $Team,

      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,

      [switch] $UseProjectId,

      [switch] $NoProject)

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
