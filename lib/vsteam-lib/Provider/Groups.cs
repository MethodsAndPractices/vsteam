using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class Groups : Directory
   {
      public Groups(string name, IPowerShell powerShell) : base(name, "Get-VSTeamGroup", "Team.Provider.Group", powerShell, null)
      {
         this.DisplayMode = "d-r-s-";
      }
   }
}
