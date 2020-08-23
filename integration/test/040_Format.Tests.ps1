# Formats play a very important role in VSTeam. Many types define formats for list and table.
# If the type is returned from a function and the provider it needs two different table formats.
# These tests are to ensure that the correct formats are used depending on if the type was returned
# by a function or a Get-ChildItem call to the provider. All the types returned from a provider
# should have 'Provider' in the type name. For example Get-VSTeamJobRequest returns a type of
# vsteam_lib.JobRequest. However, when executed via the provider the type returned is
# Team.Provider.JobRequest. The type name is how the formats are selected.
Set-StrictMode -Version Latest

Describe 'Table Formats for Provider classes' -Tag 'integration' {
   BeforeAll {
      . "$PSScriptRoot/testprep.ps1"

      Set-TestPrep -skipEnvCheck

      function Get-Columns {
         [CmdletBinding()]
         param(
            [Parameter(Mandatory = $true, Position = 0)]
            [string] $typeName
         )

         $gfd = Get-FormatData -TypeName $typeName
         $cols = $gfd | Select-Object @{n = 'cols'; e = { $_.FormatViewDefinition.Control.Headers.Label } } | Select-Object -ExpandProperty cols

         return  $cols
      }
   }

   Context 'Agent' {
      # This is the formatter when returned from the provider
      It 'Team.Provider.Agent should have mode' {
         $cols = Get-Columns -TypeName Team.Provider.Agent

         $cols[0] | Should -Be 'Mode'
      }

      # This is the formatter when returned from a function
      It 'vsteam_lib.Agent should have name' {
         $cols = Get-Columns -TypeName vsteam_lib.Agent

         $cols[0] | Should -Be 'Name'
      }
   }

   Context 'AgentPool' {
      # This is the formatter when returned from the provider
      It 'Team.Provider.AgentPool should have mode' {
         $cols = Get-Columns -TypeName Team.Provider.AgentPool

         $cols[0] | Should -Be 'Mode'
      }

      # This is the formatter when returned from a function
      It 'vsteam_lib.AgentPool should have name' {
         $cols = Get-Columns -TypeName vsteam_lib.AgentPool

         $cols[0] | Should -Be 'Name'
      }
   }

   Context 'Build' {
      # This is the formatter when returned from the provider
      It 'Team.Provider.Build should have mode' {
         $cols = Get-Columns -TypeName Team.Provider.Build

         $cols[0] | Should -Be 'Mode'
         $cols[1] | Should -Be 'Name'
         $cols[2] | Should -Be 'Result'
      }

      # This is the formatter when returned from a function
      It 'Team.Build should have name' {
         $cols = Get-Columns -TypeName vsteam_lib.Build

         $cols[0] | Should -Be 'Name'
         $cols[1] | Should -Be 'Result'
      }
   }

   # Defined in Team.PSDrive.Default.TableView.ps1xml
   # Covers Feeds, Extensions, Agent Pools and other top level
   # nodes that don't map to Azure DevOps types.
   Context 'Directory' {
      # This is the formatter when returned from the provider
      It 'vsteam_lib.Provider.Directory should have mode' {
         $cols = Get-Columns -TypeName vsteam_lib.Provider.Directory

         $cols[0] | Should -Be 'Mode'
      }
   }
   
   Context 'JobRequest' {
      # This is the formatter when returned from the provider
      It 'Team.Provider.JobRequest should have mode' {
         $cols = Get-Columns -TypeName Team.Provider.JobRequest

         $cols[0] | Should -Be 'Mode'
      }

      # This is the formatter when returned from a function
      It 'vsteam_lib.JobRequest should have name' {
         $cols = Get-Columns -TypeName vsteam_lib.JobRequest

         $cols[0] | Should -Be 'Name'
      }
   }

   Context 'Release Definitions' {
      # This is the formatter when returned from the provider
      It 'Team.Provider.JobRequest should have mode' {
         $cols = Get-Columns -TypeName Team.Provider.JobRequest

         $cols[0] | Should -Be 'Mode'
      }

      # This is the formatter when returned from a function
      It 'vsteam_lib.JobRequest should have name' {
         $cols = Get-Columns -TypeName vsteam_lib.JobRequest

         $cols[0] | Should -Be 'Name'
      }
   }
}