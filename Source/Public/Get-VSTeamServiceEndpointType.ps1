function Get-VSTeamServiceEndpointType {
   [CmdletBinding()]
   param(
      [Parameter(ParameterSetName = 'ByType')]
      [string] $Type,

      [Parameter(ParameterSetName = 'ByType')]
      [string] $Scheme
   )

   Process {

      if ($Type -ne '' -or $Scheme -ne '') {

         if ($Type -ne '' -and $Scheme -ne '') {
            $body = @{
               type   = $Type
               scheme = $Scheme
            }
         }
         elseif ($Type -ne '') {
            $body = @{
               type = $Type
            }
         }
         else {
            $body = @{
               scheme = $Scheme
            }
         }

         # Call the REST API
         $resp = _callAPI -Area 'distributedtask' -Resource 'serviceendpointtypes'  `
            -Version $(_getApiVersion ServiceEndpoints) -body $body
      }
      else {
         # Call the REST API
         $resp = _callAPI -Area 'distributedtask' -Resource 'serviceendpointtypes'  `
            -Version $(_getApiVersion ServiceEndpoints)
      }


      # Apply a Type Name so we can use custom format view and custom type extensions
      foreach ($item in $resp.value) {
         _applyTypesToServiceEndpointType -item $item
      }

      return $resp.value
   }
}