Set-StrictMode -Version Latest

Describe 'Common' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath -private
      . "$baseFolder/Source/Public/Get-VSTeamProject.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamGitRepository.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamBuildDefinition.ps1"
      . "$baseFolder/Source/Public/Get-VSTeamReleaseDefinition.ps1"
   }

   context '_callAPI' {
      BeforeAll {
         Mock Invoke-RestMethod
         Mock _getApiVersion { return '1.0-unitTests' }
         Mock _getInstance { return 'https://dev.azure.com/test' }
      }

      It 'Disable-VSTeamAgent' {
         $item = 950
         $PoolId = 36

         _callAPI -Method PATCH -NoProject `
            -Area "distributedtask/pools/$PoolId" `
            -Resource "agents" `
            -Id $item `
            -Body "{'enabled':false,'id':$item,'maxParallelism':1}" `
            -Version $(_getApiVersion DistributedTaskReleased)

         Should -Invoke Invoke-RestMethod -Exactly -Times 1 -Scope It -ParameterFilter {
            # The write-host below is great for seeing how many ways the mock is called.
            # Write-Host "Assert Mock $Uri"
            $Method -eq 'Patch' -and
            $Body -eq "{'enabled':false,'id':950,'maxParallelism':1}" -and
            $Uri -eq "https://dev.azure.com/test/_apis/distributedtask/pools/36/agents/950?api-version=$(_getApiVersion DistributedTaskReleased)"
         }
      }
   }
   
   Context '_getPermissionInheritanceInfo' {
      BeforeAll {
         Mock Get-VSTeamBuildDefinition { Open-SampleFile 'Get-BuildDefinition_AzD.json' -ReturnValue }
         Mock Get-VSTeamProject { Open-SampleFile 'Get-VSTeamProject-NamePeopleTracker.json' }
         Mock Get-VSTeamReleaseDefinition { Open-SampleFile 'Get-VSTeamReleaseDefinition.json' -ReturnValue }
         Mock Get-VSTeamGitRepository { Open-SampleFile 'Get-VSTeamGitRepository-ProjectNamePeopleTracker-NamePeopleTracker.json' }
      }

      It 'Should return an object with build def details' {
         $actual = _getPermissionInheritanceInfo -ProjectName 'PeopleTracker' -ResourceName 'PTracker-CI' -ResourceType 'BuildDefinition'

         $actual | Should -not -Be $null
         $actual.Token | Should -Be "00000000-0000-0000-0000-000000000000/23"
         $actual.SecurityNamespaceID | Should -Be "33344d9c-fc72-4d6f-aba5-fa317101a7e9"
      }

      It 'Should return an object with release def details' {
         $actual = _getPermissionInheritanceInfo -ProjectName 'PeopleTracker' -ResourceName 'PTracker-CD' -ResourceType 'ReleaseDefinition'

         $actual | Should -not -Be $null
         $actual.SecurityNamespaceID | Should -Be "c788c23e-1b46-4162-8f5e-d7585343b5de"
         $actual.Token | Should -Be "00000000-0000-0000-0000-000000000000//2"
      }

      It 'Should return an object with repository details' {
         $actual = _getPermissionInheritanceInfo -ProjectName 'PeopleTracker' -ResourceName 'PeopleTracker' -ResourceType 'Repository'

         $actual | Should -not -Be $null
         $actual.SecurityNamespaceID | Should -Be "2e9eb7ed-3c0a-47d4-87c1-0ffdd275fd87"
         $actual.Token | Should -Be "repoV2/00000000-0000-0000-0000-000000000000/00000000-0000-0000-0000-000000000000"
      }
   }

   Context '_convertSecureStringTo_PlainText' {
      It 'Should return plain text' {
         $emptySecureString = ConvertTo-SecureString 'Test String' -AsPlainText -Force

         $actual = _convertSecureStringTo_PlainText -SecureString $emptySecureString

         $actual | Should -Be 'Test String'
      }
   }

   Context '_buildProjectNameDynamicParam set Alias' {
      It 'Should set the alias of dynamic parameter' {
         $actual = _buildProjectNameDynamicParam -AliasName TestAlias
         $actual["ProjectName"].Attributes[1].AliasNames | Should -Be 'TestAlias'
      }
   }

   Context '_getUserAgent on Mac' {
      BeforeAll {
         Mock Get-OperatingSystem { return 'macOS' }
         [vsteam_lib.Versions]::ModuleVersion = '0.0.0'

         $actual = _getUserAgent
      }

      It 'Should return User Agent for macOS' {
         $actual | Should -BeLike '*macOS*'
      }

      It 'Should return User Agent for Module Version' {
         $actual | Should -BeLike '*0.0.0*'
      }

      It 'Should return User Agent for PowerShell Version' {
         $actual | Should -BeLike "*$($PSVersionTable.PSVersion.ToString())*"
      }
   }

   Context '_getUserAgent on Linux' {
      BeforeAll {
         Mock Get-OperatingSystem { return 'Linux' }
         [vsteam_lib.Versions]::ModuleVersion = '0.0.0'

         $actual = _getUserAgent
      }

      It 'Should return User Agent for Linux' {
         $actual | Should -BeLike '*Linux*'
      }

      It 'Should return User Agent for Module Version' {
         $actual | Should -BeLike '*0.0.0*'
      }

      It 'Should return User Agent for PowerShell Version' {
         $actual | Should -BeLike "*$($PSVersionTable.PSVersion.ToString())*"
      }
   }

   Context '_buildProjectNameDynamicParam' {
      BeforeAll {
         # PreFill the project cache with desired list. This will make sure
         # the project name used will pass validation and Get-VSTeamProject 
         # will not need to be called.
         [vsteam_lib.ProjectCache]::Update([string[]]@("Demo", "Universal"))
      }

      It 'should return dynamic parameter' {
         _buildProjectNameDynamicParam | Should -Not -BeNullOrEmpty
      }
   }

   Context '_buildDynamicParam no defaults' {
      BeforeAll {
         # PreFill the project cache with desired list. This will make sure
         # the project name used will pass validation and Get-VSTeamProject 
         # will not need to be called.
         [vsteam_lib.ProjectCache]::Update([string[]]@("Demo", "Universal"))

         $testParams = @{
            ParameterName                   = 'TestParam'
            arrSet                          = @(@{A = 'A' }, @{B = 'B' })
            Mandatory                       = $true
            ParameterSetName                = "NewTest"
            Position                        = 0
            ParameterType                   = ([hashtable])
            ValueFromPipelineByPropertyName = $false
            AliasName                       = "TestAlieas"
            HelpMessage                     = "Test Help Message"
         }
         $param = (_buildDynamicParam @testParams)
      }

      It 'should return dynamic parameter' {
         $param | Should -Not -BeNullOrEmpty
      }

      It 'should return dynamic parameter name' {
         $param.Name | Should -Be $testParams.ParameterName
      }

      It 'should return dynamic parameter type' {
         $param.ParameterType.FullName | Should -Be $testParams.ParameterType.FullName
      }

      It 'Should set the basic attributes of the dynamic parameter' {
         $param.Attributes[0].Position | Should -Be $testParams.Position
         $param.Attributes[0].Mandatory | Should -Be $testParams.Mandatory
         $param.Attributes[0].ParameterSetName | Should -Be $testParams.ParameterSetName
         $param.Attributes[0].ValueFromPipelineByPropertyName | Should -Be $testParams.ValueFromPipelineByPropertyName
         $param.Attributes[0].HelpMessage | Should -Be $testParams.HelpMessage
      }

      It 'Should set the alias attributes of the dynamic parameter' {
         $param.Attributes[1].AliasNames | Should -Be $testParams.AliasName
      }

      It 'Should set the possible vaule attributes of the dynamic parameter' {
         (Compare-Object -ReferenceObject $param.Attributes[2].ValidValues -DifferenceObject $testParams.arrSet) | Should -BeNullOrEmpty
      }
   }

   Context '_buildDynamicParam defaults' {
      BeforeAll {
         # PreFill the project cache with desired list. This will make sure
         # the project name used will pass validation and Get-VSTeamProject 
         # will not need to be called.
         [vsteam_lib.ProjectCache]::Update([string[]]@("Demo", "Universal"))

         $param = (_buildDynamicParam)
      }

      It 'should return dynamic parameter' {
         $param | Should -Not -BeNullOrEmpty
      }

      It 'should return dynamic parameter name' {
         $param.Name | Should -Be 'QueueName'
      }

      It 'should return dynamic parameter type' {
         $param.ParameterType.FullName | Should -Be ([string]).FullName
      }

      It 'Should set the basic attributes of the dynamic parameter' {
         ($param.Attributes[0].Position -lt 0) | Should -Be ($true)
         $param.Attributes[0].Mandatory | Should -Be $false
         $param.Attributes[0].ParameterSetName | Should -Be '__AllParameterSets'
         $param.Attributes[0].ValueFromPipelineByPropertyName | Should -Be $true
         $param.Attributes[0].HelpMessage | Should -BeNullOrEmpty
      }

      It 'Should have no additoinal attributes of the dynamic parameter' {
         $param.Attributes.Count | Should -Be 1
      }
   }

   Context '_getWorkItemTypes' {
      BeforeAll {
         Mock _getInstance { return $null } -Verifiable
      }

      It 'should return empty array' {
         _getWorkItemTypes -ProjectName test | Should -Be @()
         Should -InvokeVerifiable
      }
   }

   Context '_handleException' {
      # Build a proper error
      BeforeAll {
         $obj = "{Value: {Message: 'Top Message'}, Exception: {Message: 'Test Exception', Response: { StatusCode: '401'}}}"

         if ($PSVersionTable.PSEdition -ne 'Core') {
            $r = [System.Net.HttpWebResponse]::new()
            $e = [System.Net.WebException]::new("Test Exception", $null, [System.Net.WebExceptionStatus]::ProtocolError, $r)
         }
         else {
            $r = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::Unauthorized)
            $e = [Microsoft.PowerShell.Commands.HttpResponseException]::new("Test Exception", $r)
         }
         $ex = Write-Error -Exception $e 2>&1 -ErrorAction Continue
         $ex.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($obj)
      }

      It 'Should Write two warnings' {
         Mock Write-Warning -ParameterFilter { $Message -eq 'An error occurred: Test Exception' -or $Message -eq 'Top Message' } -Verifiable

         _handleException $ex

         Should -InvokeVerifiable
      }
   }

   Context '_handleException should re-throw' {
      BeforeAll {
         $e = [System.Management.Automation.RuntimeException]::new('You must call Set-VSTeamAccount before calling any other functions in this module.')
         $ex = Write-Error -Exception $e 2>&1 -ErrorAction Continue
      }

      It 'Should throw' {

         { _handleException $ex } | Should -Throw
      }
   }

   Context '_handleException message only' {
      # Build a proper error
      BeforeAll {
         $obj = "{Value: {Message: 'Test Exception'}, Exception: {Message: 'Test Exception', Response: { StatusCode: '400'}}}"

         if ($PSVersionTable.PSEdition -ne 'Core') {
            $e = [System.Net.WebException]::new("Test Exception", $null)
         }
         else {
            $r = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::BadRequest)
            $e = [Microsoft.PowerShell.Commands.HttpResponseException]::new("Test Exception", $r)
         }

         $ex = Write-Error -Exception $e 2>&1 -ErrorAction Continue
         $ex.ErrorDetails = [System.Management.Automation.ErrorDetails]::new($obj)
      }

      It 'Should Write one warnings' {
         Mock Write-Warning -ParameterFilter { $Message -eq 'Test Exception' } -Verifiable

         _handleException $ex

         Should -InvokeVerifiable
      }
   }

   Context '_isVSTS' {
      It '.visualstudio.com should return true' {
         _isVSTS 'https://dev.azure.com/test' | Should -Be $true
      }

      It '.visualstudio.com with / should return true' {
         _isVSTS 'https://dev.azure.com/test/' | Should -Be $true
      }

      It 'https://dev.azure.com should return true' {
         _isVSTS 'https://dev.azure.com/test' | Should -Be $true
      }

      It 'https://dev.azure.com with / should return true' {
         _isVSTS 'https://dev.azure.com/test/' | Should -Be $true
      }

      It 'should return false' {
         _isVSTS 'http://localhost:8080/tfs/defaultcollection' | Should -Be $false
      }
   }
}

