using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class BuildDefinitions : Directory
   {
      public BuildDefinitions(IPowerShell powerShell, string projectName) :
         base(null, "Build Definitions", "BuildDefinition", powerShell, projectName)
      {
      }
   }
}
