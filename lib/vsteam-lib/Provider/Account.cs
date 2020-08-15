using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   public class Account : Directory
   {
      /// <summary>
      /// This is called by unit testing framework and other constructors
      /// </summary>
      /// <param name="name"></param>
      /// <param name="powerShell"></param>
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
      [ExcludeFromCodeCoverage]
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

         if (Versions.TestGraphSupport())
         {
            menus.Add(new Permissions("Permissions", this.PowerShell));
         }

         // This will add any projects
         menus.AddRange(base.GetChildren());

         return menus.ToArray();
      }
   }
}
