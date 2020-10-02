Set-StrictMode -Version Latest

Describe 'VSTeamNuGetPackageVersion' {
   BeforeAll {
      . "$PSScriptRoot\_testInitialize.ps1" $PSCommandPath
   }

   Context 'Update-VSTeamNuGetPackageVersion' {
      BeforeAll {
         $env:Team_TOKEN = '1234'
         Mock _callAPI { Open-SampleFile 'Get-VSTeamPackageVersion.json' -Index 0 }
      }

      AfterAll {
         $env:TEAM_TOKEN = $null
      }

      # id              : 36c9353b-e250-4c57-b040-513c186c3905
      # area            : nuget
      # resourceName    : Versions
      # routeTemplate   : {project}/_apis/packaging/feeds/{feedId}/{area}/packages/{packageName}/{resource}/{packageVersion}
      It 'Should unlist version' {
         Update-VSTeamNuGetPackageVersion -FeedId 'feedName' -packageName 'packageName' -packageVersion '1137.0.0' -isListed $false -Force

         Should -Invoke _callAPI -Exactly 1 -Scope It -ParameterFilter {
            $Method -eq 'Patch' -and
            $Area -eq 'packaging/feeds/feedName/nuget' -and
            $Resource -eq 'packages/packageName/Versions' -and
            $subDomain -eq 'pkgs' -and
            $version -eq [vsteam_lib.Versions]::Packaging
         }
      }
   }
}