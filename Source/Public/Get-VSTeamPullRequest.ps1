function Get-VSTeamPullRequest {
   [CmdletBinding()]
   param (
       [Alias('PullRequestId')]
       [string] $Id
   )

   DynamicParam {
       _buildProjectNameDynamicParam -mandatory $false
   }

   Process {
       # Bind the parameter to a friendly variable
       $ProjectName = $PSBoundParameters["ProjectName"]

       try {
           if ($ProjectName) {
               $resp = _callAPI -ProjectName $ProjectName -Area git -Resource pullRequests -Version $([VSTeamVersions]::Git) -Id $Id
           }
           else {
               $resp = _callAPI -Area git -Resource pullRequests -Version $([VSTeamVersions]::Git) -Id $Id
           }

           if ($resp.PSobject.Properties.Name -contains "value") {
               $pullRequests = $resp.value
           }
           else {
               $pullRequests = $resp
           }

           foreach ($respItem in $pullRequests) {
               _applyTypesToPullRequests -item $respItem
           }

           Write-Output $pullRequests
       }
       catch {
           _handleException $_
       }
   }
}