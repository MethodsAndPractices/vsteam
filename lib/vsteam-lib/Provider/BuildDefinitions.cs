using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class BuildDefinitions : Directory
   {
      //new Directory(null, "Build Definitions", "BuildDefinition", this.PowerShell, this.Name),

      public BuildDefinitions(IPowerShell powerShell, string projectName) :
         base(null, "Build Definitions", "BuildDefinition", powerShell, projectName)
      {

      }
   }
}
