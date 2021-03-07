function Show-VSTeamPackage {
   [CmdletBinding(HelpUri='https://methodsandpractices.github.io/vsteam-docs/docs/modules/vsteam/commands/Show-VSTeamPackage')]
   param(
      [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
      [vsteam_lib.Package] $package
   )

   process {
      _hasAccount

      Show-Browser "$(_getInstance)/_packaging?_a=package&feedName=$($package.FeedId)&package=$($package.Name)&protocolType=$($package.ProtocolType)&version=$($p.Versions[0].version)"
   }
}