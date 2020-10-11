function Get-VSTeamUserProfile {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High",
      HelpUri = 'https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamUserProfile')]
   param(
      [Parameter(Mandatory = $true, ParameterSetName = "Id")]
      [string] $Id,
      [Parameter(Mandatory = $true, ParameterSetName = "Me")]
      [switch] $MyProfile
   )

   process {

      try {

         if($MyProfile){
            $Id = 'me'
         }

         # Call the REST API
         $resp = _callAPI `
            -Method GET `
            -subDomain 'vssps' `
            -area 'profile' `
            -resource 'profiles' `
            -id $Id `
            -version $(_getApiVersion Core)

         Write-Output $resp
      }
      catch {
         _handleException $_
      }

   }
}
