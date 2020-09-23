# Queues a build.
#
# Get-VSTeamOption 'build' 'Builds'
# id              : 0cd358e1-9217-4d94-8269-1c1ee6f93dcf
# area            : Build
# resourceName    : Builds
# routeTemplate   : {project}/_apis/build/{resource}/{buildId}
# https://bit.ly/Add-VSTeamBuild

function Add-VSTeamBuild {
   [CmdletBinding(DefaultParameterSetName = 'ByName',
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamBuild')]
   param(
      [Parameter(ParameterSetName = 'ByID', ValueFromPipelineByPropertyName = $true)]
      [Int32] $BuildDefinitionId,

      [Parameter(Mandatory = $false)]
      [string] $SourceBranch,

      [Parameter(Mandatory = $false)]
      [hashtable] $BuildParameters,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,

      [ArgumentCompleter([vsteam_lib.QueueCompleter])]
      [string] $QueueName,

      [ArgumentCompleter([vsteam_lib.BuildDefinitionCompleter])]
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
         $id = (Get-VSTeamBuildDefinition -ProjectName "$ProjectName" -Filter $BuildDefinitionName).id
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

      $resp = _callAPI -Method POST -ProjectName $ProjectName `
         -Area "build" `
         -Resource "builds" `
         -Body ($body | ConvertTo-Json -Compress -Depth 100) `
         -Version $(_getApiVersion Build)

      $build = [vsteam_lib.Build]::new($resp, $ProjectName)

      Write-Output $build
   }
}
