function Get-VSTeamUser {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamUser')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('msa', 'aad', 'svc', 'imp', 'vss')]
      [string[]] $SubjectTypes,

      [Parameter(ParameterSetName = 'ByUserDescriptor', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('UserDescriptor')]
      [Alias('memberDescriptor')]
      [string] $Descriptor
   )

   process {
      # This will throw if this account does not support the graph API
      _supportsGraph

      $commonArgs = @{
         subDomain = 'vssps'
         area      = 'graph'
         resource  = 'users'
         noProject = $true
         version   = $(_getApiVersion Graph)
      }

      if ($Descriptor) {
         # Call the REST API
         $resp = _callAPI @commonArgs -id $Descriptor

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $user = [vsteam_lib.User]::new($resp)

         Write-Output $user
      }
      else {
         $queryString = @{ }
         if ($SubjectTypes -and $SubjectTypes.Length -gt 0) {
            $queryString.subjectTypes = $SubjectTypes -join ','
         }

         try {
            # Call the REST API
            $resp = _callAPI @commonArgs -QueryString $queryString

            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [vsteam_lib.User]::new($item)
            }

            Write-Output $objs
         }
         catch {
            # I catch because using -ErrorAction Stop on the Invoke-RestMethod
            # was still running the foreach after and reporting useless errors.
            # This casuses the first error to terminate this execution.
            _handleException $_
         }
      }
   }
}