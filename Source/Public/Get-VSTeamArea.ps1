function Get-VSTeamArea {
   [CmdletBinding(DefaultParameterSetName = 'ByPath',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamArea')]
   param(
      [Parameter(Mandatory = $false, ParameterSetName = "ByPath")]
      [string] $Path,

      [Parameter(Mandatory = $false, ParameterSetName = "ByIds")]
      [int[]] $Id,

      [int] $Depth,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      if ($PSCmdlet.ParameterSetName -eq "ByPath") {
         $resp = Get-VSTeamClassificationNode -ProjectName $ProjectName `
            -StructureGroup "areas" `
            -Path $Path `
            -Depth $Depth
      }
      else {
         $resp = Get-VSTeamClassificationNode -ProjectName $ProjectName `
            -Depth $Depth `
            -Id $Id
      }

      Write-Output $resp
   }
}