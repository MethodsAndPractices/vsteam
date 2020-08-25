using System.Management.Automation;
using vsteam_lib.Provider;

namespace vsteam_lib
{
   public class UserEntitlement : Leaf
   {
      public string UniqueName { get; set; }
      public string DisplayName { get; set; }

      public UserEntitlement(PSObject obj, string projectName) : 
         base(obj, null, null, projectName)
      {
      }

      public override string ToString() => this.DisplayName;
   }
}
