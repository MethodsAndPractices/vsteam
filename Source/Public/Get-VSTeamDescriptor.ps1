function Get-VSTeamDescriptor {
   [CmdletBinding(DefaultParameterSetName = 'ByStorageKey',
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Get-VSTeamDescriptor')]
   param(
      [Parameter(ParameterSetName = 'ByStorageKey', Mandatory = $true, Position = 0)]
      [string] $StorageKey
   )

   process {
      # This will throw if this account does not support the graph API
      _supportsGraph

      # Call the REST API
      $resp = _callAPI -SubDomain vssps -NoProject `
         -Area graph `
         -Resource descriptors `
         -id $StorageKey `
         -Version $(_getApiVersion Graph)

      # Storing the object before you return it cleaned up the pipeline.
      # When I just write the object from the constructor each property
      # seemed to be written
      $descriptor = [vsteam_lib.Descriptor]::new($resp)

      Write-Output $descriptor
   }
}
