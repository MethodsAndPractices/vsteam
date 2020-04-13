function Get-VSTeamGroup {
   [CmdletBinding(DefaultParameterSetName = 'List')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [Parameter(ParameterSetName = 'ListByProjectName')]
      [ValidateSet('vssgp', 'aadgp')]
      [string[]] $SubjectTypes,

      [Parameter(ParameterSetName = 'List')]
      [string] $ScopeDescriptor,

      [Parameter(ParameterSetName = 'ByGroupDescriptor', Mandatory = $true)]
      [Alias('GroupDescriptor')]
      [string] $Descriptor,

      [Parameter(ParameterSetName = 'ListByProjectName', Mandatory = $true)]
      [UncachedProjectValidateAttribute()]
      [ArgumentCompleter([UncachedProjectCompleter])]
      [string] $ProjectName
   )
   
   process {
      # This will throw if this account does not support the graph API
      _supportsGraph

      if ($Descriptor) {
         # Call the REST API
         $resp = _callAPI -NoProject -Area 'graph' -Resource 'groups' -id $Descriptor `
            -Version $(_getApiVersion Graph) `
            -SubDomain 'vssps'

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $group = [VSTeamGroup]::new($resp)

         Write-Output $group
      }
      else {
         if ($ProjectName) {
            $project = Get-VSTeamProject -Name $ProjectName
            $ScopeDescriptor = Get-VSTeamDescriptor -StorageKey $project.id | Select-Object -ExpandProperty Descriptor
         }

         $queryString = @{ }
         if ($ScopeDescriptor) {
            $queryString.scopeDescriptor = $ScopeDescriptor
         }

         if ($SubjectTypes -and $SubjectTypes.Length -gt 0) {
            $queryString.subjectTypes = $SubjectTypes -join ','
         }

         try {
            # Call the REST API
            $resp = _callAPI -NoProject -Area 'graph' -id 'groups' `
               -Version $(_getApiVersion Graph) `
               -QueryString $queryString `
               -SubDomain 'vssps'

            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [VSTeamGroup]::new($item)
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