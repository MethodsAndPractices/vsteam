function Update-VSTeamWorkItem {
   [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Medium",
    HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Update-VSTeamWorkItem')]
   param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
      [int] $Id,

      [Parameter(Mandatory = $false)]
      [string]$Title,

      [Parameter(Mandatory = $false)]
      [string]$Description,

      [Parameter(Mandatory = $false)]
      [string]$IterationPath,

      [Parameter(Mandatory = $false)]
      [string]$AssignedTo,

      [Parameter(Mandatory = $false)]
      [PSCustomObject[]]$Relations,

      [Parameter(Mandatory = $false)]
      [hashtable]$AdditionalFields,

      [switch] $Force
   )

   Process {
      # Constructing the contents to be send.
      # Empty parameters will be skipped when converting to json.
      [Array]$body = @(
         @{
            op    = "add"
            path  = "/fields/System.Title"
            value = $Title
         }
         @{
            op    = "add"
            path  = "/fields/System.Description"
            value = $Description
         }
         @{
            op    = "add"
            path  = "/fields/System.IterationPath"
            value = $IterationPath
         }
         @{
            op    = "add"
            path  = "/fields/System.AssignedTo"
            value = $AssignedTo
         }) | Where-Object { $_.value }

      foreach ($relation in $Relations) {
         switch ($relation.Operation) {
            "add" {
                  $body += @{
                     op = $relation.Operation
                     path = "/relations/-"
                     value = @{
                        rel = $relation.RelationType
                        url = _buildRequestURI -area "wit" -resource "workItems" -id $relation.Id
                        attributes = @{
                           comment = $relation.Comment
                        }
                     }
                  }
            }
            "remove" {
               $body += @{
                  op = $relation.Operation
                  path = "/relations/$($relation.Index)"
               }
            }
            "replace" {
               $body += @{
                  op = $relation.Operation
                  path = "/relations/$($relation.Index)/attributes/comment"
                  value = $relation.Comment
               }
            }
         }
      }

      #this loop must always come after the main work item fields defined in the function parameters
      if ($AdditionalFields) {
         foreach ($fieldName in $AdditionalFields.Keys) {

            #check that main properties are not added into the additional fields hashtable
            $foundFields = $body | Where-Object { $null -ne $_ -and $_.path -like "*$fieldName" }
            if ($null -ne $foundFields) {
               throw "Found duplicate field '$fieldName' in parameter AdditionalFields, which is already a parameter. Please remove it."
            }
            else {
               $body += @{
                  op    = "add"
                  path  = "/fields/$fieldName"
                  value = $AdditionalFields[$fieldName]
               }
            }
         }
      }

      # It is very important that even if the user only provides
      # a single value above that the item is an array and not
      # a single object or the call will fail.
      # You must call ConvertTo-Json passing in the value and not
      # not using pipeline.
      # https://stackoverflow.com/questions/18662967/convertto-json-an-array-with-a-single-item
      $json = ConvertTo-Json @($body) -Compress -Depth 100

      # Call the REST API
      if ($Force -or $pscmdlet.ShouldProcess($Id, "Update-WorkItem")) {
         $resp = _callAPI -Method PATCH -NoProject `
            -Area wit `
            -Resource workitems `
            -id $Id `
            -ContentType 'application/json-patch+json; charset=utf-8' `
            -Body $json `
            -Version $(_getApiVersion Core)

         _applyTypesToWorkItem -item $resp

         return $resp
      }
   }
}