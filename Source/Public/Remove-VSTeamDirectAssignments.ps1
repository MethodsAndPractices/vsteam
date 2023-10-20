function Remove-VSTeamDirectAssignments {
   [CmdletBinding(SupportsShouldProcess)]
   param (
      [Parameter(Mandatory = $false)]
      [string[]] $UserIds = @('d0452e2f-da3d-61c8-93a7-ef669552f409', '74f96e3d-355c-66c6-9136-b400c79e1e54'),

      [switch] $Preview
   )

   process {

      $queryString = @{
         'api-version' = '5.0-preview.1'
         'ruleOption'  = $Preview ? '1' : '0'
         'select'      = 'grouprules'
      }

      $results = @()

      if ($Preview) {
         # No chunking for preview
         $body = $UserIds | ConvertTo-Json


         $response = Invoke-VSTeamRequest `
            -subDomain 'vsaex' `
            -area 'MEMInternal' `
            -resource 'RemoveExplicitAssignment' `
            -method 'POST' `
            -body $body `
            -QueryString $queryString


         $results += $response.value
      }
      else {
         # Chunk UserIds in groups of 20 for non-preview mode
         # Chunking is necessary to avoid timeouts during API requests
         $chunkSize = 20
         $chunks = [Math]::Ceiling($UserIds.Count / $chunkSize)

         for ($i = 0; $i -lt $chunks; $i++) {
            $start = $i * $chunkSize
            $end = $start + $chunkSize - 1
            $currentChunk = $UserIds[$start..$end]

            $body = $currentChunk | ConvertTo-Json

            if ($PSCmdlet.ShouldProcess('Remove Direct Assignments', "UserIds: $($UserIds -join ', ')")) {
               $response = Invoke-VSTeamRequest `
                  -subDomain 'vsaex' `
                  -area 'MEMInternal' `
                  -resource 'RemoveExplicitAssignment' `
                  -method 'POST' `
                  -body $body `
                  -QueryString $queryString
            }

            $results += $response.value
         }
      }

      return $results
   }

}
