function Add-VSTeamBuild {
   [CmdletBinding(DefaultParameterSetName = 'ByName')]
   param(
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Int32] $BuildDefinitionId,

      [Parameter(Mandatory = $false)]
      [string] $SourceBranch,

      [Parameter(Mandatory = $false)]
      [hashtable] $BuildParameters,

      [ProjectValidateAttribute()]
      [ArgumentCompleter([ProjectCompleter])]
      [Parameter(Mandatory = $true, Position = 0, ValueFromPipelineByPropertyName = $true)]
      [string] $ProjectName,

      [ArgumentCompleter([TeamQueueCompleter])]
      [string] $QueueName,

      [ArgumentCompleter([BuildDefinitionCompleter])]
      [string] $BuildDefinitionName
   )
   begin {
      if ($BuildDefinitionId) {
         $body = @{
            definition = @{
               id = $BuildDefinitionId
            }
         }
      }
      elseif ($BuildDefinitionName) {
         # Find the BuildDefinition id from the name
         $id = (Get-VSTeamBuildDefinition -ProjectName "$ProjectName" -Filter $BuildDefinitionName  -Type All).id
         if (-not $id) {
            throw "'$BuildDefinitionName' is not a valid build definition. Use Get-VSTeamBuildDefinition to get a list of build names"
            return
         }
         $body = @{
            definition = @{
               id = $id
            }
         }
      }
      else {
         throw "'No build definition was given. Use Get-VSTeamBuildDefinition to get a list of builds"
         return 
      }
      
      if ($QueueName) {
         $queueId = (Get-VSTeamQueue -ProjectName "$ProjectName" -queueName "$QueueName").id
         if (-not $queueId) {
            throw "'$QueueName' is not a valid Queue. Use Get-VSTeamQueue to get a list of queues"
            return
         }
         else { 
            $body["queue"] = @{id = $queueId } 
         }
      }
   }

   process {
      if ($SourceBranch) {
         $body.Add('sourceBranch', $SourceBranch)
      }

      if ($BuildParameters) {
         $body.Add('parameters', ($BuildParameters | ConvertTo-Json -Compress))
      }
      
      # Call the REST API
      $resp = _callAPI -ProjectName $ProjectName -Area 'build' -Resource 'builds' `
         -Method Post -ContentType 'application/json' -Body ($body | ConvertTo-Json) `
         -Version $(_getApiVersion Build)

      _applyTypesToBuild -item $resp

      return $resp
   }
}
