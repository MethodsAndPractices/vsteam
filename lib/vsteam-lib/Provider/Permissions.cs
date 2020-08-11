using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   internal class Permissions : Directory
   {
      public Permissions(string name, IPowerShell powerShell) : base(name, null, null, powerShell, null)
      {
         this.DisplayMode = "d-r-s-";
      }

      public Permissions(string name) : this(name, new PowerShellWrapper(RunspaceMode.CurrentRunspace)) { }

      protected override object[] GetChildren()
      {
         return new object[]
         {
            new Groups("Groups", this.PowerShell),
            new Users("Users", this.PowerShell)
         };
      }
   }
}
