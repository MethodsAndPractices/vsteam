function Get-VSTeamWiql {
   [CmdletBinding(DefaultParameterSetName = 'ByID')]
   param(
      [Parameter(ParameterSetName = 'ByID', Mandatory = $true, Position = 0)]
      [string] $Id,

      [Parameter(ParameterSetName = 'ByQuery', Mandatory = $true, Position = 0)]
      [string] $Query,

      [Parameter(Mandatory = $true, Position = 1)]
      [string] $Team,

      [int] $Top = 100,

      [Switch] $TimePrecision,

      [Switch] $Expand
   )
   DynamicParam {
      #$arrSet = Get-VSTeamProject | Select-Object -ExpandProperty Name
      _buildProjectNameDynamicParam -mandatory $true #-arrSet $arrSet      
   }

   Process {
      
      # Bind the parameter to a friendly variable
      $ProjectName = $PSBoundParameters["ProjectName"]

      $QueryString = @{
         '$top'        = $Top
         timePrecision = $TimePrecision
      }

      # Call the REST API
      if ($Query) {

         $body = (@{
               query = $Query
            }) | ConvertTo-Json

         $resp = _callAPI -ProjectName $ProjectName -Team $Team -Area 'wit' -Resource 'wiql'  `
            -method "POST" -ContentType "application/json" `
            -Version $([VSTeamVersions]::Core) `
            -Querystring $QueryString `
            -Body $body
      }
      else {
         $resp = _callAPI -ProjectName $ProjectName -Team $Team -Area 'wit' -Resource 'wiql'  `
            -Version $([VSTeamVersions]::Core) -id "$Id" `
            -Querystring $QueryString
      }

      if ($Expand) {
         
         [array]$Ids = $resp.workItems.id
         $Fields = $resp.columns.referenceName
      
         $resp.workItems = @()
         #splitting id array by 200, since a maximum of 200 ids are allowed per call   
         $countIds = $Ids.Count    
         $resp.workItems = for ($beginRange = 0; $beginRange -lt $countIds; $beginRange += 200) {

            $endRange = ($beginRange + 199)
            
            if ($endRange -gt $countIds) {
               $idArray = $Ids[$beginRange..($countIds - 1)]
            }
            else {
               $idArray = $Ids[$beginRange..($endRange)]
            }
            
            (Get-VSTeamWorkItem -Fields $Fields -Ids $idArray).value
         }
      
      }

      _applyTypesToWiql -item $resp

      return $resp
   }
}