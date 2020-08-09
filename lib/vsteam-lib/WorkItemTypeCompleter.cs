using System.Diagnostics.CodeAnalysis;
using System.Management.Automation.Abstractions;

namespace vsteam_lib
{
   public class WorkItemTypeCompleter : BaseProjectCompleter
   {
      /// <summary>
      /// This constructor is used when running in a PowerShell session. It cannot be
      /// loaded in a unit test.
      /// </summary>
      [ExcludeFromCodeCoverage]
      public WorkItemTypeCompleter() : base("Get-VSTeamWorkItemType", "Name", false) { }

      /// <summary>
      /// This constructor is used during unit testings
      /// </summary>
      /// <param name="powerShell">fake instance of IPowerShell used for testing</param>
      internal WorkItemTypeCompleter(IPowerShell powerShell) : base("Get-VSTeamWorkItemType", "Name", false, powerShell) { }
   }
}
