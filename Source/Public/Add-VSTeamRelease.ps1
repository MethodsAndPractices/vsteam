# Queues a new release.
#
# Get-VSTeamOption 'release' 'releases' -subDomain 'vsrm'
# id              : a166fde7-27ad-408e-ba75-703c2cc9d500
# area            : Release
# resourceName    : releases
# routeTemplate   : {project}/_apis/{area}/{resource}/{releaseId}
# http://bit.ly/Add-VSTeamRelease

function Add-VSTeamRelease {
   [CmdletBinding(DefaultParameterSetName = 'ById', SupportsShouldProcess = $true, ConfirmImpact = "Medium",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamRelease')]
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

      [ArgumentCompleter([vsteam_lib.BuildCompleter])]
      [Parameter(ParameterSetName = 'ByName', Mandatory = $true)]
      [string] $BuildNumber,

      [Parameter()]
      [string] $SourceBranch,

      [switch] $Force,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,

      [ArgumentCompleter([vsteam_lib.ReleaseDefinitionCompleter])]
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
            $resp = _callAPI -Method POST -SubDomain "vsrm" -ProjectName $ProjectName `
               -Area "release" `
               -Resource "releases" `
               -Body $body `
               -Version $(_getApiVersion Release)

            Write-Output $([vsteam_lib.Release]::new($resp, $ProjectName))
         }
         catch {
            _handleException $_
         }
      }
   }
}
