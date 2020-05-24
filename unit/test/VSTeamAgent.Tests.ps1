Set-StrictMode -Version Latest

Describe "VSTeamAgent" {
   BeforeAll {
      Import-Module SHiPS
      
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      
      . "$PSScriptRoot/../../Source/Classes/VSTeamLeaf.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamDirectory.ps1"
      . "$PSScriptRoot/../../Source/Private/applyTypes.ps1"
      . "$PSScriptRoot/../../Source/Private/common.ps1"
      . "$PSScriptRoot/../../Source/Public/Get-VSTeamJobRequest.ps1"
      . "$PSScriptRoot/../../Source/Classes/VSTeamJobRequest.ps1"
      . "$PSScriptRoot/../../Source/Classes/$sut"
   }
      
   Context "GetChildItem" {
      BeforeAll {
         $resultsAzD = Get-Content "$PSScriptRoot/sampleFiles/jobrequestsAzD.json" -Raw | ConvertFrom-Json
         Mock Get-VSTeamJobRequest {
            $objs = @()

            foreach ($item in $resultsAzD.value) {
               $objs += [VSTeamJobRequest]::new($item)
            }

            Write-Output $objs
         }

         $testAgent = Get-Content "$PSScriptRoot\sampleFiles\agentSingleResult.json" -Raw | ConvertFrom-Json
         $target = [VSTeamAgent]::new($testAgent, 1)
      }

      It "should return child items." {
         $actual = $target.GetChildItem()
         $actual | Should -Not -Be $Null
      }
   }
}