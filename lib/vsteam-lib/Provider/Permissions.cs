using System.Management.Automation;
using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   internal class Permissions : Directory
   {
      public Permissions(string name, IPowerShell powerShell) : 
         base(name, null, powerShell)
      {
      }

      public Permissions(string name) : 
         this(name, new PowerShellWrapper(RunspaceMode.CurrentRunspace))
      {
      }

      protected override object[] GetChildren()
      {
         return new object[]
         {
            new Directory("Groups", "Group", this.PowerShell),
            new Directory("Users", "User", this.PowerShell),
         };
      }
   }
}
