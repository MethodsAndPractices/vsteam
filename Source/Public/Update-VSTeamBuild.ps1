function Update-VSTeamBuild {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamBuild')]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [Int] $Id,

      [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [bool] $KeepForever,

      [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $BuildNumber,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update-VSTeamBuild")) {

         $body = '{'

         $items = New-Object System.Collections.ArrayList

         if ($null -ne $KeepForever) {
            $items.Add("`"keepForever`": $($KeepForever.ToString().ToLower())") > $null
         }

         if ($null -ne $buildNumber -and $buildNumber.Length -gt 0) {
            $items.Add("`"buildNumber`": `"$BuildNumber`"") > $null
         }

         if ($null -ne $items -and $items.count -gt 0) {
            $body += ($items -join ", ")
         }

         $body += '}'

         # Call the REST API
         _callAPI -Method PATCH -ProjectName $ProjectName `
            -Area build `
            -Resource builds `
            -Id $Id `
            -body $body `
            -Version $(_getApiVersion Build) | Out-Null
      }
   }
}
