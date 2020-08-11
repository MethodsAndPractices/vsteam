using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class Extensions : Directory
   {
      public Extensions(string name, IPowerShell powerShell) : base(name, "Get-VSTeamExtension", "Team.Provider.Extension", powerShell, null)
      {
         this.DisplayMode = "d-r-s-";
      }
   }
}
