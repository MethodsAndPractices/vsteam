using System.Diagnostics.CodeAnalysis;
using System.Management.Automation.Abstractions;

namespace vsteam_lib
{
   public class QueryCompleter : BaseProjectCompleter
   {
      /// <summary>
      /// This constructor is used when running in a PowerShell session. It cannot be
      /// loaded in a unit test.
      /// </summary>
      [ExcludeFromCodeCoverage]
      public QueryCompleter() : base("Get-VSTeamQuery", "Name", false) { }

      /// <summary>
      /// This constructor is used during unit testings
      /// </summary>
      /// <param name="powerShell">fake instance of IPowerShell used for testing</param>
      internal QueryCompleter(IPowerShell powerShell) : base("Get-VSTeamQuery", "Name", false, powerShell) { }
   }
}
