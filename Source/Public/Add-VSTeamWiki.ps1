function Add-VSTeamWiki {
   [CmdletBinding(DefaultParameterSetName = 'projectWiki',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamWiki')]
   param(      
      [Parameter(Mandatory = $true)]
      [Alias('WikiName')]      
      [string] $Name, 
      
      [Parameter(Mandatory = $true, ParameterSetName = 'codeWiki')]      
      [string] $RepositoryId, 

      [Parameter(Mandatory = $true, ParameterSetName = 'codeWiki')]
      [string] $Branch, 

      [Parameter(Mandatory = $true, ParameterSetName = 'codeWiki')]
      [string] $MappedPath, 

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true )]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      # Create the body for a projectWiki type
      $body = [ordered]@{
         type = $PSCmdlet.ParameterSetName
         name = $Name
         projectId = (Get-VSTeamProject -Name $ProjectName).id
      }
      
      # if its a code wiki include additional properties
      if ($PSCmdlet.ParameterSetName -eq 'codeWiki'){
         $body+= [ordered]@{
            Version = @{
               Version = $Branch
            }
            repositoryId = $RepositoryId
            mappedPath = $MappedPath
         }
      }

      $commonArgs = [ordered]@{
         Method = 'POST'
         Area = 'wiki'
         Resource = 'wikis'
         Body = $($body | ConvertTo-Json -Depth 100 -compress)
         ContentType = 'application/json'
         Version = $(_getApiVersion Wiki)
      }
      
      $resp = _callAPI @commonArgs         
      Write-Output $resp
   }
}
