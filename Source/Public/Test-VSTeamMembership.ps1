function Test-VSTeamMembership {
   [CmdletBinding()]
   [OutputType([System.Boolean])]
   param(
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = "MemberDescriptor")]
      [string] $MemberDescriptor,
      [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = "ContainerDescriptor")]
      [string] $ContainerDescriptor
   )

   process {
      $PrevWarningPreference = $WarningPreference
      try {
         $WarningPreference = "SilentlyContinue" # avoid 404 warning, since that indicates it doesn't exist
         $null = _callMembershipAPI -Id "$MemberDescriptor/$ContainerDescriptor" -Method Head
         return $true
      } catch {
         $WarningPreference = $PrevWarningPreference
         $e = $_
         try {
            if ($e.Exception -and $e.Exception.Response -and $e.Exception.Response.StatusCode -eq [System.Net.HttpStatusCode]::NotFound)
            {
               return $false
            }
         } catch {
            Write-Warning "Nested exception $_"
         }
         throw $e
      } finally {
         $WarningPreference = $PrevWarningPreference
      }
   }
}
