using System.Collections.Generic;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class Account : Directory
   {
      private readonly IPowerShell _powerShell;

      public Account(string name, IPowerShell powerShell) : base(name, "Get-VSTeamProject", "Team.Provider.Project", powerShell, null)
      {
         this._powerShell = powerShell;

         // Invalidate any cache of projects
         ProjectCache.Invalidate();
      }

      /// <summary>
      /// This will be called by SHiPS when a new drive is added.
      /// </summary>
      /// <param name="name"></param>
      public Account(string name) : this(name, new PowerShellWrapper(RunspaceMode.CurrentRunspace)) { }

      protected override object[] GetChildren()
      {
         var menus = new List<object>()
         {
            new AgentPools("Agent Pools", this._powerShell),
            new Extensions("Extensions", this._powerShell),
            new Feeds("Feeds", this._powerShell)
         };

         // TODO: Only show on supported servers
         menus.Add(new Permissions("Permissions", this._powerShell));

         // This will add any projects
         menus.AddRange(base.GetChildren());

         return menus.ToArray();
      }
   }
}
