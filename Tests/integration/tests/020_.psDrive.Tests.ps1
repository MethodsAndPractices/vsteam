$global:skippedOnTFS = ($env:ACCT -like "http://*")

Describe "PS Drive Full exercise" {
   BeforeAll {
      . "$PSScriptRoot/_testInitialize.ps1"

      Write-Verbose "      SkippedOnTFS: $($global:skippedOnTFS)"

      Set-TestPrep
      $target = Set-Project

      $originalLocation = Get-Location
   }

   Context 'PS Drive full exercise' {
      BeforeAll {
         New-PSDrive -Name int -PSProvider SHiPS -Root 'VSTeam#vsteam_lib.Provider.Account'
         $actual = Set-Location int: -PassThru
      }

      It 'Should be able to mount drive' {
         $actual | Should -Not -Be $null
      }

      It "ItName" {
         $actual = Get-ChildItem | Out-string
         $lines = $actual -split "`n"
         # Now you can test line by line
      }

      It 'Should list Agent Pools' {
         Push-Location         
         Set-Location 'Agent Pools'
         $items = Get-ChildItem
         Pop-Location

         $items | Should -Not -Be $null
      }

      It 'Should list Extensions' {
         Push-Location         
         Set-Location 'Extensions'
         $items = Get-ChildItem
         Pop-Location

         $items | Should -Not -Be $null
      }

      # The point of this tests is to make sure no exceptions
      # are thrown when calling Get-ChildItem
      It 'Should list Feeds' -Skip:$skippedOnTFS {
         Push-Location         
         Set-Location 'Feeds'
         $items = Get-ChildItem
         Pop-Location

         # There are no feeds on this account
         $items | Should -Be $null
      }

      It 'Should list projects' {
         $projects = Get-ChildItem
         $projects | Should -Not -Be $null
      }

      It 'Should list Builds, Releases and Teams under project' {
         Set-Location $target.Name
         $projectChildren = Get-ChildItem
         Start-Sleep -Seconds 2
         $projectChildren | Should -Not -Be $null
      }

      It 'Should list Queues' {
         Push-Location         
         Set-Location 'Queues'
         $items = Get-ChildItem
         Pop-Location

         $items | Should -Not -Be $null
      }

      It 'Should list Repositories' {
         Push-Location         
         Set-Location 'Repositories'
         $repos = Get-ChildItem
         Pop-Location

         $repos | Should -Not -Be $null
      }

      It 'Should list Teams' {
         Push-Location
         Start-Sleep -Seconds 2
         Set-Location 'Teams'
         Start-Sleep -Seconds 2
         $teamsChildren = Get-ChildItem
         Pop-Location

         $teamsChildren | Should -Not -Be $null
      }
   }

   AfterAll {
      # Put everything back
      Set-Location $originalLocation
   }
}