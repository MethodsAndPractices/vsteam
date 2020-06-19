function Get-VSTeamUser {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [ValidateSet('msa', 'aad', 'svc', 'imp', 'vss')]
      [string[]] $SubjectTypes,

      [Parameter(ParameterSetName = 'ByUserDescriptor', Mandatory = $true)]
      [Alias('UserDescriptor')]
      [string] $Descriptor
   )

   process {
      # This will throw if this account does not support the graph API
      _supportsGraph

      if ($Descriptor) {
         # Call the REST API
         $resp = _callAPI -Area 'graph' -Resource 'users' -id $Descriptor `
            -Version $(_getApiVersion Graph) `
            -SubDomain 'vssps' -NoProject

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $user = [VSTeamUser]::new($resp)

         Write-Output $user
      }
      else {
         $queryString = @{ }
         if ($SubjectTypes -and $SubjectTypes.Length -gt 0) {
            $queryString.subjectTypes = $SubjectTypes -join ','
         }

         try {
            # Call the REST API
            $resp = _callAPI -Area 'graph' -id 'users' `
               -Version $(_getApiVersion Graph) `
               -QueryString $queryString `
               -SubDomain 'vssps' -NoProject

            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [VSTeamUser]::new($item)
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