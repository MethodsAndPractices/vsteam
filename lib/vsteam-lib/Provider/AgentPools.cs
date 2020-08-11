using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class AgentPools : Directory
   {
      public AgentPools(string name, IPowerShell powerShell) : base(name, "Get-VSTeamPool", "Team.Provider.Pool", powerShell, null)
      {
         this.DisplayMode = "d-r-s-";
      }
   }
}
