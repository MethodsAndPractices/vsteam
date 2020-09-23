using System.Diagnostics.CodeAnalysis;
using System.Management.Automation.Abstractions;

namespace vsteam_lib
{
   public class ReleaseDefinitionCompleter : BaseProjectCompleter
   {
      /// <summary>
      /// This constructor is used when running in a PowerShell session. It cannot be
      /// loaded in a unit test.
      /// </summary>
      [ExcludeFromCodeCoverage]
      public ReleaseDefinitionCompleter() : base("Get-VSTeamReleaseDefinition", "Name", false) { }

      /// <summary>
      /// This constructor is used during unit testings
      /// </summary>
      /// <param name="powerShell">fake instance of IPowerShell used for testing</param>
      internal ReleaseDefinitionCompleter(IPowerShell powerShell) : base("Get-VSTeamReleaseDefinition", "Name", false, powerShell) { }
   }
}
