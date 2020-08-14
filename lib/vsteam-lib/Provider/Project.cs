using System.Management.Automation;
using System.Management.Automation.Abstractions;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class Project : Directory
   {
      public Project(PSObject obj) :
         base(obj, obj.GetValue("name"), null, new PowerShellWrapper(RunspaceMode.CurrentRunspace), obj.GetValue("name"))
      {

      }

      protected override object[] GetChildren()
      {
         return new object[]
         {
            new Directory(null, "Build Definitions", "BuildDefinition", this.PowerShell, this.Name),
            new Directory(null, "Builds", "Build", this.PowerShell, this.Name),
            new Directory(null, "Queues", "Queue", this.PowerShell, this.Name),
            new Directory(null, "Release Definitions", "ReleaseDefinition", this.PowerShell, this.Name),
            new Directory(null, "Releases", "Release", this.PowerShell, this.Name),
            new Directory(null, "Repositories", "Repository", this.PowerShell, this.Name),
            new Directory(null, "Teams", "Team", this.PowerShell, this.Name),
         };
      }
   }
}
