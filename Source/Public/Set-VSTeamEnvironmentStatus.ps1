function Set-VSTeamEnvironmentStatus {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Set-VSTeamEnvironmentStatus')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('Id')]
      [int[]] $EnvironmentId,

      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [int] $ReleaseId,

      [Parameter(Mandatory = $true, Position = 0)]
      [ValidateSet('canceled', 'inProgress', 'notStarted', 'partiallySucceeded', 'queued', 'rejected', 'scheduled', 'succeeded', 'undefined')]
      [Alias('EnvironmentStatus')]
      [string] $Status,

      [string] $Comment,

      [datetime] $ScheduledDeploymentTime,

      [switch] $Force,

      [Parameter(Position = 1, ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter]) ]
      [string] $ProjectName
   )

   process {
      $body = ConvertTo-Json ([PSCustomObject]@{status = $Status; comment = $Comment; scheduledDeploymentTime = $ScheduledDeploymentTime })

      foreach ($item in $EnvironmentId) {
         if ($force -or $pscmdlet.ShouldProcess($item, "Set Status on Environment")) {
            try {
               # Call the REST API
               _callAPI -Method PATCH -SubDomain vsrm -projectName $ProjectName `
                  -Area release `
                  -Resource releases `
                  -id "$ReleaseId/environments/$item" `
                  -body $body `
                  -Version $(_getApiVersion Release) | Out-Null

               Write-Output "Environment $item status changed to $status"
            }
            catch {
               _handleException $_
            }
         }
      }
   }
}
