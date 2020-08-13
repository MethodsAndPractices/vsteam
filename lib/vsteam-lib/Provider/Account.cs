using System.Collections.Generic;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class Account : Directory
   {
      public Account(string name, IPowerShell powerShell) :
         base(name, "Get-VSTeamProject", "Team.Provider.Project", powerShell)
      {
         // Invalidate any cache of projects
         ProjectCache.Invalidate();
      }

      /// <summary>
      /// This will be called by SHiPS when a new drive is added.
      /// </summary>
      /// <param name="name"></param>
      public Account(string name) :
         this(name, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }

      protected override object[] GetChildren()
      {
         var menus = new List<object>()
         {
            new Directory("Agent Pools", "Get-VSTeamPool", "Team.Provider.Pool", this.PowerShell),
            new Directory("Extensions", "Get-VSTeamExtension", "Team.Provider.Extension", this.PowerShell),
            new Directory("Feeds", "Get-VSTeamFeed", "Team.Provider.Feed", this.PowerShell)
         };

         // TODO: Only show on supported servers
         menus.Add(new Permissions("Permissions", this.PowerShell));

         // This will add any projects
         menus.AddRange(base.GetChildren());

         return menus.ToArray();
      }
   }
}
