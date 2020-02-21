function Add-VSTeamBuild {
   [CmdletBinding(DefaultParameterSetName = 'ByName')]
   param(
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Int32] $BuildDefinitionId,

      [Parameter(Mandatory = $false)]
      [string] $SourceBranch,

      [Parameter(Mandatory = $false)]
      [hashtable] $BuildParameters
   )
   DynamicParam {
      $dp = _buildProjectNameDynamicParam

      # If they have not set the default project you can't find the
      # validateset so skip that check. However, we still need to give
      # the option to pass a QueueName to use.
      $queues = $null
      $queueArrSet = $null

      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $queues = Get-VSTeamQueue -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $queueArrSet = $queues.name
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of QueueName'
      }

      $ParameterName = 'QueueName'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $queueArrSet
      $dp.Add($ParameterName, $rp)

      $buildDefs = $null
      $buildDefsArrSet = $null

      if ($Global:PSDefaultParameterValues["*:projectName"]) {
         $buildDefs = Get-VSTeamBuildDefinition -ProjectName $Global:PSDefaultParameterValues["*:projectName"]
         $buildDefsArrSet = $buildDefs.name
      }
      else {
         Write-Verbose 'Call Set-VSTeamDefaultProject for Tab Complete of BuildDefinition'
      }

      $ParameterName = 'BuildDefinitionName'
      $rp = _buildDynamicParam -ParameterName $ParameterName -arrSet $buildDefsArrSet -ParameterSetName 'ByName'
      $dp.Add($ParameterName, $rp)

      $dp
   }

   process {
      # Bind the parameter to a friendly variable
      $QueueName = $PSBoundParameters["QueueName"]
      $ProjectName = $PSBoundParameters["ProjectName"]
      $BuildDefinition = $PSBoundParameters["BuildDefinitionName"]

      if ($BuildDefinitionId) {
         $id = $BuildDefinitionId
      }
      else {
         # Find the BuildDefinition id from the name
         $id = Get-VSTeamBuildDefinition -ProjectName "$ProjectName" -Type All |
            Where-Object { $_.name -eq $BuildDefinition } |
            Select-Object -ExpandProperty id
      }

      $body = @{
         definition = @{
            id = $id
         };
      }

      if ($QueueName) {
         $queueId = Get-VSTeamQueue -ProjectName "$ProjectName" -queueName "$QueueName" |
            Select-Object -ExpandProperty Id

         $body.Add('queue', @{ id = $queueId })
      }

      if ($SourceBranch) {
         $body.Add('sourceBranch', $SourceBranch)
      }

      if ($BuildParameters) {
         $body.Add('parameters', ($BuildParameters | ConvertTo-Json -Compress))
      }

      # Call the REST API
      $resp = _callAPI -ProjectName $ProjectName -Area 'build' -Resource 'builds' `
         -Method Post -ContentType 'application/json' -Body ($body | ConvertTo-Json) `
         -Version $([VSTeamVersions]::Build)

      _applyTypesToBuild -item $resp

      return $resp
   }
}