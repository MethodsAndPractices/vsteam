using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class Feeds : Directory
   {
      public Feeds(string name, IPowerShell powerShell) : base(name, "Get-VSTeamFeed", "Team.Provider.Feed", powerShell, null)
      {
         this.DisplayMode = "d-r-s-";
      }
   }
}
