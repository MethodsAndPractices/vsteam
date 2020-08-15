using System.Management.Automation.Abstractions;

namespace vsteam_lib.Provider
{
   internal class Permissions : Directory
   {
      public Permissions(string name, IPowerShell powerShell) :
         base(name, null, powerShell)
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
