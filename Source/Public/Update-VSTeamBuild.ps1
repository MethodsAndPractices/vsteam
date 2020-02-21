function Update-VSTeamBuild {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('BuildID')]
      [Int] $Id,

      [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [bool] $KeepForever,

      [parameter(ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
      [string] $BuildNumber,

      [switch] $Force
   )

   DynamicParam {
      _buildProjectNameDynamicParam
   }

   Process {
      $ProjectName = $PSBoundParameters["ProjectName"]

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
         _callAPI -ProjectName $ProjectName -Area 'build' -Resource 'builds' -Id $Id `
            -Method Patch -ContentType 'application/json' -body $body -Version $([VSTeamVersions]::Build) | Out-Null
      }
   }
}