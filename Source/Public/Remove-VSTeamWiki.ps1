function Remove-VSTeamWiki {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low",
      HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Remove-VSTeamWiki')]
   param(      
      [Parameter(Mandatory = $true, ParameterSetName = 'ByName')]
      [Alias('Name')]
      [string] $WikiName,

      [Parameter(Mandatory = $true, ParameterSetName = 'ById')]
      [Alias('Id')]
      [guid] $WikiId,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true , ParameterSetName = 'ByName')]
      [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true , ParameterSetName = 'ById')]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )
   process {
      
      if ($PsCmdlet.ParameterSetName -eq 'ById'){
         $WikiToDelete = Get-VSTeamWiki | Where-Object id -eq $WikiId
      } else{
         $WikiToDelete = Get-VSTeamWiki -ProjectName $ProjectName -Name $WikiName
      }

      if ($null -ne $WikiToDelete){
         if($WikiToDelete.type -eq 'codeWiki'){ # unpublish the Wiki            
            try {
               _callAPI -Method DELETE -Id $WikiToDelete.id -Area wiki -Resource wikis -Version $(_getApiVersion Wiki) 

               Write-Output "Unpublished Wiki $($WikiToDelete.id)"
            }
            catch {
               _handleException $_
            }

         }else{ # this is a project wiki, repo needs to be deleted
            Remove-VSTeamGitRepository -Id $WikiToDelete.id -Force
         }
      } else {
         throw 'Wiki not found in project provided'
      }
   }
}
