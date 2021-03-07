using System.Collections.Generic;
using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Releases : Directory
   {
      public Releases(IPowerShell powerShell, string projectName) :
         base(null, "Releases", "Release", powerShell, projectName)
      {
      }

      protected override IEnumerable<PSObject> GetPSObjects()
      {
         this.PowerShell.Commands.Clear();

         var children = this.PowerShell.AddCommand(this.Command)
                                       .AddParameter("ProjectName", this.ProjectName)
                                       .AddParameter("Expand", "Environments")
                                       .AddCommand("Sort-Object")
                                       .AddArgument("name")
                                       .Invoke();

         PowerShellWrapper.LogPowerShellError(this.PowerShell, children);

         // This applies types to select correct formatter.
         return children.AddTypeName(this.TypeName);
      }
   }
}
