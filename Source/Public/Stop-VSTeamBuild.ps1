function Stop-VSTeamBuild {
  [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
  param(
     [parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
     [Alias('BuildID')]
     [Int] $Id,

     [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
     [ProjectValidateAttribute()]
     [ArgumentCompleter([ProjectCompleter])]
     [string] $ProjectName
  )

  process {
     if ($pscmdlet.ShouldProcess($Id, "Stop-VSTeamBuild")) {
      
      try {
        $body = '{'

        $items = New-Object System.Collections.ArrayList

        if ($null -ne "`"status`": `"Cancelling`"") {
          $items.Add("`"status`": `"Cancelling`"") > $null
        }

        if ($null -ne $items -and $items.count -gt 0) {
          $body += ($items -join ", ")
        }

        $body += '}'

        # Call the REST API
        _callAPI -ProjectName $ProjectName -Area 'build' -Resource 'builds' -Id $Id `
           -Method Patch -ContentType 'application/json' -body $body -Version $(_getApiVersion Build) | Out-Null
      }

      catch {
        _handleException $_
      }
    }
  }
}