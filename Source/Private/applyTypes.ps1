# Apply types to the returned objects so format and type files can
# identify the object and act on it.
function _applyTypes {
   [CmdletBinding()]
   param(
      $item,
      $type
   )

   $item.PSObject.TypeNames.Insert(0, $type)
}

function _applyTypesWorkItemType {
   [CmdletBinding()]
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.WorkItemType')
}

function _applyTypesToWorkItem {
   [CmdletBinding()]
   param($item)

   # If there are ids in the list that don't map to a work item and empty
   # entry is returned in its place if ErrorPolicy is Omit.
   if ($item) {
      $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.WorkItem')
   }
}

function _applyTypesToWiql {
   [CmdletBinding()]
   param($item)
   if ($item) {
      $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.Wiql')
   }
}

function _applyTypesToTfvcBranch {
   [CmdletBinding()]
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.TfvcBranch')
}

function _applyTypesToTeamMember {
   [CmdletBinding()]
   param(
      [Parameter(Mandatory = $true)]
      $item,
      [Parameter(Mandatory = $true)]
      $team,
      [Parameter(Mandatory = $true)]
      $ProjectName
   )

   # Add the team name as a NoteProperty so we can use it further down the pipeline (it's not returned from the REST call)
   $item | Add-Member -MemberType NoteProperty -Name Team -Value $team
   $item | Add-Member -MemberType NoteProperty -Name ProjectName -Value $ProjectName
   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.TeamMember')
}

function _applyTypesToApproval {
   [CmdletBinding()]
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.Approval')
}

function _applyArtifactTypes {
   $item.PSObject.TypeNames.Insert(0, "vsteam_lib.Build.Artifact")

   if ($item.PSObject.Properties.Match('resource').count -gt 0 -and $null -ne $item.resource -and $item.resource.PSObject.Properties.Match('propeties').count -gt 0) {
      $item.resource.PSObject.TypeNames.Insert(0, 'vsteam_lib.Build.Artifact.Resource')
      $item.resource.properties.PSObject.TypeNames.Insert(0, 'vsteam_lib.Build.Artifact.Resource.Properties')
   }
}

function _applyTypesToAzureSubscription {
   [CmdletBinding()]
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.AzureSubscription')
}

function _applyTypesToPolicy {
   [CmdletBinding()]
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.Policy')
}

function _applyTypesToPolicyType {
   [CmdletBinding()]
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.PolicyType')
}

function _applyTypesToPullRequests {
   [CmdletBinding()]
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.PullRequest')
}

function _applyTypesToServiceEndpoint {

   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.ServiceEndpoint')

   $item.createdBy.PSObject.TypeNames.Insert(0, 'vsteam_lib.User')
   $item.authorization.PSObject.TypeNames.Insert(0, 'vsteam_lib.authorization')
   $item.data.PSObject.TypeNames.Insert(0, 'vsteam_lib.ServiceEndpoint.Details')

   if ($item.PSObject.Properties.Match('operationStatus').count -gt 0 -and $null -ne $item.operationStatus) {
      # This is VSTS
      $item.operationStatus.PSObject.TypeNames.Insert(0, 'vsteam_lib.OperationStatus')
   }
}

function _applyTypesToServiceEndpointType {
   [CmdletBinding()]
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.ServiceEndpointType')

   $item.inputDescriptors.PSObject.TypeNames.Insert(0, 'vsteam_lib.InputDescriptor[]')

   foreach ($inputDescriptor in $item.inputDescriptors) {
      $inputDescriptor.PSObject.TypeNames.Insert(0, 'vsteam_lib.InputDescriptor')
   }

   $item.authenticationSchemes.PSObject.TypeNames.Insert(0, 'vsteam_lib.AuthenticationScheme[]')

   foreach ($authenticationScheme in $item.authenticationSchemes) {
      $authenticationScheme.PSObject.TypeNames.Insert(0, 'vsteam_lib.AuthenticationScheme')
   }

   if ($item.PSObject.Properties.Match('dataSources').count -gt 0 -and $null -ne $item.dataSources) {
      $item.dataSources.PSObject.TypeNames.Insert(0, 'vsteam_lib.DataSource[]')

      foreach ($dataSource in $item.dataSources) {
         $dataSource.PSObject.TypeNames.Insert(0, 'vsteam_lib.DataSource')
      }
   }
}

function _applyTypesToVariableGroup {
   [CmdletBinding()]
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.VariableGroup')

   $item.createdBy.PSObject.TypeNames.Insert(0, 'vsteam_lib.User')
   $item.modifiedBy.PSObject.TypeNames.Insert(0, 'vsteam_lib.User')
   if ($item.PSObject.Properties.Match('providerData').count -gt 0 -and $null -ne $item.providerData) {
      $item.providerData.PSObject.TypeNames.Insert(0, 'vsteam_lib.ProviderData')
   }
   $item.variables.PSObject.TypeNames.Insert(0, 'vsteam_lib.Variables')
}

function _applyTypesToYamlPipelineResultType {
   [CmdletBinding()]
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.YamlPipelineResult')
}

function _applyTypesToBuildTimelineResultType {
   [CmdletBinding()]
   param($item)

   $item.PSObject.TypeNames.Insert(0, 'vsteam_lib.BuildTimeline')

   if ($item.PSObject.Properties.Match('records').count -gt 0 -and $null -ne $item.records) {
      $item.records.PSObject.TypeNames.Insert(0, 'vsteam_lib.BuildTimelineRecord[]')

      foreach ($records in $item.records) {
         $records.PSObject.TypeNames.Insert(0, 'vsteam_lib.BuildTimelineRecord')
      }
   }
}
