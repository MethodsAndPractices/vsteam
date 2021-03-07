using System.Diagnostics.CodeAnalysis;
using System.Management.Automation.Abstractions;

namespace vsteam_lib
{
   public class BuildCompleter : BaseProjectCompleter
   {
      /// <summary>
      /// This constructor is used when running in a PowerShell session. It cannot be
      /// loaded in a unit test.
      /// </summary>
      [ExcludeFromCodeCoverage]
      public BuildCompleter() : base("Get-VSTeamBuild", "BuildNumber", true) { }

      /// <summary>
      /// This constructor is used during unit testings
      /// </summary>
      /// <param name="powerShell">fake instance of IPowerShell used for testing</param>
      internal BuildCompleter(IPowerShell powerShell) : base("Get-VSTeamBuild", "BuildNumber", true, powerShell) { }
   }
}
