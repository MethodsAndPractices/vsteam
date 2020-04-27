function Add-VSTeamRelease {
   [CmdletBinding(DefaultParameterSetName = 'ById', SupportsShouldProcess = $true, ConfirmImpact = "Medium")]
   param(
      [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
      [int] $DefinitionId,

      [Parameter(Mandatory = $false)]
      [string] $Description,

      [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
      [string] $ArtifactAlias,

      [Parameter()]
      [string] $Name,

      [Parameter(ParameterSetName = 'ById', Mandatory = $true)]
      [string] $BuildId,

      [ArgumentCompleter([BuildCompleter])]
      [Parameter(ParameterSetName = 'ByName', Mandatory = $true)]
      [string] $BuildNumber,

      [Parameter()]
      [string] $SourceBranch,

      [switch] $Force,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName,

      [ArgumentCompleter([ReleaseDefinitionCompleter])]
      [string] $DefinitionName
   )

   begin {
      if ($BuildNumber) {
         $buildID = (Get-VSTeamBuild -ProjectName $ProjectName -BuildNumber $BuildNumber).id
         if (-not $buildID) { throw "'$BuildnNumber' is not a valid build  Use Get-VsTeamBuild to get a list of valid build numbers." }
      }
    
      if ($DefinitionName -and -not $artifactAlias) {
         $def = Get-VSTeamReleaseDefinition -ProjectName $ProjectName | Where-Object { $_.name -eq $DefinitionName }
         $DefinitionId = $def.id
         $artifactAlias = $def.artifacts[0].alias
      }
   }

   process {
      $body = '{"definitionId": ' + $DefinitionId + ', "description": "' + $description + '", "artifacts": [{"alias": "' + $artifactAlias + '", "instanceReference": {"id": "' + $buildId + '", "name": "' + $Name + '", "sourceBranch": "' + $SourceBranch + '"}}]}'
      Write-Verbose $body
      
      # Call the REST API
      if ($force -or $pscmdlet.ShouldProcess($description, "Add Release")) {
         try {
            Write-Debug 'Add-VSTeamRelease Call the REST API'
            $resp = _callAPI -SubDomain 'vsrm' -ProjectName $ProjectName -Area 'release' -Resource 'releases' `
               -Method Post -ContentType 'application/json' -Body $body -Version $(_getApiVersion Release)
            
            _applyTypesToRelease $resp
            
            Write-Output $resp
         }
         catch {
            _handleException $_
         }
      }
   }
}
