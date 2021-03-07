# Adds a work item to your project.
#
# Get-VSTeamOption 'wit' 'workItems'
# id              : 62d3d110-0047-428c-ad3c-4fe872c91c74
# area            : wit
# resourceName    : workItems
# routeTemplate   : {project}/_apis/{area}/{resource}/${type}
# http://bit.ly/Add-VSTeamWorkItem

function Add-VSTeamWorkItem {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Add-VSTeamWorkItem')]
   param(
      [Parameter(Mandatory = $true)]
      [string] $Title,

      [Parameter(Mandatory = $false)]
      [string] $Description,

      [Parameter(Mandatory = $false)]
      [string] $IterationPath,

      [Parameter(Mandatory = $false)]
      [string] $AssignedTo,

      [Parameter(Mandatory = $false)]
      [int] $ParentId,

      [Parameter(Mandatory = $false)]
      [hashtable] $AdditionalFields,

      [Parameter(ValueFromPipelineByPropertyName = $true)]
      [vsteam_lib.ProjectValidateAttribute($false)]
      [ArgumentCompleter([vsteam_lib.ProjectCompleter])]
      [string] $ProjectName,

      [Parameter(Mandatory = $true)]
      [vsteam_lib.WorkItemTypeValidateAttribute()]
      [ArgumentCompleter([vsteam_lib.WorkItemTypeCompleter])]
      [string] $WorkItemType
   )

   Process {
      # The type has to start with a $
      # We can't reasign to $WorkItemType because the validate attribute
      # above will fire again and throw exception.
      $fullWorkItemType = '$' + $WorkItemType

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

      if ($ParentId) {
         $parentUri = _buildRequestURI -ProjectName $ProjectName -Area 'wit' -Resource 'workitems' -id $ParentId
         $body += @{
            op    = "add"
            path  = "/relations/-"
            value = @{
               "rel" = "System.LinkTypes.Hierarchy-Reverse"
               "url" = $parentURI
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
      $json = ConvertTo-Json @($body) -Compress

      # Call the REST API
      $resp = _callAPI -Method POST -ProjectName $ProjectName `
         -Area "wit" `
         -Resource "workitems" `
         -id $fullWorkItemType `
         -Body $json `
         -ContentType 'application/json-patch+json' `
         -Version $(_getApiVersion Core)

      _applyTypesToWorkItem -item $resp

      return $resp
   }
}