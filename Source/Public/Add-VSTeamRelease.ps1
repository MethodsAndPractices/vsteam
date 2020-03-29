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

      [Parameter()]
      [string] $SourceBranch,

      # Forces the command without confirmation
      [switch] $Force
   )

   DynamicParam {
      $dp = _buildProjectNameDynamicParam

      # If they have not set the default project you can't find the
      # validateset so skip that check. However, we still need to give
      # the option to pass by name.
      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $defs = Get-VSTeamReleaseDefinition -ProjectName $Global:PSDefaultParameterValues["*:projectName"] -expand artifacts
         $arrSet = $defs.name
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of DefinitionName'
         $defs = $null
         $arrSet = $null
      }

      $ParameterName = 'DefinitionName'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByName' -Mandatory $true
      $dp.Add($ParameterName, $rp)

      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $builds = Get-VSTeamBuild -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $arrSet = $builds.name
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of BuildName'
         $builds = $null
         $arrSet = $null
      }

      $ParameterName = 'BuildNumber'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $arrSet -ParameterSetName 'ByName' -Mandatory $true
      $dp.Add($ParameterName, $rp)

      $dp
   }

   process {
      Write-Debug 'Add-VSTeamRelease Process'

      # Bind the parameter to a friendly variable
      $BuildNumber = $PSBoundParameters["BuildNumber"]
      $ProjectName = $PSBoundParameters["ProjectName"]
      $DefinitionName = $PSBoundParameters["DefinitionName"]

      #Write-Verbose $builds

      if ($builds -and -not $buildId) {
         $buildId = $builds | Where-Object {$_.name -eq $BuildNumber} | Select-Object -ExpandProperty id
      }

      if ($defs -and -not $artifactAlias) {
         $def = $defs | Where-Object {$_.name -eq $DefinitionName}
         $DefinitionId = $def | Select-Object -ExpandProperty id

         $artifactAlias = $def.artifacts[0].alias
      }

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