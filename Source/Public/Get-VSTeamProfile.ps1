function Get-VSTeamProfile {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamProfile')]
   param(
      # Name is an array so I can pass an array after -Name
      # I can also use pipe
      [parameter(Mandatory = $false, Position = 1, ValueFromPipelineByPropertyName = $true)]
      [string] $Name
   )

   process {
      if (Test-Path $profilesPath) {
         try {
            # We needed to add ForEach-Object to unroll and show the inner type
            $result = Get-Content $profilesPath | ConvertFrom-Json

            # convert old URL in profile to new URL
            if ($result) {
               $result | ForEach-Object {
                  if ($_.URL -match "(?<protocol>https?\://)?(?<account>[A-Z0-9][-A-Z0-9]*[A-Z0-9])(?<domain>\.visualstudio\.com)") {
                     $_.URL = "https://dev.azure.com/$($matches.account)"
                  }
               }
            }

            if ($Name) {
               $result = $result | Where-Object Name -eq $Name
            }

            if ($result) {
               $result | ForEach-Object {
                  # Setting the type lets me format it
                  $_.PSObject.TypeNames.Insert(0, 'vsteam_lib.Profile')

                  if ($_.PSObject.Properties.Match('Token').count -eq 0) {
                     # This is a profile that was created before the module supported
                     # bearer tokens. The rest of the module expects there to be a Token
                     # property.  Add one with a value of ''
                     $_ | Add-Member NoteProperty 'Token' ''
                  }

                  $_
               }
            }
         }
         catch {
            # Catch any error and fail to the return empty array below
            Write-Error "Error ready Profiles file. Use Add-VSTeamProfile to generate new file."
         }
      }
   }
}