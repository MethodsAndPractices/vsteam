function Get-VSTeamGroup {
   [CmdletBinding(DefaultParameterSetName = 'List',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamGroup')]
   param(
      [Parameter(ParameterSetName = 'List')]
      [Parameter(ParameterSetName = 'ListByProjectName')]
      [ValidateSet('vssgp', 'aadgp')]
      [string[]] $SubjectTypes,

      [Parameter(ParameterSetName = 'List')]
      [string] $ScopeDescriptor,

      [Parameter(ParameterSetName = 'ByGroupDescriptor', Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
      [Alias('GroupDescriptor')]
      [Alias('containerDescriptor')]
      [string] $Descriptor,

      [Parameter(ParameterSetName = 'ListByProjectName', Mandatory = $true)]
      [vsteam_lib.ProjectValidateAttribute($true)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName
   )

   process {
      # This will throw if this account does not support the graph API
      _supportsGraph

      $commonArgs = @{
         subDomain = 'vssps'
         area      = 'graph'
         resource  = 'groups'
         noProject = $true
         version   = $(_getApiVersion Graph)
      }

      if ($Descriptor) {
         # Call the REST API
         $resp = _callAPI @commonArgs -id $Descriptor

         # Storing the object before you return it cleaned up the pipeline.
         # When I just write the object from the constructor each property
         # seemed to be written
         $group = [vsteam_lib.Group]::new($resp)

         Write-Output $group
      }
      else {
         if ($ProjectName) {
            $project = Get-VSTeamProject -Name $ProjectName
            $ScopeDescriptor = Get-VSTeamDescriptor -StorageKey $project.id | Select-Object -ExpandProperty Name
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
            $resp = _callAPI @commonArgs -QueryString $queryString

            $objs = @()

            foreach ($item in $resp.value) {
               $objs += [vsteam_lib.Group]::new($item)
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