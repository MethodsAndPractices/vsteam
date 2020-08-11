using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class Users : Directory
   {
      public Users(string name, IPowerShell powerShell) : base(name, "Get-VSTeamUser", "Team.Provider.User", powerShell, null)
      {
         this.DisplayMode = "d-r-s-";
      }
   }
}
