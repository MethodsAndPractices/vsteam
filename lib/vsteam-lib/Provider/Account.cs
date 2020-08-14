using System.Collections.Generic;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class Account : Directory
   {
      public Account(string name, IPowerShell powerShell) :
         base(name, "Project", powerShell)
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
            new Directory("Agent Pools", "Pool", this.PowerShell),
            new Directory("Extensions", "Extension", this.PowerShell),
            new Directory("Feeds", "Feed", this.PowerShell)
         };

         // TODO: Only show on supported servers
         menus.Add(new Permissions("Permissions", this.PowerShell));

         // This will add any projects
         menus.AddRange(base.GetChildren());

         return menus.ToArray();
      }
   }
}
