Set-StrictMode -Version Latest

Describe 'VSTeamPipelineAuthorization' -Tag 'unit', 'pipeline', 'security' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath

      # Set the account to use for testing. A normal user would do this
      # using the Set-VSTeamAccount function.
      Mock _getInstance { return 'https://dev.azure.com' }

      Mock Invoke-RestMethod {
         return $null
      }

      Mock _getInstance { return "https://dev.azure.com/TestOrg01" }
      Mock _getApiVersion { return '5.1-preview.1' } -ParameterFilter { $Service -eq 'Pipelines' }

      $resourceTypes = @("Queue", "Endpoint", "Environment", "VariableGroup", "SecureFile", "Repository")
      $resourceId = 34
   }

   Context 'Set-VSTeamPipelineAuthorization - retrict to specific resources' {

      It 'should authorize pipeline and all resource types' {

         $resourceTypes | ForEach-Object {
            Set-VSTeamPipelineAuthorization -PipelineIds 1 -ResourceId $resourceId -ResourceType $_ -Authorize $true
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 6 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*allPipelines":{"authorized":false*' -and
            $Body -like '*pipelines":{"authorized":true*'
            $Uri -like "*/_apis/Pipelines/pipelinePermissions/*/$resourceId*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*"
         }
      }

      It 'should remove authorization for pipeline and all resource types' {

         $resourceTypes | ForEach-Object {
            Set-VSTeamPipelineAuthorization -PipelineIds 1 -ResourceId $resourceId -ResourceType $_ -Authorize $false
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 6 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*id":1*' -and
            $Body -like '*allPipelines":{"authorized":false*' -and
            $Body -like '*pipelines":{"authorized":false*' -and
            $Uri -like "*/_apis/Pipelines/pipelinePermissions/*/$resourceId*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*"

         }
      }

      It 'should authorize pipeline for Queue' {

         $resourceTypes | ForEach-Object {
            Set-VSTeamPipelineAuthorization -PipelineIds 1 `
            -ResourceId $resourceId `
            -ResourceType Queue -Authorize $true
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 6 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*allPipelines":{"authorized":false*' -and
            $Body -like '*pipelines":{"authorized":true*'
            $Uri -like "*/_apis/Pipelines/pipelinePermissions/Queue/$resourceId*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*"
         }
      }

      It 'should authorize pipeline for Endpoint' {

         $resourceTypes | ForEach-Object {
            Set-VSTeamPipelineAuthorization -PipelineIds 1 `
            -ResourceId $resourceId `
            -ResourceType Endpoint -Authorize $true
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 6 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*allPipelines":{"authorized":false*' -and
            $Body -like '*pipelines":{"authorized":true*'
            $Uri -like "*/_apis/Pipelines/pipelinePermissions/Endpoint/$resourceId*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*"
         }
      }

      It 'should authorize pipeline for Environment' {

         $resourceTypes | ForEach-Object {
            Set-VSTeamPipelineAuthorization -PipelineIds 1 `
            -ResourceId $resourceId `
            -ResourceType Environment -Authorize $true
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 6 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*allPipelines":{"authorized":false*' -and
            $Body -like '*pipelines":{"authorized":true*'
            $Uri -like "*/_apis/Pipelines/pipelinePermissions/Environment/$resourceId*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*"
         }
      }

      It 'should authorize pipeline for VariableGroup' {

         $resourceTypes | ForEach-Object {
            Set-VSTeamPipelineAuthorization -PipelineIds 1 `
            -ResourceId $resourceId `
            -ResourceType VariableGroup -Authorize $true
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 6 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*allPipelines":{"authorized":false*' -and
            $Body -like '*pipelines":{"authorized":true*'
            $Uri -like "*/_apis/Pipelines/pipelinePermissions/VariableGroup/$resourceId*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*"
         }
      }

      It 'should authorize pipeline for SecureFile' {

         $resourceTypes | ForEach-Object {
            Set-VSTeamPipelineAuthorization -PipelineIds 1 `
            -ResourceId $resourceId `
            -ResourceType SecureFile -Authorize $true
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 6 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*allPipelines":{"authorized":false*' -and
            $Body -like '*pipelines":{"authorized":true*'
            $Uri -like "*/_apis/Pipelines/pipelinePermissions/SecureFile/$resourceId*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*"
         }
      }

      It 'should authorize pipeline for Repository' {

         $resourceTypes | ForEach-Object {
            Set-VSTeamPipelineAuthorization -PipelineIds 1 `
            -ResourceId $resourceId `
            -ResourceType Repository -Authorize $true
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 6 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*allPipelines":{"authorized":false*' -and
            $Body -like '*pipelines":{"authorized":true*'
            $Uri -like "*/_apis/Pipelines/pipelinePermissions/Repository/$resourceId*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*"
         }
      }
   }

   Context 'Set-VSTeamPipelineAuthorization - authorize for all pipelines' {

      It 'should open authorization for pipeline and all resource types' {

         $resourceTypes | ForEach-Object {
            Set-VSTeamPipelineAuthorization -ResourceId $resourceId -ResourceType $_ -AuthorizeAll $true
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 6 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*allPipelines":{"authorized":true*' -and
            $Body -like '*"pipelines":`[`]*' -and
            $Uri -like "*/_apis/Pipelines/pipelinePermissions/*/$resourceId*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*"

         }
      }

      It 'should close authorization for pipeline and all resource types' {

         $resourceTypes | ForEach-Object {
            Set-VSTeamPipelineAuthorization -ResourceId $resourceId -ResourceType $_ -AuthorizeAll $true
         }

         Should -Invoke Invoke-RestMethod -Exactly -Scope It -Times 6 `
            -ParameterFilter {
            $Method -eq 'Patch' -and
            $Body -like '*allPipelines":{"authorized":true*' -and
            $Body -like '*"pipelines":`[`]*' -and
            $Uri -like "*/_apis/Pipelines/pipelinePermissions/*/$resourceId*" -and
            $Uri -like "*api-version=$(_getApiVersion Pipelines)*"

         }
      }

   }
}
