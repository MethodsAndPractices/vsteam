using System;
using System.Collections.Generic;
using System.Management.Automation.Abstractions;
using System.Text;

namespace vsteam_lib.Provider
{
   class Permissions : Directory
   {
      public Permissions(string name, IPowerShell powerShell) : base(name, null, null, powerShell, null)
      {
         this.DisplayMode = "d-r-s-";
      }

      public Permissions(string name) : this(name, new PowerShellWrapper()) { }

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
